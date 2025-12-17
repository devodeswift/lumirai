//
//  SplashViewModel.swift
//  lumirai
//
//  Created by dana nur fiqi on 20/11/25.
//

import Foundation
import Combine

class SplashViewModel: ObservableObject {
    @Published var shouldNavigate = false
    private var cancellable: AnyCancellable?
    
    init() {
        startTimer()
    }
    
    private func startTimer(){
        cancellable = Just(())
            .delay(for: .seconds(3), scheduler: RunLoop.main)
            .sink{ [weak self] _ in
                self?.shouldNavigate = true
        }
    }
}
