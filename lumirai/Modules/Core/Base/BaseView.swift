//
//  BaseView.swift
//  lumirai
//
//  Created by dana nur fiqi on 28/12/25.
//

import Foundation
import SwiftUI
import Combine

struct BaseView<Content: View, VM: BaseViewModel>: View {
    
    @StateObject private var viewModel: VM
    let content: (VM) -> Content
    
    init(
        viewModel: VM,
        @ViewBuilder content: @escaping (VM) -> Content
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.content = content
    }
    
    var body: some View {
        ZStack {
            content(viewModel)
                .disabled(viewModel.isLoading)
            #if os(iOS)
            if viewModel.isLoading {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                
                ProgressView("Loading...")
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
            }
            #endif
        }
        .alert("Error",
            isPresented: Binding(
                get: { viewModel.showError },
                set: { viewModel.showError = $0 }
            )
        ) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage)
        }
                
    }
    
    
    
}
