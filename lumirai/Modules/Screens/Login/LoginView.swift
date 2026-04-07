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
                VStack{
                    Text("LUMIRAi")
                        .font(AppFonts.playFairDisplayReg(size: 24))
                        .foregroundColor(.white)
                        .padding(.top, 10)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                    Spacer()
                    GlassButtonView(
                        title: "Login With Apple",
                        textColor: .black,
                        backgroundStyle: .solid(.white)
                    ){
                        vm.loginApple()
                    }
                    Text("Your 7-day trial begins after sign-in")
                        .font(AppFonts.nunito(size: 16))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                    Text("Restore Purchase")
                        .font(AppFonts.nunito(size: 14))
                        .foregroundColor(.white)
                        .padding(.top, 10)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                    
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
            .frame(maxWidth:.infinity, maxHeight: .infinity)
            .background(Color(hex:"#0A0F16"))
            .navigationBarBackButtonHidden()
            .onChange(of: vm.isSuccsessLogin){ isSuccess in
                if isSuccess {
                    router.push(.expression)
                }
                
            }
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
