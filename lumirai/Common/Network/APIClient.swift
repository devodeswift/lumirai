//
//  APIClient.swift
//  lumirai
//
//  Created by dana nur fiqi on 13/01/26.
//

import Foundation
import Alamofire

class APIClient {
    static let shared = APIClient()
    let session: Session
    
    private init() {
        let interceptor = AuthInterceptor()
        session = Session(interceptor: interceptor)
    }
    
    func performRequest(_ urlRequest: URLRequestConvertible) async throws -> Data {
        let response = try await session
            .request(urlRequest)
            .serializingData()
            .response
        
        return try response.validateStatusCode()
    }
}
