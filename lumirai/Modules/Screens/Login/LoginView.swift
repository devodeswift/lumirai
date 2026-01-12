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
    @StateObject private var viewModel = LoginViewModel()
    @EnvironmentObject private var router: Router
    
    var body: some View {
        BaseView(viewModel: viewModel) { vm in
            ZStack {
                GradientBackgroundView()
                    .ignoresSafeArea()
                Color.clear
                    .safeAreaInset(edge: .top) {
                        HeaderView{
                            router.pop()
                        }
                        .padding(.top, 16)
                    }
                VStack(spacing:20){
                    Spacer()
                    (
                        Text(vm.textDescLogin1)
                            .font(AppFonts.nunito(size: 18))
                            .foregroundColor(.white.opacity(0.8))
                        +
                        Text(vm.textDescLogin2)
                            .font(AppFonts.playFairDisplayReg(size: 18))
                            .foregroundColor(.white) // premium accent
                        +
                        Text(vm.textDescLogin3)
                            .font(AppFonts.nunito(size: 18))
                            .foregroundColor(.white.opacity(0.8))
                    )
                    Button(action : {
                        // with apple
                        vm.loginApple()
                    })
                    {
                        HStack{
                            Image(systemName: "applelogo")
                                .font(.system(size: 24, weight: .medium))
                                .foregroundColor(.white.opacity(0.8))
                                .padding(8)
                            Text(vm.textDescLoginApple)
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
                        vm.loginGoogle()
                    })
                    {
                        HStack{
                            Image(systemName: "g.circle.fill")
                                .font(.system(size: 24, weight: .medium))
                                .foregroundColor(.white.opacity(0.8))
                                .padding(8)
                            Text(vm.textDescLoginGoogle)
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
            .navigationBarBackButtonHidden(true)
        }
    }
    
    func headerView() -> some View {
        HStack{
            Button(action: {
                router.popToRoot()
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
