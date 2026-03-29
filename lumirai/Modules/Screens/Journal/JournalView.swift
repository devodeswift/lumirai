//
//  JournalView.swift
//  lumirai
//
//  Created by dana nur fiqi on 29/03/26.
//

import Foundation
import SwiftUI
import Combine

struct JournalView: View {
    @StateObject private var viewmodel = JournalViewModel()
    @EnvironmentObject private var router: Router
    @State private var animatedScale: CGFloat = 1.0
    @State private var animatedCoreOpacity: Double = 0.85
    @State private var animate: Bool = false
    @FocusState private var isFocused : Bool
    @State private var text: String = ""
    @State private var showTextJournal: Bool = false
    
    func textScroll(vm: JournalViewModel ) -> some View {
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
//                        .onChange(of: isFocused) { focused in
//                            if !focused {
////                                vm.getResponse(text: text)
//                                vm.sendTextEngine(text: text)
//                            }
//                        }
                    
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
    
    var body: some View {
        BaseView(viewModel: viewmodel){ vm in
            ZStack{
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
                    .scaleEffect(animatedScale)
                    
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
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        if !showTextJournal {
                            textScroll(vm: vm)
                        } else {
                            ZStack{
                                Text(vm.textJournal)
                                    .font(AppFonts.nunito(size: 20))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 20)
                                    .multilineTextAlignment(.center)
                                    .opacity(showTextJournal ? 1 : 0)
                                    .animation(.easeInOut(duration: 0.5), value: showTextJournal)
                            }
                            .frame(maxWidth:.infinity, maxHeight: .infinity)
                            .padding(.top, -80)
                        }
                    }
                }
            }
            .background(Color(hex:"#0A0F16"))
            .navigationBarBackButtonHidden(true)
            .onAppear {
                vm.onFinished = {
                    router.push(.expression)
                }
            }
            .onChange(of: vm.isShowTextJournal) { newValue in
                showTextJournal = newValue
            }
            
            
        }
    }
}

#Preview {
    JournalView()
}
