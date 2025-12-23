//
//  ExpressionView.swift
//  lumirai
//
//  Created by dana nur fiqi on 26/11/25.
//
import SwiftUI
import AVFoundation
import Combine
import Speech

struct ExpressionView: View {
    @State private var isAnimating = false
    @State private var blink = false
    @State private var text: String = ""
    @FocusState private var isFocused : Bool
    @State private var isListening : Bool = false
    @StateObject private var pulseManager = VoicePulseManager()
    @State private var haloPulse: CGFloat = 1.0
    @StateObject private var speech = SpeechRecognizer()
    @State private var float = false
    @State private var goToCalm = false
    var body: some View {
        ZStack {
            backgroundColor()
            StaticNebulusHalo()
                .frame(width: 400, height: 400)
//                .background(.blue)
//                .scaleEffect(isListening ? haloPulse : 1)
//                .animation(.easeInOut(duration: 1), value: isListening)
            
            VStack(alignment: .center) {
                Text("LUMIRAi")
                    .font(AppFonts.playFairDisplayReg(size: 24))
                    .foregroundColor(.white)
                    .padding(.top, 10)
//                hallowedCircle()
//                HalloView(config: HaloViewModel(
//                    colors: [
//                        Color(hex: "E6F1FF").opacity(0.92),
//                        Color(hex: "B6D6FF").opacity(0.82),
//                        Color(hex: "7FAEFF").opacity(0.74),
//                        Color(hex: "6B7CFF").opacity(0.70),
//                        Color(hex: "7A63C8").opacity(0.62),
//                        Color(hex: "2B2F3F").opacity(0.55),
//                        Color(hex: "0A0F16").opacity(0.10)
//                    ]
//                ))
//                    .frame(width: 200, height: 200)
//                    .padding(.top, 50)
//                    .scaleEffect(isListening ? haloPulse : 1)
//                .animation(.easeInOut(duration: 1), value: isListening)
//                    .offset(y: float ? -10 : 10)        // naik turun
//                    .animation(
//                        Animation.easeInOut(duration: 2)
//                            .repeatForever(autoreverses: true),
//                        value: float
//                    )
//                SpiralHaloView()
//                SpiralHaloView(
//                    size: 200,
//                    lineCount: 100,
//                    color: Color(hex: "6FA8FF")
//                )
//                .blur(radius: 0.5)
//                SpiralHaloFlowView(
//                    size: 200,
//                    lineCount: 100,
//                    color: Color(hex: "5FA8FF")
//                )
//                EnergyHaloView()
//                .blur(radius: 0.8)
//                .shadow(color: Color(hex: "5FA8FF").opacity(0.35), radius: 24)
                Spacer()
                textScroll()
                bottomView()
                    .frame(maxWidth: .infinity, maxHeight: 40)
                    .padding(.horizontal, 20)
            }
        }
        .onAppear {
            isAnimating = true
            float = true
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
                pulseManager.start()
            } else {
                pulseManager.stop()
            }
        }
        .onReceive(pulseManager.$amplitude) { value in
            
            let clamped = min(max(value, 0), 2) // pastikan tetap aman
            let mapped = 1.0 + (clamped * 0.5)  // range 1.0 → 1.8
            
            withAnimation(.spring(response: 0.25, dampingFraction: 0.55)) {
                    haloPulse = mapped
                
            }
            
        }
        .onReceive(speech.$text) { newValue in
           
            AppLogger.shared.log(newValue)
            if isListening {
                text = newValue
            }
        }
    }
    
    func backgroundColor() -> some View {
        ZStack {
            Color(hex: "0A0F16") // Base
            RadialGradient(
                colors: [Color(hex: "1E546F").opacity(0.4), .clear],
                center: .bottom,
                startRadius: 0,
                endRadius: 500
            )
            RadialGradient(
                colors: [Color(hex: "1E546F").opacity(0.4), .clear],
                center: .top,
                startRadius: 0,
                endRadius: 500
            )
        }.ignoresSafeArea()
    }
    
    func hallowedCircle() -> some View {
        ZStack {
            SmokeRingShape(wobbleFactor: 0.1, waves: 6)
                .stroke(
                    AngularGradient(gradient: Gradient(colors: [
                        .white.opacity(0.0), .white.opacity(0.3),
                        .white.opacity(0.0), .white.opacity(0.4),
                        .white.opacity(0.0), .white.opacity(0.2)]),
                        center: .center),
                    style: StrokeStyle(lineWidth: 40, lineCap: .round, lineJoin: .round)
                )
                .frame(width: 185, height: 185)
                .blur(radius: 30)
                .rotationEffect(.degrees(isAnimating ? 360 : 0))
                .animation(.linear(duration: 12).repeatForever(autoreverses: false), value: isAnimating)
            SmokeRingShape(wobbleFactor: 0.15, waves: 8)
                .stroke(AngularGradient(gradient: Gradient(colors: [
                        .white.opacity(0.1),
                        .white.opacity(0.6),
                        .white.opacity(0.0),
                        .white.opacity(0.5),
                        .white.opacity(0.1),
                        .white.opacity(0.7),
                        .white.opacity(0.0)]),
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: 15, lineCap: .round, lineJoin: .round)
                )
                .frame(width: 185, height: 185)
                .blur(radius: 12)
                .rotationEffect(.degrees(isAnimating ? -360 : 0))
                .animation(.linear(duration: 25).repeatForever(autoreverses: false), value: isAnimating)
            SmokeRingShape(wobbleFactor: 0.2, waves: 5)
                .stroke(
                    AngularGradient( gradient: Gradient(colors: [
                        .white.opacity(0.0),
                        .white.opacity(0.3),
                        .white.opacity(0.0)]),
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: 5, lineCap: .round)
                )
                .frame(width: 185, height: 185)
                .blur(radius: 12)
                .rotationEffect(.degrees(isAnimating ? 180 : 0))
                .animation(.linear(duration: 40).repeatForever(autoreverses: false), value: isAnimating)
            
            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color(hex: "4FACFE").opacity(0.3), // Light Blue
                            Color(hex: "1E546F").opacity(0.5)  // Teal (Match bg)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 210, height: 210)
                .blur(radius: 12) // Blur lebih lembut
                .scaleEffect(isListening ? haloPulse : 1)
                .animation(.easeInOut(duration: 1), value: isListening)
            
            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color(hex: "E0F7FA"),
                            Color(hex: "26C6DA"),
                            Color(hex: "006064")
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 180, height: 180)
                .blur(radius: 12)
                .opacity(0.9)
                .rotationEffect(.degrees(180))
                .scaleEffect(isListening ? haloPulse : 1)
                .animation(.easeInOut(duration: 0.2), value: isListening)
        
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color.white.opacity(0.6),
                            Color.white.opacity(0.0)
                        ]),
                        center: .topLeading,
                        startRadius: 0,
                        endRadius: 160
                    )
                )
                .frame(width: 180, height: 180)
                .blendMode(.overlay)
                .blur(radius: 12)
                .rotationEffect(.degrees(180))
                .scaleEffect(isListening ? haloPulse : 1)
                .animation(.easeInOut(duration: 0.2), value: isListening)
            
            Circle()
                .stroke(
                    LinearGradient(
                        colors: [
                            .white.opacity(0.95),
                            .white.opacity(0.2),
                            Color(hex: "84FFFF").opacity(0.6) // Cyan neon di bawah
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottom
                    ),
                    lineWidth: 3
                )
                .frame(width: 180, height: 180)
                .shadow(color: Color(hex: "84FFFF").opacity(0.5), radius: 15, x: 0, y: 0)
                .blur(radius: 12)
                .rotationEffect(.degrees(180))
                .scaleEffect(isListening ? haloPulse : 1)
                .animation(.easeInOut(duration: 0.2), value: isListening)
        }
    }
    
    func bottomView() -> some View {
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
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .background(.ultraThinMaterial)
                    .overlay(
                        Capsule()
                            .stroke(Color.white.opacity(0.20), lineWidth: 1)
                    )
                    .shadow(color: Color.blue.opacity(0.35), radius: 25)    // glow
                    .shadow(color: Color.purple.opacity(0.25), radius: 40)
                    .clipShape(Capsule())
                
            }
            
            
            Spacer()
            Button(action: {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.82)) {
                    isListening.toggle()
                        
                }
                
                
                if isListening {
                    speech.startListening()
                } else {
                    speech.stopListening()
                }
                
            }) {
                Image(systemName: !isListening ? "mic.fill" : "square.fill")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
                    .frame(width: 50, height: 50)
            }
                .transition(.move(edge: .leading).combined(with: .opacity))
                .background(.ultraThinMaterial)
                .overlay(
                    Capsule()
                        .stroke(Color.white.opacity(0.20), lineWidth: 1)
                )
                .shadow(color: Color.blue.opacity(0.35), radius: 25)    // glow
                .shadow(color: Color.purple.opacity(0.25), radius: 40)
                .clipShape(Capsule())
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
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .background(.ultraThinMaterial)
                .overlay(
                    Capsule()
                            .stroke(Color.white.opacity(0.20), lineWidth: 1)
                )
                .shadow(color: Color.blue.opacity(0.35), radius: 25)    // glow
                .shadow(color: Color.purple.opacity(0.25), radius: 40)
                .clipShape(Capsule())
            }
            
            
        }
    }
    
    func textFieldView() -> some View {
        ZStack(alignment: .leading){
            if text.isEmpty {
                Text("When you’re ready, I’m listening.")
                    .font(AppFonts.nunito(size: 20))
                    .foregroundColor(.white.opacity(0.5))
            }
            TextField("", text: $text, axis: .vertical)
                .font(AppFonts.nunito(size: 20))
                .foregroundColor(.white)
                .lineSpacing(6)
                .tint(.purple)
                .textFieldStyle(.plain)
                .multilineTextAlignment(.leading)
                .focused($isFocused)
                .background(Color.clear)
                .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            Button("Done") {
                                isFocused = false
                            }
                        }
                    }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func textScroll() -> some View {
        ScrollViewReader { proxy in
            ScrollView {
                if text.isEmpty {
                    Text("When you’re ready, I’m listening.")
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
                                .init(color: .clear, location: 0),      // fade top hilang
                                .init(color: .black, location: 0.12),
                                .init(color: .black, location: 0.88),
                                .init(color: .clear, location: 1.0)     // fade bottom hilang
                            ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        }
        .frame(maxWidth: .infinity ,maxHeight: .infinity)
    }
}

//
struct SmokeRingShape: Shape {
    var wobbleFactor: CGFloat // Seberapa penyok? (0.0 - 0.5)
    var waves: Double // Berapa banyak gumpalan? (misal 5-10)
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        
        // Loop mengelilingi 360 derajat
        for angle in stride(from: 0.0, through: 360.0, by: 1.0) {
            let radian = angle * .pi / 180
            
            // RUMUS DISTORSI:
            // Radius berubah berdasarkan Sinus wave
            let waveOffset = sin(Double(radian) * waves) * Double(wobbleFactor) * Double(radius)
            let currentRadius = radius + CGFloat(waveOffset)
            
            let x = center.x + currentRadius * cos(CGFloat(radian))
            let y = center.y + currentRadius * sin(CGFloat(radian))
            
            if angle == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        path.closeSubpath()
        return path
    }
}



#Preview {
    ExpressionView()
}


class VoicePulseManager: ObservableObject {
    private let engine = AVAudioEngine()
    
    @Published var amplitude: CGFloat = 0.0
    
    func start() {
        let inputNode = engine.inputNode
        let format = inputNode.inputFormat(forBus: 0)
        
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { buffer, _ in
            guard let channelData = buffer.floatChannelData?[0] else { return }
            
            let frameCount = Int(buffer.frameLength)
            let rms = sqrt((0..<frameCount).reduce(0.0) {
                $0 + Double(channelData[$1] * channelData[$1])
            } / Double(frameCount))
            
            // Normalize to safe UI range
            let normalized = min(max(CGFloat(rms * 25), 0.05), 1.2)
            
            DispatchQueue.main.async {
                self.amplitude = normalized
            }
        }
        
        try? engine.start()
    }
    
    func stop() {
        engine.stop()
        engine.inputNode.removeTap(onBus: 0)
        amplitude = 0.0
    }
}

class SpeechRecognizer: NSObject, ObservableObject {
    
    @Published var text: String = ""
    
    private let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    private let audioEngine = AVAudioEngine()
    
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?
    
    override init() {
        super.init()
        recognizer.delegate = self
    }
    
    func startListening() {
        stopListening()
        
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try? audioSession.setActive(true)
        
        request = SFSpeechAudioBufferRecognitionRequest()
        guard let request else { return }
        
        request.shouldReportPartialResults = true
        
        let inputNode = audioEngine.inputNode
        task = recognizer.recognitionTask(with: request) { result, error in
            if let result = result {
                DispatchQueue.main.async {
                    self.text = result.bestTranscription.formattedString
                }
            }
            
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        
        inputNode.removeTap(onBus: 0)
        
        inputNode.installTap(onBus: 0,
                             bufferSize: 1024,
                             format: recordingFormat) { buffer, _ in
            request.append(buffer)
        }
        
        audioEngine.prepare()
        try? audioEngine.start()
    }
    
    func stopListening() {
        audioEngine.stop()
        request?.endAudio()
        task?.cancel()
    }
}

extension SpeechRecognizer: SFSpeechRecognizerDelegate {}
