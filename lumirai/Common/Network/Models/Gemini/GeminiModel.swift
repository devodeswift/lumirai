//
//  GeminiModel.swift
//  lumirai
//
//  Created by dana nur fiqi on 13/01/26.
//

import Foundation
import SwiftyJSON

struct GeminiResponseModel {
    var candidates: [CandidateModel] = []
    var usageMetadata: UsageMetadataModel?
    var modelVersion: String = ""
    var responseId: String = ""

    init() {}

    init(_ json: JSON) {
        candidates = json["candidates"].arrayValue.map { CandidateModel($0) }
        usageMetadata = UsageMetadataModel(json["usageMetadata"])
        modelVersion = json["modelVersion"].stringValue
        responseId = json["responseId"].stringValue
    }
}

struct CandidateModel {
    var content: ContentModel?
    var finishReason: String = ""
    var index: Int = 0

    init() {}

    init(_ json: JSON) {
        content = ContentModel(json["content"])
        finishReason = json["finishReason"].stringValue
        index = json["index"].intValue
    }
}


struct ContentModel {
    var parts: [PartModel] = []
    var role: String = ""

    init() {}

    init(_ json: JSON) {
        parts = json["parts"].arrayValue.map { PartModel($0) }
        role = json["role"].stringValue
    }
}

struct PartModel {
    var text: String = ""
    var action: GeminiActionModel?

    init() {}

    init(_ json: JSON) {
        text = json["text"].stringValue
        action = PartModel.parseAction(from: text)
    }

    private static func parseAction(from text: String) -> GeminiActionModel? {
        guard let data = text.data(using: .utf8),
              let json = try? JSON(data: data) else {
            return nil
        }
        return GeminiActionModel(json)
    }
}

struct UsageMetadataModel {
    var promptTokenCount: Int = 0
    var candidatesTokenCount: Int = 0
    var totalTokenCount: Int = 0
    var thoughtsTokenCount: Int = 0
    var promptTokensDetails: [PromptTokenDetailModel] = []

    init() {}

    init(_ json: JSON) {
        promptTokenCount = json["promptTokenCount"].intValue
        candidatesTokenCount = json["candidatesTokenCount"].intValue
        totalTokenCount = json["totalTokenCount"].intValue
        thoughtsTokenCount = json["thoughtsTokenCount"].intValue
        promptTokensDetails = json["promptTokensDetails"].arrayValue.map {
            PromptTokenDetailModel($0)
        }
    }
}

struct PromptTokenDetailModel {
    var modality: String = ""
    var tokenCount: Int = 0

    init() {}

    init(_ json: JSON) {
        modality = json["modality"].stringValue
        tokenCount = json["tokenCount"].intValue
    }
}

struct GeminiActionModel: Hashable {
    var emotion: String = ""
    var echo: String = ""
    var action: String = ""
    var durationSec: Int = 0
    var button: String = ""

    init() {}

    init(_ json: JSON) {
        emotion = json["emotion"].stringValue
        echo = json["echo"].stringValue
        action = json["action"].stringValue
        durationSec = json["duration_sec"].intValue
        button = json["button"].stringValue
    }
}

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
