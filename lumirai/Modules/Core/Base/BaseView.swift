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
                //.disabled(viewModel.isLoading)
        }
    }
    
    
}
