//
//  LoginView.swift
//  lumirai
//
//  Created by dana nur fiqi on 17/12/25.
//

import Foundation
import SwiftUI

struct LoginView: View {
    @State private var goToSubscription: Bool = false
    var body: some View {
        ZStack {
            GradientBackgroundView()
                .ignoresSafeArea()
            Color.clear
                .safeAreaInset(edge: .top) {
                    //headerView()
                    HeaderView()
                        .padding(.top, 16)
                }
            VStack(spacing:20){
                Spacer()
                (
                    Text("Login to your ")
                        .font(AppFonts.nunito(size: 18))
                        .foregroundColor(.white.opacity(0.8))
                    +
                    Text("LUMIRAi")
                        .font(AppFonts.playFairDisplayReg(size: 18))
                        .foregroundColor(.white) // premium accent
                    +
                    Text(" account")
                        .font(AppFonts.nunito(size: 18))
                        .foregroundColor(.white.opacity(0.8))
                )
                Button(action : {
                        // with apple
                    goToSubscription = true
                })
                {
                    HStack{
                        Image(systemName: "applelogo")
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))
                            .padding(8)
                        Text("Sign in With Apple")
                            .font(AppFonts.nunito(size: 18))
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(
                    Color.black.opacity(0.18)
                        .blur(radius: 8)
                        .cornerRadius(.infinity)
                )
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(
                            Color.white.opacity(0.25), // stroke color
                            lineWidth: 1
                        )
                )
                .padding(.top, 16)
                
                Button(action : {
                        // goo
                    goToSubscription = true
                })
                {
                    HStack{
                        Image(systemName: "g.circle.fill")
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))
                            .padding(8)
                        Text("Sign in With Google")
                            .font(AppFonts.nunito(size: 18))
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(
                    Color.black.opacity(0.18)
                        .blur(radius: 8)
                        .cornerRadius(.infinity)
                )
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(
                            Color.white.opacity(0.25), // stroke color
                            lineWidth: 1
                        )
                )
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, 16)
        }
        .navigationDestination(isPresented: $goToSubscription) {
            Subscription()
        }
        .navigationBarBackButtonHidden(true)
    }
    
    func headerView() -> some View {
        HStack{
            Button(action: {
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

#Preview {
    LoginView()
}
