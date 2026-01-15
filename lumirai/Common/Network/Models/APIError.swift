//
//  APIError.swift
//  lumirai
//
//  Created by dana nur fiqi on 15/01/26.
//

import Foundation

enum APIError: Error, LocalizedError {
    case httpError(statusCode: Int)
    case notResponse
    case invalidData
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .httpError(let code):
            return "HTTP Error with status code: \(code)"
        case .notResponse:
            return "No response from server"
        case .invalidData:
            return "Invalid data from server"
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}
