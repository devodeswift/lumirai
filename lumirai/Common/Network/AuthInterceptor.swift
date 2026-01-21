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
        request.setValue("AIzaSyCOUC2c0YIpMHiDB-FjcVJEAwSfqFe55wI", forHTTPHeaderField: "x-goog-api-key")
//        request.setValue("AIzaSyAx4-7ED0ANbsbYwrNJH53SIrznQWUXFsM", forHTTPHeaderField: "x-goog-api-key")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        completion(.success(request))
    }
}
