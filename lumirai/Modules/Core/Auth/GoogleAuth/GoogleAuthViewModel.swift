//
//  GoogleAuthViewModel.swift
//  lumirai
//
//  Created by dana nur fiqi on 12/01/26.
//

import Foundation
import Combine
import SwiftUI
import GoogleSignIn

class GoogleAuth {
    
//    init() {
//        restoreLogin()
//    }
    
    func signIn(completion: @escaping (AuthModel) -> Void) {
        guard let rootVC = UIApplication.shared
            .connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows
            .first?.rootViewController else { return }
        
        GIDSignIn.sharedInstance.signIn(
            withPresenting: rootVC
        ) { result, error in
            Task {
                if let error = error {
                    if (error as NSError).code == GIDSignInError.canceled.rawValue {
                        completion(.cancelled)
                    } else {
                        completion(.failed(error))
                    }
                    return
                }
                
                guard let _ = result?.user else {
                    completion(.failed(NSError(domain: "UserNil", code: -2)))
                    return
                }
                completion(.success)
            }
        }
    }
    
//    func signOut() {
//        GIDSignIn.sharedInstance.signOut()
//        isLoggedIn = false
//        email = nil
//    }
//
//    private func restoreLogin() {
//        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
//            GIDSignIn.sharedInstance.restorePreviousSignIn { user, _ in
//                guard let user else { return }
//                self.email = user.profile?.email
//                self.isLoggedIn = true
//            }
//        }
//    }
}
