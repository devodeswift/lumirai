//
//  AppleAuth.swift
//  lumirai
//
//  Created by dana nur fiqi on 12/01/26.
//

import Foundation
import AuthenticationServices
import SwiftUI
import UIKit


final class AppleAuth: NSObject {

    private var completion: ((AuthModel) -> Void)?

    func signIn(completion: @escaping (AuthModel) -> Void) {
        self.completion = completion

        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]

        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
}

extension AppleAuth: ASAuthorizationControllerDelegate {

    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        guard authorization.credential is ASAuthorizationAppleIDCredential else {
            completion?(.failed(NSError(domain: "InvalidCredential", code: -1)))
            return
        }

        completion?(.success)
    }

    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: Error
    ) {
        let nsError = error as NSError
        if nsError.code == ASAuthorizationError.canceled.rawValue {
            completion?(.cancelled)
        } else {
            completion?(.failed(error))
        }
    }
}

extension AppleAuth: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
            UIApplication.shared
                .connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .first?
                .windows
                .first { $0.isKeyWindow } ?? UIWindow()
        }

        
}
