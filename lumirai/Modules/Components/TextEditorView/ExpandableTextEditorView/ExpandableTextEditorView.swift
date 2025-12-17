//
//  ExpandableTextEditorView.swift
//  lumirai
//
//  Created by dana nur fiqi on 01/12/25.
//

import Foundation
import SwiftUI

struct ExpandableTextEditorView: View {
    @Binding var text: String
    @State private var height: CGFloat = 20
    
    init(text: Binding<String>) {
        self._text = text
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        VStack {
            Spacer() // ✨ Ini yang membuat expand ke atas
            
            ZStack(alignment: .topLeading) {
                if text.isEmpty {
                    Text("When you’re ready, I’m listening.")
                        .font(AppFonts.nunito(size: 14))
                        .foregroundColor(.gray)
                        .padding(2)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                
                TextEditor(text: $text)
                    .frame(height: height)
                    .padding(2)
                    .cornerRadius(10)
                    .scrollContentBackground(.hidden)
                    .font(AppFonts.nunito(size: 14))
                    .onChange(of: text) { _ in
                        recalcHeight()
                    }
                    .foregroundColor(.white)
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            UITextView.appearance().backgroundColor = .clear
            recalcHeight()
        }
    }
    
    private func recalcHeight() {
        let maxWidth = UIScreen.main.bounds.width - 60
        let size = CGSize(width: maxWidth, height: .infinity)
        
        let rect = text.boundingRect(
            with: size,
            options: .usesLineFragmentOrigin,
            attributes: [.font: UIFont.systemFont(ofSize: 14)],
            context: nil
        )
        
        let calculated = rect.height + 20
        height = min(max(calculated, 40), 100) // 🚀 Expand ke atas + ada max height
    }
}
