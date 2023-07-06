//
//  HealthAccessApp.swift
//  HealthAccess
//
//  Created by Edward Faur on 25.05.2023.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseAuth


class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
    }
    override init(){
        super.init()
        FirebaseApp.configure()
        //Auth.auth().useEmulator(withHost: "localhost", port: 9099)
    }
}
@main
struct HealthAccessApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            AuthenticatedView{
                Image("logo2")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 500)
                Text("Welcome")
                    .font(.title)
                Text("Please Login")
            }content: {
                ContentView()
            }
            
        }
        .windowStyle(HiddenTitleBarWindowStyle())
        
    }
}


