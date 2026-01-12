//
//  HeaderView.swift
//  lumirai
//
//  Created by dana nur fiqi on 17/12/25.
//

import Foundation
import SwiftUI

struct HeaderView: View {
    var action: () -> Void
    var body: some View {
        HStack{
            Button(action: {
                action()
            }) {
                Image(systemName: "xmark")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
                    .padding(8)
            }
            .background(
                ZStack {
                    Color.black.opacity(0.18)
                        .blur(radius: 8)
                        .cornerRadius(.infinity)
                    
                }
            )
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(
                        Color.white.opacity(0.25), // stroke color
                        lineWidth: 1
                    )
            )
            Spacer()
        }
        .padding(.horizontal, 16)
        
    }
}
