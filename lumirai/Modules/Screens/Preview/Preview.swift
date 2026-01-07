//import SwiftUI
//
//struct PreviewScreen: View {
//    @State private var isAnimating = false
//        
//        // Warna-warna yang diambil dari referensi gambar (Ungu, Biru, Merah Bata, Cyan)
//        let colors: [Color] = [
//            Color(red: 0.1, green: 0.0, blue: 0.2), // Dark base
//            Color(red: 0.4, green: 0.1, blue: 0.6), // Purple
//            Color(red: 0.1, green: 0.5, blue: 0.7), // Cyan/Blue
//            Color(red: 0.6, green: 0.2, blue: 0.2), // Reddish
//            Color(red: 0.1, green: 0.0, blue: 0.3)  // Back to dark
//        ]
//
//        var body: some View {
//            ZStack {
//                // 1. Background Gelap
//                Color.black
//                    .ignoresSafeArea()
//                
//                // 2. Orb Container
//                ZStack {
//                    
//                    // Layer A: Base Glow (Warna dasar nebula)
//                    Circle()
//                        .fill(
//                            AngularGradient(gradient: Gradient(colors: [
//                                Color.purple.opacity(0.4),
//                                Color.blue.opacity(0.3),
//                                Color.red.opacity(0.3),
//                                Color.purple.opacity(0.4)
//                            ]), center: .center)
//                        )
//                        .blur(radius: 20)
//                        .rotationEffect(.degrees(isAnimating ? 360 : 0))
//                        .animation(.linear(duration: 20).repeatForever(autoreverses: false), value: isAnimating)
//                    
//                    // Layer B: Swirls (Garis-garis tipis melengkung)
//                    // Kita gunakan AngularGradient dengan stroke untuk meniru garis halus
//                    Circle()
//                        .strokeBorder(
//                            AngularGradient(gradient: Gradient(colors: [
//                                .clear,
//                                .cyan.opacity(0.5),
//                                .clear,
//                                .orange.opacity(0.4),
//                                .clear,
//                                .purple.opacity(0.5),
//                                .clear
//                            ]), center: .center),
//                            lineWidth: 30
//                        )
//                        .blur(radius: 10)
//                        .rotationEffect(.degrees(isAnimating ? -360 : 0))
//                        .animation(.linear(duration: 15).repeatForever(autoreverses: false), value: isAnimating)
//                        .scaleEffect(0.9)
//                    
//                    // Layer C: Inner Depth (Memberi kesan 3D gelap di tengah)
//                    Circle()
//                        .fill(
//                            RadialGradient(gradient: Gradient(colors: [
//                                Color.black.opacity(0.6),
//                                Color.clear
//                            ]), center: .center, startRadius: 10, endRadius: 150)
//                        )
//                    
//                    // Layer D: Glassy Reflection (Kilau di pinggir)
//                    Circle()
//                        .strokeBorder(
//                            LinearGradient(gradient: Gradient(colors: [
//                                Color.white.opacity(0.6),
//                                Color.white.opacity(0.1),
//                                Color.clear,
//                                Color.white.opacity(0.2)
//                            ]), startPoint: .topLeading, endPoint: .bottomTrailing),
//                            lineWidth: 1
//                        )
//                        .blendMode(.overlay)
//                    
//                    // Layer E: Subtle Light Reflection (Titik cahaya halus)
//                    Circle()
//                        .fill(
//                            RadialGradient(gradient: Gradient(colors: [
//                                Color.white.opacity(0.2),
//                                Color.clear
//                            ]), center: .topLeading, startRadius: 5, endRadius: 80)
//                        )
//                        .offset(x: -50, y: -50)
//
//                }
//                .frame(width: 300, height: 300)
//                // Efek napas (Pulsing)
//                .scaleEffect(isAnimating ? 1.05 : 0.95)
//                .animation(.easeInOut(duration: 4).repeatForever(autoreverses: true), value: isAnimating)
//            }
//            .onAppear {
//                isAnimating = true
//            }
//        }
//}
//
//#Preview {
//    PreviewScreen()
//}

import SwiftUI
import Combine

// MARK: - Enums & Data Models
enum Emotion {
    case anxiety, sadness, calm
    
    var colors: [Color] {
        switch self {
        case .anxiety:
            return [Color(hex: "7FDBFF"), Color(hex: "FFD166")] // Aqua -> Amber
        case .sadness:
            return [Color(hex: "FFD700"), Color.white] // Gold -> White
        case .calm:
            return [Color(hex: "FFFFF0"), Color(hex: "E0F7FA")] // Ivory -> Blue
        }
    }
}

enum SessionMode {
    case breath, walk, journal, call
}

// MARK: - Main View
struct CalmSessionView: View {
    // Parameters (bisa di-pass dari screen sebelumnya)
    @State var currentEmotion: Emotion = .anxiety
    @State var currentMode: SessionMode = .breath
    
    // Animation States
    @State private var isVisible: Bool = false
    @State private var breatheState: Bool = false // False = Inhale, True = Exhale
    @State private var progress: CGFloat = 0.0
    @State private var journalText: String = ""
    @State private var instructionText: String = "Prepare..."
    
    // Timer
    let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    @State private var timeElapsed: Double = 0
    let totalDuration: Double = 60 // 1 menit sesi contoh
    
    var body: some View {
        ZStack {
            // 1. Dynamic Aurora Background
            LinearGradient(
                gradient: Gradient(colors: currentEmotion.colors),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            .opacity(isVisible ? 1 : 0) // Soft Fade Entry (1.5s)
            .animation(.easeInOut(duration: 1.5), value: isVisible)
            
            // 2. Halo & Timer Arc Layer
            ZStack {
                // Outer Glow (Aurora Shift)
                Circle()
                    .fill(Color.white.opacity(0.3))
                    .frame(width: breatheState ? 320 : 180, height: breatheState ? 320 : 180)
                    .blur(radius: breatheState ? 60 : 30) // Blur intensifies on inhale
                
                // Timer Arc
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round))
                    .foregroundColor(.white.opacity(0.5))
                    .rotationEffect(.degrees(-90))
                    .frame(width: 320, height: 320)
                
                // Inner Halo (Solid Breath)
                Circle()
                    .fill(Color.white.opacity(0.85))
                    .frame(width: breatheState ? 280 : 140, height: breatheState ? 280 : 140)
                    .shadow(color: .white.opacity(0.5), radius: 20, x: 0, y: 0)
                
                // 3. Instruction Text (Centered in Halo)
                if currentMode == .breath || currentMode == .walk {
                    Text(instructionText)
                        .font(.system(size: 28, weight: .medium, design: .rounded))
                        .foregroundColor(currentEmotion == .sadness ? .gray : .blue.opacity(0.6))
                        .transition(.opacity)
                        .id("instruction_\(instructionText)") // Force animation on text change
                }
            }
            .offset(y: currentMode == .journal || currentMode == .call ? -100 : 0) // Shift up for input modes
            
            // 4. Mode Specific UI (Bottom Area)
            VStack {
                Spacer()
                
                switch currentMode {
                case .breath, .walk:
                    EmptyView() // Text is inside Halo
                    
                case .journal:
                    // Glassmorphism Input
                    HStack {
                        TextField("What's on your mind?", text: $journalText)
                            .padding()
                            .background(.ultraThinMaterial) // Glass effect
                            .cornerRadius(20)
                            .foregroundColor(.black)
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 50)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    
                case .call:
                    // Call Friend Deep Link Button
                    VStack(spacing: 10) {
                        Text("Reach out to Sarah?")
                            .font(.system(.body, design: .rounded))
                            .foregroundColor(.white.opacity(0.8))
                        
                        Button(action: {
                            // Action: Open Phone/Whatsapp
                            print("Deep link triggered")
                        }) {
                            HStack {
                                Image(systemName: "phone.fill")
                                Text("Slide to Call")
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(30)
                            .overlay(
                                RoundedRectangle(cornerRadius: 30)
                                    .stroke(Color.white, lineWidth: 1)
                            )
                        }
                    }
                    .padding(.horizontal, 60)
                    .padding(.bottom, 80)
                }
            }
        }
        .onAppear {
            // Entry Transition
            withAnimation(.easeIn(duration: 1.5)) {
                isVisible = true
            }
            startBreathingCycle()
        }
        .onReceive(timer) { _ in
            updateTimer()
        }
    }
    
    // MARK: - Logic Functions
    
    func startBreathingCycle() {
        // Breath Cadence Logic (e.g., 4-6)
        // Ini loop animasi sederhana
        let inhaleDuration: Double = 4.0
        let exhaleDuration: Double = 6.0
        
        withAnimation(.easeInOut(duration: inhaleDuration)) {
            breatheState = true // Expand (Inhale)
            instructionText = "Slow Inhale..."
        }
        
        // Schedule Exhale
        DispatchQueue.main.asyncAfter(deadline: .now() + inhaleDuration) {
            withAnimation(.easeInOut(duration: exhaleDuration)) {
                breatheState = false // Shrink (Exhale)
                instructionText = "Exhale..."
            }
            
            // Loop (Recursive for demo)
            DispatchQueue.main.asyncAfter(deadline: .now() + exhaleDuration) {
                if self.progress < 1.0 { // Stop if session ends
                    self.startBreathingCycle()
                }
            }
        }
    }
    
    func updateTimer() {
        if timeElapsed < totalDuration {
            timeElapsed += 0.05
            withAnimation {
                progress = CGFloat(timeElapsed / totalDuration)
            }
        }
    }
}

// MARK: - Helper for Hex Colors

// MARK: - Preview Provider
struct CalmSessionView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Preview 1: Anxiety + Breath Mode
            CalmSessionView(currentEmotion: .anxiety, currentMode: .breath)
                .previewDisplayName("Anxiety (Breath)")
            
            // Preview 2: Sadness + Journal Mode
            CalmSessionView(currentEmotion: .sadness, currentMode: .journal)
                .previewDisplayName("Sadness (Journal)")
            
            CalmSessionView(currentEmotion: .calm, currentMode: .walk)
                .previewDisplayName("calm (walk)")
        }
    }
}
