//
//  GeminiModel.swift
//  lumirai
//
//  Created by dana nur fiqi on 13/01/26.
//

import Foundation
import SwiftyJSON

struct GeminiModel: Decodable, Sendable {
    let candidates: [Candidate]
    let usageMetadata: UsageMetadata
    let modelVersion: String
    let responseId: String
}

struct Candidate: Decodable, Sendable {
    let content: Content
    let finishReason: String
    let index: Int
}

struct Content: Decodable, Sendable {
    let parts: [Part]
    let role: String
}

struct Part: Decodable, Sendable {
    let text: String
}

struct UsageMetadata: Decodable, Sendable {
    let promptTokenCount: Int
    let candidatesTokenCount: Int
    let totalTokenCount: Int
    let promptTokensDetails: [PromptTokenDetail]
    let thoughtsTokenCount: Int
}

struct PromptTokenDetail: Decodable, Sendable {
    let modality: String
    let tokenCount: Int
}

struct AIActionResponse: Decodable, Sendable {
    let echo: String
    let action: String
    let durationSec: Int
    let button: String

    enum CodingKeys: String, CodingKey {
        case echo
        case action
        case durationSec = "duration_sec"
        case button
    }
}

//struct ArticleResponse: Decodable, @unchecked Sendable {
//    let page: Int
//    let per_page: Int
//    let total: Int
//    let total_pages: Int
//    let data: [Article]
//}
//
//struct Article: Decodable, @unchecked Sendable {
//    let title: String?
//    let url: String?
//    let author: String?
//    let num_comments: Int?
//    let story_id: Int?
//    let story_title: String?
//    let story_url: String?
//    let parent_id: Int?
//    let created_at: Int?
//}

struct ArticleResponse {
    var page: Int = 0
    var per_page: Int = 0
    var total: Int = 0
    var total_pages: Int = 0
    
    init(){}
    init(_ json: JSON){
        page = json["page"].intValue
        per_page = json["per_page"].intValue
        total = json["total"].intValue
        total_pages = json["total_pages"].intValue
    }
}
