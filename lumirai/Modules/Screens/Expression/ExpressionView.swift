//
//  ExpressionView.swift
//  lumirai
//
//  Created by dana nur fiqi on 26/11/25.
//
import SwiftUI

struct ExpressionView: View {
    @State private var isAnimating = false
    @State private var text: String = ""
    @StateObject private var viewmodel = ExpressionViewModel()
    @FocusState private var isFocused : Bool
    @State private var isListening : Bool = false
    @State private var animate: Bool = false
    
    @State private var float = false
    @State private var goToCalm = false
    var body: some View {
        BaseView(viewModel: viewmodel) { vm in
            ZStack {
                GradientBackgroundView()
                    .ignoresSafeArea()
                bigHaloBreathing(vm : viewmodel)
                    .frame(width: 300, height: 300)
                    .scaleEffect(isListening ? vm.haloPulse : 1)
                    .animation(.easeInOut(duration: 1), value: isListening)
                
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
                isAnimating = true
                float = true
                if !isListening {
                    animate = true
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $goToCalm) {
                CalmView()
            }
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
                    goToCalm = true
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
            }
            
            
        }
    }
    
    
    func textScroll(vm: ExpressionViewModel) -> some View {
        ScrollViewReader { proxy in
            ScrollView {
                if text.isEmpty {
                    Text(vm.textPlaceholder)
                        .font(AppFonts.nunito(size: 20))
                        .foregroundColor(.white.opacity(0.4))
                        .padding(.horizontal, 22)
                        .padding(.vertical, 18)
                        .allowsHitTesting(false)
                }
                VStack(alignment: .leading) {
                    TextEditor(text: $text)
                        .font(AppFonts.nunito(size: 20))
                        .foregroundColor(.white)
                        .padding()
                        .scrollContentBackground(.hidden)
                        .background(Color.clear)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .id("BOTTOM")
                        .focused($isFocused)
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
            if isListening {
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                Color(hex: "E6F0FF"),
                                Color(hex: "E6F0FF").opacity(0.25)
                            ]),
                            center: .center,
                            startRadius: 0,
                            endRadius: 260
                        )
                    )
                    .frame(maxWidth: .infinity, maxHeight:.infinity)
                    .blur(radius: 70)
                    .opacity( 0.9)
            } else {
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                Color(hex: "E6F0FF"),
                                Color(hex: "E6F0FF").opacity(0.25)
                            ]),
                            center: .center,
                            startRadius: 0,
                            endRadius: 260
                        )
                    )
                    .frame(maxWidth: .infinity, maxHeight:.infinity)
                    .blur(radius: 70)
                    .scaleEffect(animate ? 1.05 : 0.95)
                    .opacity(animate ? 0.9 : 0.4)
                    .animation(
                        Animation.easeInOut(duration: 6.5)
                            .repeatForever(autoreverses: true),
                        value: animate
                    )
            }
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
