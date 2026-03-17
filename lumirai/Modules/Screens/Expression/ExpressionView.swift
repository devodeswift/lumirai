//
//  ExpressionView.swift
//  lumirai
//
//  Created by dana nur fiqi on 26/11/25.
//
import SwiftUI

struct ExpressionView: View {
    @StateObject private var viewmodel = ExpressionViewModel()
    @EnvironmentObject private var router: Router
    @FocusState private var isFocused : Bool
    @State private var isAnimating = false
    @State private var text: String = ""
    @State private var isListening : Bool = false
    @State private var animate: Bool = false
    @State private var goToCalm = false
    @State private var textOpacity: Double = 0.0
    @State private var getResponse: Bool = false
    @State private var animatedScale: CGFloat = 1.0
    @State private var animatedCoreOpacity: Double = 0.85
    
    var body: some View {
        BaseView(viewModel: viewmodel) { vm in
            ZStack {
                GeometryReader { geo in
                    ZStack {
                        HaloLightLayerView(opacity: 0.35 * animatedCoreOpacity, blur: 75)
                        HaloLightLayerView(opacity: 0.6  * animatedCoreOpacity, blur: 60)
                        HaloLightLayerView(opacity: 1.0  * animatedCoreOpacity, blur: 50)
                    }
                    .frame(
                        width: geo.size.width * 0.35,
                        height: geo.size.width * 0.35
                    )
                    .scaleEffect(isListening
                                 ? vm.haloPulse
                                 : animatedScale)
                    
                    .position(
                        x: geo.size.width / 2,
                        y: geo.size.height / 2
                    )
                    
                    .onChange(of: vm.scale) { newValue in
                        withAnimation(.easeInOut(duration: vm.duration)) {
                            animatedScale = newValue
                        }
                    }
                    
                    
                    .onChange(of: vm.coreOpacity) { newValue in
                        withAnimation(.easeInOut(duration: vm.duration)) {
                            animatedCoreOpacity = newValue
                        }
                    }
                    .onAppear {
                        vm.startBreathing()
                    }
                    
                }
                ZStack{
                    ParticleView(
                        animate: $animate,
                        countParticles: 35
                    )
                }
                VStack(alignment: .center) {
                    Text(vm.textTitle)
                        .font(AppFonts.playFairDisplayReg(size: 24))
                        .foregroundColor(.white)
                        .padding(.top, 10)
                    Spacer()
                    
                    
                    textScroll(vm: vm)
                    if !isListening {
                        GlassButtonView(title: "Write") {
                            isFocused = true
                        }
                    }
                    
                    GlassButtonView(title: !isListening ? "Speak" : "Finish") {
                        if isListening {
                            vm.getResponse(text: text)
                        }
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.82)) {
                            isListening.toggle()
                        }
                    }
                }
            }
            .onAppear {
                vm.textResponse = ""
                vm.checkEmotionFromWatch()
                isAnimating = true
                if !isListening {
                    animate = true
                }
                
            }
            .navigationBarBackButtonHidden(true)
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                isFocused = false
            }
            .onChange(of: isListening) { active in
                AppLogger.shared.log("test => \(active)")
                if active {
                    vm.pulseManager.start()
                    vm.speech.startListening()
                    animate = false
                } else {
                    animate = true
                    vm.pulseManager.stop()
                    vm.speech.stopListening()
                }
            }
            .onChange(of: vm.geminiAction) { action in
                guard let action else { return }
                router.push(.calm(data: action))
                vm.geminiAction = nil
                text = ""
            }
            .onReceive(vm.pulseManager.$amplitude) { value in
                
                let clamped = min(max(value, 0), 2) // pastikan tetap aman
                let mapped = 1.0 + (clamped * 0.5)  // range 1.0 → 1.8
                
                withAnimation(.spring(response: 0.25, dampingFraction: 0.55)) {
                    vm.haloPulse = mapped
                    
                }
                
            }
            .onReceive(vm.speech.$text) { newValue in
                AppLogger.shared.log(newValue)
                if isListening {
                    text = newValue
                }
            }
            .background(Color(hex:"#0A0F16"))
        }
    }
    
    
    func textScroll(vm: ExpressionViewModel) -> some View {
        ScrollViewReader { proxy in
            ScrollView {
                ZStack(alignment: .topLeading) {
                    TextEditor(text: $text)
                        .font(AppFonts.nunito(size: 20))
                        .foregroundColor(.white)
                        .scrollContentBackground(.hidden)
                        .background(Color.clear)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .focused($isFocused)
                        .padding(18)
                        .onChange(of: isFocused) { focused in
                            if !focused {
                                vm.getResponse(text: text)
                            }
                        }
                    
                    if text.isEmpty {
                        Text(vm.textPlaceholder)
                            .font(AppFonts.nunito(size: 20))
                            .foregroundColor(.white.opacity(0.4))
                            .padding(18)
                            .padding(.top, 6)
                            .padding(.leading, 3)
                            .allowsHitTesting(false)
                    }
                }
                .padding(10)
            }
            .onChange(of: text) { _ in
                withAnimation(.easeOut) {
                    proxy.scrollTo("BOTTOM", anchor: .bottom)
                }
            }
            .mask(
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: .clear, location: 0),
                        .init(color: .black, location: 0.12),
                        .init(color: .black, location: 0.88),
                        .init(color: .clear, location: 1.0)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        }
        .frame(maxWidth: .infinity ,maxHeight: .infinity)
    }
    
}




#Preview {
    ExpressionView()
}

