//
//  LoginViewModel.swift
//  lumirai
//
//  Created by dana nur fiqi on 28/12/25.
//

import Foundation
import Combine

class LoginViewModel: BaseViewModel {
    @Published var textDescLogin1: String = "Login to your "
    @Published var textDescLogin2: String = "LUMIRAi"
    @Published var textDescLogin3: String = " account"
    @Published var textDescLoginApple: String = "Sign in With Apple"
    @Published var textDescLoginGoogle: String = "Sign in With Google"
    @Published var isSuccsessLogin: Bool = false
    
    let googleAuth: GoogleAuth = GoogleAuth()
    
    override func start() {
        super.start()
    }
    
    func loginGoogle(){
        googleAuth.signIn { [weak self] result in
            switch result {
            case .success:
                self?.isSuccsessLogin = true
            case .cancelled:
                AppLogger.shared.log("User cancelled sign-in.")
                
            case .failed(let error):
                AppLogger.shared.log("Failed to sign-in with error: \(error)")
            }
            
        }
    }
}
