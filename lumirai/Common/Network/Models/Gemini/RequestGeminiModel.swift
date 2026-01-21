//
//  APIReqGeminiModel.swift
//  lumirai
//
//  Created by dana nur fiqi on 20/01/26.
//

import Foundation

struct RequestGeminiModel: Encodable {
    let system_instruction: SystemInstruction
    let contents: [Content]
}

struct SystemInstruction: Encodable {
    let parts: [TextPart]
}

struct Content: Encodable {
    let parts: [TextPart]
}

struct TextPart: Encodable {
    let text: String
}
