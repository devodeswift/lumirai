//
//  GradientBackgroundView.swift
//  lumirai
//
//  Created by dana nur fiqi on 17/12/25.
//

import Foundation
import SwiftUI

struct GradientBackgroundView: View {
    var baseColor: Color = Color(hex: "0A0F16")
    var topColor: Color = Color(hex: "1E546F")
    var bottomColor: Color = Color(hex: "1E546F")
    
    var body: some View {
        ZStack {
            baseColor
            RadialGradient(
                colors: [topColor.opacity(0.4), .clear],
                center: .top,
                startRadius: 0,
                endRadius: 500
            )
            RadialGradient(
                colors: [bottomColor.opacity(0.4), .clear],
                center: .bottom,
                startRadius: 0,
                endRadius: 500
            )
            
        }
    }
}

#Preview {
    GradientBackgroundView()
}
