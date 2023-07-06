//
//  LoginView.swift
//  HealthAccess
//
//  Created by Edward Faur on 25.05.2023.
//

import SwiftUI

private enum FocusableField: Hashable {
    case email
    case password
}

struct LoginView: View {
    //    @State private var email = ""
    //    @State private var password = ""
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @Environment(\.dismiss) var dismiss
    
    @FocusState private var focus: FocusableField?
    
    private func signInWithEmailPassword() {
        Task {
            if await viewModel.signInWithEmailPassword() == true {
                dismiss()
            }
        }
    }
    
    var body: some View {
        VStack {
            
            Text("Login")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 30)
                .frame(alignment: .center)
            
            Group{
                TextField("Email", text: $viewModel.email)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(.vertical,10)
                    .padding(.horizontal)
                    .background(RoundedRectangle(cornerRadius: 2).stroke(Color.gray.opacity(0.7),lineWidth: 1))
                    .disableAutocorrection(true)
                    .focused($focus, equals: .email)
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
                    .submitLabel(.go)
                    .onSubmit {
                        signInWithEmailPassword()
                    }
                
                
                if !viewModel.errorMessage.isEmpty {
                    VStack {
                        Text(viewModel.errorMessage)
                            .foregroundColor (Color(NSColor.systemRed))
                    }
                }
                
                Button(action: signInWithEmailPassword) {
               
                    if viewModel.authenticationState != .authenticating {
                        Text("Login")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color("Color 1"))
                            .cornerRadius(10)
                    }
                    else {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity)
                    }
                    
                }
                .disabled(!viewModel.isValid)
                .frame(maxWidth: 100, maxHeight:35)
                .buttonStyle(PlainButtonStyle())
                .foregroundColor(.white)
                .background(Color("Color 1"))
                .cornerRadius(5)
                
                HStack{
                    Text("Don't have an account yet?")
                    Button(action: { viewModel.switchFlow() }) {
                        Text("Sign up")
                            .foregroundColor(.blue)
                            .underline(true, color: .blue)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .frame(maxWidth: 350)
            .padding(.top,10)
        }
        .padding()
        .frame(maxWidth:.infinity,maxHeight: 300)
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LoginView()
            LoginView()
                .preferredColorScheme(.dark)
        }
        .environmentObject(AuthenticationViewModel())
    }
}
