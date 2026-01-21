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
    func generateContent(dataParam:RequestGeminiModel) async throws -> GeminiResponseModel {
        let data = try await APIClient.shared.performRequest(APIRouter.generateContent(dataParam: dataParam))
        let json = try JSON(data: data)
        return GeminiResponseModel(json)
    }
    
    func getData() async throws -> ArticleResponse {
        let data = try await APIClient.shared.performRequest(APIRouter.getDataArticle)
        let json = try JSON(data: data)
        return ArticleResponse(json)
    }
    
}
