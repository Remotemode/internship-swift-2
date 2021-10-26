//
//  ViewModel.swift
//  internship-swift-2
//
//  Created by Александр Савченко on 24.10.2021.
//

import Foundation
import Firebase
import GoogleSignIn

class AuthViewModel: NSObject, ObservableObject {
    
    enum SignInState {
        case signedIn
        case signedOut
    }
    
    @Published var state: SignInState = .signedOut
    
    override init() {
        super.init()

        setupGoogleSignIn()
        checkAuth()
    }
    
    func signIn() {
        if GIDSignIn.sharedInstance().currentUser == nil {
          GIDSignIn.sharedInstance().presentingViewController = UIApplication.shared.windows.first?.rootViewController
          GIDSignIn.sharedInstance().signIn()
        }
    }
    
    func signOut() {
        GIDSignIn.sharedInstance().signOut()

        do {
          try Auth.auth().signOut()

          state = .signedOut
        } catch let signOutError as NSError {
          print(signOutError.localizedDescription)
        }
    }
    
    private func setupGoogleSignIn() {
        GIDSignIn.sharedInstance().delegate = self
    }
    
    private func checkAuth() {
        GIDSignIn.sharedInstance().restorePreviousSignIn()
    }
}

extension AuthViewModel: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error == nil {
          firebaseAuthentication(withUser: user)
        } else {
          print(error.debugDescription)
        }
    }
    
    private func firebaseAuthentication(withUser user: GIDGoogleUser) {
        if let authentication = user.authentication {
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)

          Auth.auth().signIn(with: credential) { (_, error) in
              if let error = error {
                  print(error.localizedDescription)
              } else {
              self.state = .signedIn
            }
          }
        }
    }
}
