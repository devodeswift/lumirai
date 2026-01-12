//
//  AuthViewModel.swift
//  lumirai
//
//  Created by dana nur fiqi on 08/01/26.
//

import Foundation
import GoogleSignIn
import UIKit
import Combine

@MainActor
class AuthViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var email: String?
    
    init() {
        restoreLogin()
    }
    
    func signIn() {
        guard let rootVC = UIApplication.shared
                    .connectedScenes
                    .compactMap({ $0 as? UIWindowScene })
                    .first?.windows
                    .first?.rootViewController else { return }

                GIDSignIn.sharedInstance.signIn(
                    withPresenting: rootVC
                ) { result, error in
                    guard let user = result?.user, error == nil else { return }

                    self.email = user.profile?.email
                    self.isLoggedIn = true
                }
    }
    
    func signOut() {
            GIDSignIn.sharedInstance.signOut()
            isLoggedIn = false
            email = nil
        }

        private func restoreLogin() {
            if GIDSignIn.sharedInstance.hasPreviousSignIn() {
                GIDSignIn.sharedInstance.restorePreviousSignIn { user, _ in
                    guard let user else { return }
                    self.email = user.profile?.email
                    self.isLoggedIn = true
                }
            }
        }
}
