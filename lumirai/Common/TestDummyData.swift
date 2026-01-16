//
//  TestDummy.swift
//  lumirai
//
//  Created by dana nur fiqi on 16/01/26.
//

import Foundation

class TestDummyData {
    static let shared = TestDummyData()
    
    func getDummyJSON (fileName: String) -> Any{
        guard let jsonFileURL = Bundle.main.url(forResource: fileName, withExtension: "json") else { return [] }
            
            do {
                let jsonData = try Data(contentsOf: jsonFileURL)
                
                guard let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else { return [] }
                
            return jsonObject
                
            } catch {
                AppLogger.shared.log("Error parsing json: \(error)")
                return []
            }
    }
}
