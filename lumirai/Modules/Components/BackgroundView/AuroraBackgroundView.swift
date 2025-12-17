//
//  AuroraBackgroundView.swift
//  lumirai
//
//  Created by dana nur fiqi on 25/11/25.
//

import Foundation
import SwiftUI

struct AuroraBackgroundView: View {
    let baseColor: Color
    let topLeftColor: Color
    let topRightColor: Color
    let bottomColor: Color
    
    var body: some View {
        ZStack {
            baseColor
                .ignoresSafeArea()
            
            Circle()
                .fill(topLeftColor)
                .blur(radius: 180)
                .frame(width: 450, height: 450)
                .offset(x: -120, y: -180)
                .blendMode(.screen)
            
            Circle()
                .fill(topRightColor)
                .blur(radius: 220)
                .frame(width: 500, height: 500)
                .offset(x: 150, y: -120)
                .blendMode(.screen)
            
            Circle()
                .fill(bottomColor)
                .blur(radius: 200)
                .frame(width: 480, height: 480)
                .offset(x: 40, y: 200)
                .blendMode(.screen)
        }
    }
}

#Preview {
    AuroraBackgroundView(
        baseColor: Color("#0A0F16"), topLeftColor: Color("#00C4B4"), topRightColor: Color("#F5E9C5"), bottomColor: Color("#5648A8")
    )
}

