//
//  CalmView.swift
//  lumirai
//
//  Created by dana nur fiqi on 11/12/25.
//

import Foundation
import SwiftUI
import SceneKit
import Combine

struct CalmView: View{
    @EnvironmentObject private var router: Router
    @State private var animate = false
    @State private var breatheState = false
    @State private var isStart: Bool = false
    @StateObject private var calmviewModel: CalmViewModel
    @State var isBreatheAnimation: Bool = false
    @State var showPickerContact: Bool = false
    @State var startJournal: Bool = false
    @State private var text: String = ""
    @FocusState private var isFocused : Bool
    init(resultAction: GeminiActionModel) {
        _calmviewModel = StateObject(wrappedValue: CalmViewModel(resultAction: resultAction))
    }
    
    
    func TimerLine(
        progress: Double,
        color: Color
    ) -> some View {

        GeometryReader { geo in
            Capsule()
                .fill(color)
                .frame(
                    width: geo.size.width * progress,
                    height: 2
                )
                .opacity(0.45)
                .animation(.easeInOut, value: progress)
        }
    }
    

    func bigHaloBreathing() -> some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color(hex: "DCEBFF").opacity(0.08),
                            Color(hex: "DCEBFF").opacity(0.04),
                            .clear
                        ]),
                        center: .init(x: 0.46, y: 0.44),
                        startRadius: 50,
                        endRadius: 170
                    )
                )
                .blur(radius: 24)
                .blendMode(.screen)
            
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color(hex: "E6F0FF").opacity(0.22),
                            Color(hex: "E6F0FF").opacity(0.10),
                            .clear
                        ]),
                        center: .init(x: 0.52, y: 0.48),
                        startRadius: 0,
                        endRadius: 95
                    )
                )
                .blur(radius: 12)
                .blendMode(.screen)
        }
    }
    
    func makeCall(to phoneNumber: String) {
        let formatted = phoneNumber.replacingOccurrences(of: " ", with: "")
        if let url = URL(string: "tel://\(formatted)"),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    var body: some View {
        BaseView(viewModel: calmviewModel) { vm in
            ZStack {
                GradientBackgroundView()
                    .ignoresSafeArea()
                    ZStack{
                        bigHaloBreathing()
                    }
                    .scaleEffect(animate ? 1.8 : 1.0)
                    .opacity(isBreatheAnimation ? 0 : (animate ? 1.0 : 0.97))
                    .animation(
                        .easeInOut(duration: 6.5)
                            .repeatForever(autoreverses: true),
                        value: animate
                    )
                    ZStack{
                        HaloView(startAnimation: isBreatheAnimation)
                            .animation(
                            .easeInOut(duration: 6.5)
                            .repeatForever(autoreverses: true),
                            value: isBreatheAnimation
                        )
                    }
                    .opacity(isBreatheAnimation ? 1 : 0)
                    .animation(.easeInOut(duration: 1.0), value: isBreatheAnimation)
                
                VStack{
                    Text("LUMIRAi")
                        .font(AppFonts.playFairDisplayReg(size: 24))
                        .foregroundColor(.white)
                        .padding(.top, 10)
                    if startJournal{
                        TextEditor(text: $text)
                            .font(AppFonts.nunito(size: 20))
                            .foregroundColor(.white)
                            .scrollContentBackground(.hidden)
                            .padding(30) // padding di dalam text editor
                            .background(Color.clear) // transparan
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.white, lineWidth: 1)
                                    .padding(20)// border putih
                            )
                            .frame(minHeight: 200)
                            .focused($isFocused)
                    }else {
                        Spacer()
                    }
                    
                    Text(vm.resultAction.echo)
                        .font(AppFonts.nunito(size: 20))
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                        
                    if isStart {
                        TimerLine(
                            progress: vm.progress,
                            color: Color(hex: "C9D6E8")
                        )
                        .frame(height: 2)
                    } else{
                        GlassButtonView(title: "\(vm.resultAction.button)"){
                            isStart.toggle()
                            vm.startTimer()
                            switch vm.action {
                            case .breathe:
                                isBreatheAnimation = true
                            case .walk:
                                AppLogger.shared.log("walk")
                            case .journal:
                                startJournal = true
                                isFocused = true
                            case .call:
                                showPickerContact = true
                            case .unknown:
                                AppLogger.shared.log("unknown")
                            }
                        }.padding(.horizontal, 10)
                    }
                }
                .animation(nil, value: breatheState)
            }
            .navigationBarBackButtonHidden(true)
            .onAppear {
                animate = true
            }
            .sheet(isPresented: $showPickerContact) {
                ContactPickerView { number in
                    makeCall(to: number)
                }
            }
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                isFocused = false
            }
        }
    }
    
}

#Preview {
    CalmView(resultAction: GeminiActionModel(
        emotion: "anxiety",
        echo: "I realize things feel overwhelming right now, but we can take this one step at a time to find your center again.",
        action: "journal",
        durationSec: 300,
        button: "Start Breathing"
    ))
}
