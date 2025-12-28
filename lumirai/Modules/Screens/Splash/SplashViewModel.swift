//
//  SplashViewModel.swift
//  lumirai
//
//  Created by dana nur fiqi on 20/11/25.
//

import Foundation
import Combine

class SplashViewModel: BaseViewModel {
    @Published var shouldNavigate = false
    @Published var textLogo: String = "LUMIRAi"
    @Published var textVersion: String = "Version \(AppInfo.shared.getAppVersion)"
    
    
    override func start() {
        super.start()
        startTimer()
    }
    
    private func startTimer(){
        Just(())
            .delay(for: .seconds(3), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.shouldNavigate = true
            }
            .store(in: &cancellables)
    }
}
