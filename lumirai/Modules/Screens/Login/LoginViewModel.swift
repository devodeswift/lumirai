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
    
    override func start() {
        
    }
}
