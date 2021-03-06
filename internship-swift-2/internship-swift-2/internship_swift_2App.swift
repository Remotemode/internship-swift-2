//
//  internship_swift_2App.swift
//  internship-swift-2
//
//  Created by Александр Савченко on 22.10.2021.
//

import SwiftUI
import Firebase

@main
struct internship_swift_2App: App {
    
    @StateObject var authService: AuthenticationService
    
    init() {
        _authService = StateObject(wrappedValue: AuthenticationService(user: User()))
        setupFirebase()
    }
    
    var body: some Scene {
        WindowGroup {
            InitialView()
                .environmentObject(authService)
        }
    }
}

extension internship_swift_2App {
  private func setupFirebase() {
     FirebaseApp.configure()
  }
}
