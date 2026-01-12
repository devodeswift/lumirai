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

    var body: some View {
        BaseView( viewModel: viewModel ) { vm in
            
            
            ZStack(alignment: .top){
                GradientBackgroundView()
                    .ignoresSafeArea()
                VStack {
                    Image("img_bg_aurora")
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .frame(height: 280)
                        .clipShape(BottomTriangleShape())
                        .padding(.top,0)
                    Spacer()
                    
                }
                .ignoresSafeArea()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                VStack{
                    HeaderView{
                        
                    }
                        .padding(.top, 16)
                    Text(vm.textDescSubscription)
                        .font(AppFonts.nunito(size: 24))
                        .foregroundColor(.white)
                        .padding(.top, 200)
                    
                    Button(action : {
                        //Light
                    })
                    {
                        HStack{
                            Text(vm.textLightPlan)
                                .font(AppFonts.nunito(size: 20))
                                .foregroundColor(.white.opacity(0.8))
                            Spacer()
                            Text(vm.textPriceLightPlan)
                                .font(AppFonts.nunito(size: 20))
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding(.horizontal)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(
                        Color.black.opacity(0.18)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.white.opacity(0.25), lineWidth: 1)
                    )
                    .padding(.top, 40)
                    .padding(.horizontal)
                    
                    Button(action : {
                        //One
                    })
                    {
                        HStack{
                            Text(vm.textOnePlan)
                                .font(AppFonts.nunito(size: 20))
                                .foregroundColor(.white.opacity(0.8))
                            Spacer()
                            Text(vm.textPriceOnePlan)
                                .font(AppFonts.nunito(size: 20))
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding(.horizontal)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(
                        Color.black.opacity(0.18)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.white.opacity(0.25), lineWidth: 1)
                    )
                    .padding(.top, 10)
                    .padding(.horizontal)
                    
                    Button(action : {
                        //Founder
                    })
                    {
                        HStack{
                            Text(vm.textFounderPlan)
                                .font(AppFonts.nunito(size: 20))
                                .foregroundColor(.white.opacity(0.8))
                            Spacer()
                            Text(vm.textPriceFounderPlan)
                                .font(AppFonts.nunito(size: 20))
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding(.horizontal)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(
                        Color.black.opacity(0.18)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.white.opacity(0.25), lineWidth: 1)
                    )
                    .padding(.top, 10)
                    .padding(.horizontal)
                    Spacer()
                    
                    Button(action : {
                        goToExpression = true
                    })
                    {
                        HStack{
                            Text(vm.textBtnContinue)
                                .font(AppFonts.nunito(size: 20))
                                .foregroundColor(.white.opacity(0.8))
                            
                        }
                        .padding(.horizontal)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(hex: "2A6F8F"),
                                        Color(hex: "1E546F"),
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.white.opacity(0.25), lineWidth: 1)
                    )
                    .padding(.top, 10)
                    .padding(.horizontal)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.horizontal, 32)
            }
            .navigationDestination(isPresented: $goToExpression) {
                ExpressionView()
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
