import SwiftUI
import Combine
import Foundation

extension Color {
    static let haloCool = Color(hex: "#7DB5E8")
    static let haloBase = Color(hex: "#5A9FDB")
    static let blue = Color(hex: "#00A4E4")
}

final class HaloBreathingController: ObservableObject {
    @Published var scale: CGFloat = 1.0
    @Published var coreOpacity: Double = 0.88
    @Published var blur: CGFloat = 60

    private var isExpanding = false

    func start() {
        scheduleNextCycle()
    }

    private func scheduleNextCycle() {
        let baseDuration = Double.random(in: 4.5...6.0)
        let variation = baseDuration * Double.random(in: -0.1...0.1)
        let duration = baseDuration + variation

        withAnimation(.easeInOut(duration: duration)) {
            if isExpanding {
                scale = 1.0
                coreOpacity = 0.88
                blur = 60
            } else {
                scale = CGFloat.random(in: 1.12...1.15)
                coreOpacity = Double.random(in: 0.82...0.85)
                blur = CGFloat.random(in: 65...75)
                
            }
        }

        isExpanding.toggle()

        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            self.schedulePause()
        }
    }

    private func schedulePause() {
        let pause = Double.random(in: 0.4...0.8)
        DispatchQueue.main.asyncAfter(deadline: .now() + pause) {
            self.scheduleNextCycle()
        }
    }
}

struct HaloLightLayer: View {
    let opacity: Double
    let blur: CGFloat
    var colorCore: Color = Color(hex: "#7DB5E8")
    var colorOuter: Color = Color(hex: "#5A9FDB")

    var body: some View {
        Circle()
            .fill(
                RadialGradient(
                    gradient: Gradient(stops: [
                        .init(color: colorOuter.opacity(opacity), location: 0.0),
                        .init(color: colorOuter.opacity(opacity * 0.7), location: 0.5),
                        .init(color: colorCore.opacity(0.05), location: 1.0)
                    ]),
                    center: .center,
                    startRadius: 0,
                    endRadius: 300
                )
            )
            .blur(radius: blur)
            .blendMode(.plusLighter)
    }
}

struct HaloDriftView<Content: View>: View {
    @State private var offset: CGSize = .zero
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .offset(offset)
            .onAppear {
                startDrift()
            }
    }

    private func startDrift() {
        let dx = CGFloat.random(in: -6...6)
        let dy = CGFloat.random(in: -6...6)
        let duration = Double.random(in: 20...30)

        withAnimation(.linear(duration: duration)) {
            offset = CGSize(width: dx, height: dy)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            startDrift()
        }
    }
}


//struct HaloCore: View {
//    var body: some View {
//        Circle()
//            .fill(
//                RadialGradient(
//                    gradient: Gradient(stops: [
//                        .init(color: Color.haloCore.opacity(0.9), location: 0.0),   // pusat
//                        .init(color: Color.haloCore.opacity(0.65), location: 0.5),  // tengah
//                        .init(color: Color.haloOuter.opacity(0.08), location: 1.0)  // tepi
//                    ]),
//                    center: .center,
//                    startRadius: 0,
//                    endRadius: 300
//                )
//            )
//            .blur(radius: 60)
//            .blendMode(.plusLighter)
//    }
//}

//struct HaloLayerSoft: View {
//    var body: some View {
//        Circle()
//            .fill(
//                RadialGradient(
//                    gradient: Gradient(colors: [
//                        Color.haloOuter.opacity(0.25),
//                        Color.haloOuter.opacity(0.0)
//                    ]),
//                    center: .center,
//                    startRadius: 0,
//                    endRadius: 400
//                )
//            )
//            .blur(radius: 80)
//            .blendMode(.plusLighter)
//    }
//}

struct LumiraiHaloView: View {
//    @StateObject private var breath = HaloBreathingController()
    @State private var animate = false


    var body: some View {
        GeometryReader { geo in
            HaloDriftView {
                ZStack {
                    HaloLightLayer(opacity: 0.35, blur: 60 + 15)
                    HaloLightLayer(opacity: 0.6, blur: 60)
                    HaloLightLayer(opacity: 0.88, blur: 60 - 10)
                }
                .frame(
                    width: geo.size.width * 0.35,
                    height: geo.size.width * 0.35
                )
                .scaleEffect(animate ? 1.5 : 1.0)
            }
            .position(
                x: geo.size.width / 2,
                y: geo.size.height / 2
            )
            
            .animation(
                Animation.easeInOut(duration: 3.0)
                    .repeatForever(autoreverses: true),
                value: animate
            )
            .onAppear {
                animate = true
            }
        }
        .ignoresSafeArea()
        .background(Color("#0A0F16"))
    }
}

#Preview {
    LumiraiHaloView()
}
