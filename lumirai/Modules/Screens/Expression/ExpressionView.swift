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
    @State private var float = false
    @State private var goToCalm = false
    @StateObject private var breath = HaloBreathingController()
    @State private var scale: CGFloat = 1.0
    @State private var coreOpacity: Double = 0.85
    @State private var drift: CGSize = .zero
    @State private var driftParticle: CGSize = .zero
    @State private var shimmer: CGFloat = 0
//    @State private var animate = false
    
    var body: some View {
        BaseView(viewModel: viewmodel) { vm in
            ZStack {
                GeometryReader { geo in
                    HaloDriftView {
                        ZStack {
                            
                            ParticleShimmerViewNew(
                                animate: $animate,
                                scale: $scale,
                                countParticles: 100
                            )
                            .offset(driftParticle)
                            HaloLightLayer(opacity: 0.35 * coreOpacity, blur: 60 + 15)
                            HaloLightLayer(opacity: 0.6  * coreOpacity, blur: 60)
                            HaloLightLayer(opacity: 1.0  * coreOpacity, blur: 60 - 10)
                        }
                        .frame(
                            width: geo.size.width * 0.35,
                            height: geo.size.width * 0.35
                        )
                        .scaleEffect(scale + shimmer)
                        .offset(drift)
                    }
                    .position(
                        x: geo.size.width / 2,
                        y: geo.size.height / 2
                    )
                    
                    .onAppear {
                        startBreathing()
                        startDrift()
                        startShimmer()
                        startDriftParticle()
                    }
                    
                }
//                ZStack{
//                    bigHaloBreathing(vm : viewmodel)
//                }
//                .scaleEffect(
//                    isListening
//                            ? vm.haloPulse
//                            : (animate ? 1.8 : 1.0)
//                )
//                .opacity(animate ? 1.0 : 0.97)
//                .animation(
//                    .easeInOut(duration: isListening ? 0.7 : 6.5),
//                    value: isListening
//                )
//                .animation(
//                    .easeInOut(duration: 6.5)
//                        .repeatForever(autoreverses: true),
//                    value: animate
//                )
                
                VStack(alignment: .center) {
                    Text(vm.textTitle)
                        .font(AppFonts.playFairDisplayReg(size: 24))
                        .foregroundColor(.white)
                        .padding(.top, 10)
                    Spacer()
                    textScroll(vm: vm)
                    bottomView(vm: vm)
                        .frame(maxWidth: .infinity, maxHeight: 40)
                        .padding(.horizontal, 20)
                }
            }
            .onAppear {
                vm.checkEmotionFromWatch()
                isAnimating = true
                float = true
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
    
    
    func bottomView(vm: ExpressionViewModel) -> some View {
        HStack {
            if !isListening {
                Button(action: {
                    isFocused = true
                }) {
                Image(systemName: "text.bubble")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
                    .frame(width: 50, height: 50)
                }
                .background(
                    ZStack {
                        Color.black.opacity(0.18)
                            .blur(radius: 8)
                            .cornerRadius(10)
                        BlurView(style: .systemUltraThinMaterialDark)
                            .cornerRadius(10)
                            .opacity(1.0)
                    }
                )
                .overlay(
                    ZStack {
                        RoundedRectangle(cornerRadius: .infinity)
                            .stroke(Color.white.opacity(0.20), lineWidth: 0.7)
                                    
                        RoundedRectangle(cornerRadius: .infinity)
                            .stroke(Color.white.opacity(0.12), lineWidth: 1)
                            .blur(radius: 1.6)
                            .clipShape(RoundedRectangle(cornerRadius: .infinity))
                            .opacity(0.6)
                    }
                )
                .clipShape(RoundedRectangle(cornerRadius: .infinity, style: .continuous))
                .shadow(color: Color.white.opacity(0.13), radius: 2, x: 0, y: 0)
                .compositingGroup()
                .padding(8)
                
            }
            
            
            Spacer()
            Button(action: {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.82)) {
                    isListening.toggle()
                }
            }) {
                Image(systemName: !isListening ? "mic.fill" : "square.fill")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
                    .frame(width: 50, height: 50)
            }
            .background(
                ZStack {
                    Color.black.opacity(0.18)
                        .blur(radius: 8)
                        .cornerRadius(10)
                    BlurView(style: .systemUltraThinMaterialDark)
                        .cornerRadius(10)
                        .opacity(1.0)
                }
            )
            .overlay(
                ZStack {
                    RoundedRectangle(cornerRadius: .infinity)
                        .stroke(Color.white.opacity(0.20), lineWidth: 0.7)
                                
                    RoundedRectangle(cornerRadius: .infinity)
                        .stroke(Color.white.opacity(0.12), lineWidth: 1)
                        .blur(radius: 1.6)
                        .clipShape(RoundedRectangle(cornerRadius: .infinity))
                        .opacity(0.6)
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: .infinity, style: .continuous))
            .shadow(color: Color.white.opacity(0.13), radius: 2, x: 0, y: 0)
            .compositingGroup()
            .padding(8)
            Spacer()
            if !isListening {
                Button(action: {
//                    goToCalm = true
                    vm.generateText(text: text)
                }) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
                    .frame(width: 50, height: 50)
                }
                .background(
                    ZStack {
                        Color.black.opacity(0.18)
                            .blur(radius: 8)
                            .cornerRadius(10)
                        BlurView(style: .systemUltraThinMaterialDark)
                            .cornerRadius(10)
                            .opacity(1.0)
                    }
                )
                .overlay(
                    ZStack {
                        RoundedRectangle(cornerRadius: .infinity)
                            .stroke(Color.white.opacity(0.20), lineWidth: 0.7)
                                    
                        RoundedRectangle(cornerRadius: .infinity)
                            .stroke(Color.white.opacity(0.12), lineWidth: 1)
                            .blur(radius: 1.6)
                            .clipShape(RoundedRectangle(cornerRadius: .infinity))
                            .opacity(0.6)
                    }
                )
                .clipShape(RoundedRectangle(cornerRadius: .infinity, style: .continuous))
                .shadow(color: Color.white.opacity(0.13), radius: 2, x: 0, y: 0)
                .compositingGroup()
                .padding(8)
                .disabled(text.isEmpty)
            }
            
            
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
        
    func bigHaloBreathing(vm: ExpressionViewModel) -> some View {
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
    
    private func jitter(_ base: Double, percent: Double = 0.08) -> Double {
        let delta = base * percent
        return base + Double.random(in: -delta...delta)
    }
    
    private func startBreathing() {
        inhale()
    }

    private func inhale() {
        let duration = jitter(4.2)
        let targetScale = jitter(1, percent: 0.06)
        let targetOpacity = jitter(0.76, percent: 0.05)
        
        withAnimation(.easeInOut(duration: duration)) {
            scale = targetScale
            coreOpacity = targetOpacity
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            exhale()
        }
    }

    private func exhale() {
        let duration = jitter(6.1)
        let targetScale = jitter(1.5, percent: 0.04)
        let targetOpacity = jitter(0.88, percent: 0.04)
        
        withAnimation(.easeInOut(duration: duration)) {
            scale = targetScale
            coreOpacity = targetOpacity
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            inhale()
        }
    }
    
    private func startDrift() {
        let duration = jitter(8.0, percent: 0.15)

            withAnimation(.easeInOut(duration: duration)) {
                drift = CGSize(
                    width: Double.random(in: -40...40),
                    height: Double.random(in: -40...40)
                )
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + duration * 0.9) {
                startDrift()
            }
    }
    
//    private func startDriftParticle() {
//        let duration = jitter(8.0, percent: 0.15)
//
//            withAnimation(.easeInOut(duration: duration)) {
//                driftParticle = CGSize(
//                    width: Double.random(in: -8...8),
//                    height: Double.random(in: -8...8)
//                )
//            }
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + duration * 0.9) {
//                startDriftParticle()
//            }
//    }
    
    private func startDriftParticle() {
        Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 10)) {
                driftParticle = CGSize(
                    width: CGFloat.random(in: -20...20),
                    height: CGFloat.random(in: -20...20)
                )
            }
        }
    }
    
    private func startShimmer() {
        withAnimation(
            .easeInOut(duration: jitter(6, percent: 0.3))
        ) {
            shimmer = Double.random(in: -0.015...0.015)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            startShimmer()
        }
    }

}




#Preview {
    ExpressionView()
}

extension Animation {
    func `repeat`(while expression: Bool, autoreverses: Bool = true) -> Animation {
        if expression {
            return self.repeatForever(autoreverses: autoreverses)
        } else {
            return self
        }
    }
}
