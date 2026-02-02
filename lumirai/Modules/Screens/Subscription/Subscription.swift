//
//  Subscription.swift
//  lumirai
//
//  Created by dana nur fiqi on 17/12/25.
//

import Foundation
import SwiftUI

struct Subscription: View {
    @State private var goToExpression = false
    @StateObject private var viewModel = SubscriptionViewModel()
    @EnvironmentObject private var router: Router

    var body: some View {
        BaseView( viewModel: viewModel ) { vm in
            ZStack{
                Color(.black).ignoresSafeArea()
                ScrollView(.vertical, showsIndicators: false){
                    VStack(alignment: .center) {
                        Text(vm.textTitle)
                            .font(AppFonts.playFairDisplayReg(size: 24))
                            .foregroundColor(.white)
                        HaloDriftView {
                            ZStack {
                                HaloLightLayer(opacity: 0.35 * vm.coreOpacity, blur: 60 + 15, colorCore: Color(hex: "#C8D8E8"), colorOuter: Color(hex: "#A0B8D0"))
                                HaloLightLayer(opacity: 0.6  * vm.coreOpacity, blur: 60, colorCore: Color(hex: "#C8D8E8"), colorOuter: Color(hex: "#A0B8D0"))
                                HaloLightLayer(opacity: 1.0  * vm.coreOpacity, blur: 60 - 10, colorCore: Color(hex: "#C8D8E8"), colorOuter: Color(hex: "#A0B8D0"))
                            }
                            .frame(
                                width: 120,
                                height: 120
                            )
                            .scaleEffect(vm.scale)
                        }
                        .onAppear {
                            vm.startBreathing()
                        }
                        .padding(.top, 50)
                        
                        Text(vm.textContinue)
                            .font(AppFonts.playFairDisplayReg(size: 28))
                            .foregroundColor(.white)
                            .padding(.top, 30)
                        
                        VStack{
                            Text(vm.textAnnualPrice)
                                .font(AppFonts.playFairDisplayReg(size: 24))
                                .foregroundColor(.white)
                            Text(vm.text7Days)
                                .font(AppFonts.playFairDisplayReg(size: 14))
                                .foregroundColor(.white)
                            
                            Button(action: {
                                router.push(.expression)
                            }) {
                                Text(vm.textSubscribeYearly)
                                    .font(AppFonts.playFairDisplayReg(size: 16))
                                    .foregroundColor(.black)
                                    .padding(.horizontal, 20)
                            }
                            .frame(height: 50)
                            .frame(maxWidth: .infinity)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color(hex: "#2A2A2A"), lineWidth: 1)
                            )
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(.white)
                            )
                            
                        }
                        .padding(.vertical, 20)
                        .padding(.horizontal, 20)
                        .frame(maxWidth: 400)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color(hex: "#2A2A2A"), lineWidth: 1)
                        )
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(hex: "#1A1A1A"))
                        )
                        
                        Spacer()
                            .frame(height: 16)
                        
                        VStack{
                            Text(vm.textMonthlyPrice)
                                .font(AppFonts.playFairDisplayReg(size: 24))
                                .foregroundColor(.white)
                            
                            Text(vm.text7Days)
                                .font(AppFonts.playFairDisplayReg(size: 14))
                                .foregroundColor(.white)
                            
                            
                            Button(action: {
                                router.push(.expression)
                            }) {
                                Text(vm.textTrial)
                                    .font(AppFonts.playFairDisplayReg(size: 16))
                                    .foregroundColor(.black)
                                    .padding(.horizontal, 20)
                            }
                            .frame(height: 50)
                            .frame(maxWidth: .infinity)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color(hex: "#2A2A2A"), lineWidth: 1)
                            )
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(.white)
                            )
                            
                        }
                        .padding(.vertical, 24)
                        .padding(.horizontal, 20)
                        .frame(maxWidth: 400)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color(hex: "#2A2A2A"), lineWidth: 1)
                        )
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(hex: "#1A1A1A"))
                        )
                        
                        Text(vm.textDescription)
                            .font(AppFonts.playFairDisplayReg(size: 15))
                            .foregroundColor(.white.opacity(0.7))
                            .padding(.horizontal, 20)
                            .multilineTextAlignment(.center)
                            .padding(.top, 32)
                        Spacer()
                        
                        Text(vm.textCancel)
                            .font(AppFonts.playFairDisplayReg(size: 13))
                            .foregroundColor(.white.opacity(0.4))
                            .padding(.horizontal, 20)
                            .padding(.bottom, 0)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal, 24)
                }
            }
            .navigationBarBackButtonHidden(true)
        }
        
    }
    
    
}

struct BottomTriangleShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: rect.width / 2, y: rect.height - 10)) // puncak segitiga
        path.addLine(to: CGPoint(x: 0, y: rect.height))

        path.closeSubpath()
        return path
    }
}


#Preview {
    Subscription()
}
