//
//  CalmViewModel.swift
//  lumirai
//
//  Created by dana nur fiqi on 29/12/25.
//

import Foundation

class CalmViewModel: BaseViewModel {
    var action: GeminiActionModel
    
//    override func start() {
//        <#code#>
//    }
    
    init(action: GeminiActionModel){
        self.action = action
        super.init()
    }
}
