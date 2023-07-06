//
//  AuthenticationViewModel.swift
//  HealthAccess
//
//  Created by Edward Faur on 25.05.2023.
//

import SwiftUI
import AppKit
import Foundation
import FirebaseAuth

enum AuthenticationState {
    case unauthenticated
    case authenticating
    case authenticated
}

enum AuthenticationFlow {
    case login
    case signUp
}

@MainActor
class AuthenticationViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var name = ""
    
    @Published var flow: AuthenticationFlow = .login
    
    @Published var isValid  = false
    @Published var authenticationState: AuthenticationState = .unauthenticated
    @Published var errorMessage = ""
    @Published var isEmailVerified = false
    @Published var user: User?
    @Published var displayName = ""
    
    
    init() {
        registerAuthStateHandler()
        
        $flow
            .combineLatest($email, $password, $confirmPassword)
            .map { flow, email, password, confirmPassword in
                flow == .login
                ? !(email.isEmpty || password.isEmpty)
                : !(email.isEmpty || password.isEmpty || confirmPassword.isEmpty)
            }
            .assign(to: &$isValid)
    }
    
    private var authStateHandler: AuthStateDidChangeListenerHandle?
    
    func registerAuthStateHandler() {
        if authStateHandler == nil {
            authStateHandler = Auth.auth().addStateDidChangeListener { auth, user in
                self.user = user
                self.authenticationState = user == nil ? .unauthenticated : .authenticated
                self.displayName = user?.displayName ?? ""
            }
        }
    }
    
    func switchFlow() {
        flow = flow == .login ? .signUp : .login
        errorMessage = ""
    }
    
    private func wait() async {
        do {
            print("Wait")
            try await Task.sleep(nanoseconds: 1_000_000_000)
            print("Done")
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func reset() {
        flow = .login
        email = ""
        password = ""
        confirmPassword = ""
        name = ""
    }
    
    func getUserRole(completion: @escaping (String?, Error?) -> Void) {
            if let user = Auth.auth().currentUser {
                user.getIDTokenResult { (result, error) in
                    if let error = error {
                        completion(nil, error)
                        return
                    }
                    
                    if let claims = result?.claims {
                        if let role = claims["role"] as? String {
                            completion(role, nil)
                        } else {
                            completion(nil, NSError(domain: "com.example.app", code: 0, userInfo: [NSLocalizedDescriptionKey: "Atributul 'role' nu este setat sau nu este de tipul așteptat."]))
                        }
                    } else {
                        completion(nil, NSError(domain: "com.example.app", code: 0, userInfo: [NSLocalizedDescriptionKey: "Nu s-au găsit claims-uri pentru utilizator."]))
                    }
                }
            } else {
                completion(nil, NSError(domain: "com.example.app", code: 0, userInfo: [NSLocalizedDescriptionKey: "Utilizatorul nu este autentificat."]))
            }
        }
}

// MARK: - Email and Password Authentication

extension AuthenticationViewModel {
   
    
    func signInWithEmailPassword() async -> Bool {
        authenticationState = .authenticating
        do {
            let result = try await Auth.auth().signIn(withEmail: self.email, password: self.password)
            
            if result.user.isEmailVerified {
                // User email is verified, allow sign-in
                return true
            } else {
                // User email is not verified, prevent sign-in
                errorMessage = "Please verify your email before signing in."
                authenticationState = .unauthenticated
                return false
            }
        } catch {
            print(error)
            errorMessage = error.localizedDescription
            authenticationState = .unauthenticated
            return false
        }
    }
    
    
    func signUpWithEmailPassword() async -> Bool {
        authenticationState = .authenticating
        guard password == confirmPassword else {
            errorMessage = "Password and confirm password do not match."
            authenticationState = .unauthenticated
            return false
        }
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            do {
                try await result.user.sendEmailVerification()
                signOut()
                isEmailVerified = result.user.isEmailVerified
            } catch {
                errorMessage = error.localizedDescription
            }
            return true
        } catch {
            print(error)
            errorMessage = error.localizedDescription
            authenticationState = .unauthenticated
            return false
        }
       
    }
   
    func signOut() {
        do {
            try Auth.auth().signOut()
        }
        catch {
            print(error)
            errorMessage = error.localizedDescription
        }
    }
    
    func deleteAccount() async -> Bool {
        do {
            try await user?.delete()
            return true
        }
        catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
}
