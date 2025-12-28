//
//  BaseViewModel.swift
//  lumirai
//
//  Created by dana nur fiqi on 28/12/25.
//

import Foundation
import SwiftUI
import Combine

class BaseViewModel: ObservableObject {
    
    var cancellables = Set<AnyCancellable>()
    
    init(){
        start()
    }
    
    func start() {
        
    }
}
