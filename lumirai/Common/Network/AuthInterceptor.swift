//
//  AuthInterceptor.swift
//  lumirai
//
//  Created by dana nur fiqi on 13/01/26.
//

import Foundation
import Alamofire

final class AuthInterceptor: RequestInterceptor {
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void ) {
        var request = urlRequest
        //set header
//        request.setValue("API_KEY_GEMINI", forHTTPHeaderField: "x-goog-api-key")
        completion(.success(request))
    }
}
