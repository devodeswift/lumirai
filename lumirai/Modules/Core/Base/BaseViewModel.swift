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
    @Published var isLoading: Bool = false
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    var cancellables = Set<AnyCancellable>()
    
    override init(){
        super.init()
        start()
    }
    
    func start() {
        
    }
    
    func handleError() {
        errorMessage = "Something went wrong."
        showError = true
    }
    
    func setLoading(_ value: Bool){
        isLoading = value
    }
}
