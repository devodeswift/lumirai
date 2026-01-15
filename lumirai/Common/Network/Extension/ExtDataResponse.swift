//
//  ExtDataResponse.swift
//  lumirai
//
//  Created by dana nur fiqi on 15/01/26.
//

import Foundation
import Alamofire

extension DataResponse<Data, AFError> {
    func validateStatusCode() throws -> Data {
        guard let response = self.response else {
            throw APIError.notResponse
        }
        
        let statusCode = response.statusCode
        guard statusCode == 200 else {
            throw APIError.httpError(statusCode: statusCode)
        }
        
        guard let data = self.data else {
            throw APIError.invalidData
        }
               
        return data
    }
}
