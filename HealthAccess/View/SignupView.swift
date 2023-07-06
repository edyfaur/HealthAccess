//
//  SignupView.swift
//  HealthAccess
//
//  Created by Edward Faur on 25.05.2023.
//

import SwiftUI
import FirebaseAnalytics
import FirebaseAnalyticsSwift

private enum FocusableField: Hashable {
    case email
    case password
    case confirmPassword
}


struct SignupView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isEmailVerified = false
    
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @Environment(\.dismiss) var dismiss
    
    @FocusState private var focus: FocusableField?
    private func signUpWithEmailPassword() {
        Task {
            if await viewModel.signUpWithEmailPassword() == true {
                dismiss()
            }
        }
    }
    
    var body: some View {
        VStack {
            Text("Sign Up")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 30)
            
            Group{
                TextField("Nume", text:$viewModel.displayName)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(.vertical,10)
                    .padding(.horizontal)
                    .background(RoundedRectangle(cornerRadius: 2).stroke(Color.gray.opacity(0.7),lineWidth: 1))
                    //.focused($focus, equals:.name)
                    .submitLabel(.next)
                    .onSubmit {
                        self.focus = .email
                    }
                TextField("Email", text:$viewModel.email)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(.vertical,10)
                    .padding(.horizontal)
                    .background(RoundedRectangle(cornerRadius: 2).stroke(Color.gray.opacity(0.7),lineWidth: 1))
                    .focused($focus, equals:.email)
                    .submitLabel(.next)
                    .onSubmit {
                        self.focus = .password
                    }
                
                SecureField("Password", text: $viewModel.password)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(.vertical,10)
                    .padding(.horizontal)
                    .background(RoundedRectangle(cornerRadius: 2).stroke(Color.gray.opacity(0.7),lineWidth: 1))
                    .focused($focus, equals: .password)
                    .submitLabel(.next)
                    .onSubmit {
                        self.focus = .confirmPassword
                    }
                SecureField("Confirm Password", text: $viewModel.confirmPassword)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(.vertical,10)
                    .padding(.horizontal)
                    .background(RoundedRectangle(cornerRadius: 2).stroke(Color.gray.opacity(0.7),lineWidth: 1))
                    .focused($focus, equals: .confirmPassword)
                    .submitLabel(.go)
                    .onSubmit {
                        signUpWithEmailPassword()
                    }
                
                if !viewModel.errorMessage.isEmpty {
                    VStack {
                        Text(viewModel.errorMessage)
                            .foregroundColor(Color(NSColor.systemRed))
                    }
                }
                
                Button(action: signUpWithEmailPassword
                ) {
                    if viewModel.authenticationState != .authenticating{
                        Text("Signup")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color("Color 1"))
                            .cornerRadius(10)
                        
                    }
                    else{
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity)
                        
                    }
                }
                .frame(maxWidth: 100, maxHeight:35)
                .disabled(!viewModel.isValid)
                .buttonStyle(PlainButtonStyle())
                .foregroundColor(.white)
                .background(Color("Color 1"))
                .cornerRadius(5)
                HStack{
                    Text("Already registered?")
                    Button(action: { viewModel.switchFlow() }) {
                        Text("Login")
                            .foregroundColor(.blue)
                            .underline(true, color: .blue)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .frame(maxWidth: 350)
            .padding(.top,10)
            Spacer()
        }
        .frame(maxWidth: .infinity,maxHeight: 300)
        .padding()
        .analyticsScreen(name: "\(SignupView.self)")
        
        
    }
    
}


struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
            .environmentObject(AuthenticationViewModel())
    }
}

