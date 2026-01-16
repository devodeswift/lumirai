//
//  BaseViewModel.swift
//  lumirai
//
//  Created by dana nur fiqi on 28/12/25.
//

import Foundation
import SwiftUI
import Combine

class BaseViewModel: NSObject, ObservableObject {
    
    var cancellables = Set<AnyCancellable>()
    
    override init(){
        super.init()
        AppLogger.shared.log("super init")
        start()
    }
    
    func start() {
        
    }
}
