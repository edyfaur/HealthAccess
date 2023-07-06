//
//  UserProfileView.swift
//  HealthAccess
//
//  Created by Edward Faur on 26.05.2023.
//

import SwiftUI
import FirebaseAnalyticsSwift

struct UserProfileView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @Environment(\.dismiss) var dismiss
    @State var presentingConfirmationDialog = false
    
    private func deleteAccount() {
        Task {
            if await viewModel.deleteAccount() == true {
                dismiss()
            }
        }
    }
    
    private func signOut() {
        viewModel.signOut()
    }
    
    var body: some View{
        VStack(alignment: .center) {
            Spacer()
            Image(systemName: "person.fill")
                .resizable()
                .frame(width: 100 , height: 100)
                .aspectRatio(contentMode: .fit)
                .clipShape(Circle())
                .clipped()
                .padding(4)
                .overlay(Circle().stroke(Color.accentColor, lineWidth: 2))
            Section("User") {
                Text(viewModel.displayName)
            }
            Section {
                Button(role: .cancel, action: signOut) {
                    VStack {
                        Spacer()
                        Text("Sign out")
                        Spacer()
                    }
                }
                .background(Color("Color 1"))
                .cornerRadius(5)
            }
            Section {
                Button(role: .destructive, action: { presentingConfirmationDialog.toggle() }) {
                    VStack {
                        Spacer()
                        Text("Delete Account")
                        Spacer()
                    }
                }
                .background(Color("Color 1"))
                .cornerRadius(5)
                Spacer()
            }
            .navigationTitle("Profile")
            .analyticsScreen(name: "\(Self.self)")
            .confirmationDialog("Deleting your account is permanent. Do you want to delete your account?",
                                isPresented: $presentingConfirmationDialog, titleVisibility: .visible) {
                Button("Delete Account", role: .destructive, action: deleteAccount)
                Button("Cancel", role: .cancel, action: { })
                Spacer()
            }
        }
        .frame(minWidth: 400,minHeight: 400)
        
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            
            UserProfileView()
            
                .environmentObject(AuthenticationViewModel())
        }
    }
}
