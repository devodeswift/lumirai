//
//  SplashViewModel.swift
//  lumirai
//
//  Created by dana nur fiqi on 20/11/25.
//

import Foundation
import Combine
import SwiftUI

class SplashViewModel: BaseViewModel {
    @Published var textLogo: String = "LUMIRAi"
    @Published var textVersion: String = "Version \(AppInfo.shared.getAppVersion)"
    @Published var isFinished: Bool = false
    
    
    override func start() {
        super.start()
        startTimer()
    }
    
    func startTimer(){
        Just(())
            .delay(for: .seconds(3), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.isFinished = true
            }
            .store(in: &cancellables)
    }
}
