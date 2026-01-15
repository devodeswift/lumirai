//
//  APIService.swift
//  lumirai
//
//  Created by dana nur fiqi on 13/01/26.
//

import Foundation
import Alamofire
import SwiftyJSON

class APIService {
    static let shared = APIService()
//    func generateContent(text:String) async throws -> GeminiModel {
//        try await APIClient.shared.session
//            .request(APIRouter.generateContent(text: text))
//            .validate()
//            .serializingDecodable(GeminiModel.self)
//            .value
//    }
    
    func getData() async throws -> ArticleResponse {
        let data = try await APIClient.shared.performRequest(APIRouter.getDataArticle)
        let json = try JSON(data: data)
        return ArticleResponse(json)
    }
    
}
