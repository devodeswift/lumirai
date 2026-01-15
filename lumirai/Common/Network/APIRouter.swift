//
//  APIRouter.swift
//  lumirai
//
//  Created by dana nur fiqi on 13/01/26.
//

import Foundation
import Alamofire

enum APIRouter: URLRequestConvertible {
    
    case generateContent(text: String)
    case getDataArticle
    
    var method: HTTPMethod {
        switch self {
        case .generateContent:
            return .post
        case .getDataArticle:
            return .get
        }
    }
    
    var path: String {
        switch self{
        case .generateContent: return "/v1beta/models/gemini-2.5-flash:generateContent"
        case .getDataArticle: return "/api/articles"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = URL(string: Endpoint.baseURL)
        var request = URLRequest(url: url!.appendingPathComponent(path))
        request.method = method
        return request
    }
    
        
}
