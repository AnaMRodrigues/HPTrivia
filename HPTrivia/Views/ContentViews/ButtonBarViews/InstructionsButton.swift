//
//  InstructionsButton.swift
//  HPTrivia
//
//  Created by Ana Clara Moreira Rodrigues on 17/03/26.
//

import SwiftUI

struct InstructionsButton: View {
    @Binding var animateViewsIn: Bool
    @State private var showInstructions = false
    
    let geo: GeometryProxy
    
    var body: some View {
        VStack {
            if animateViewsIn {
                Button {
                    showInstructions.toggle()
                } label: {
                    Image(systemName: "info.circle.fill")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                        .shadow(radius: 5)
                }
                .transition(.offset(x: -geo.size.width/2))
            }
        }
        .animation(.easeOut(duration: 0.7).delay(1.5), value: animateViewsIn)
        .sheet(isPresented: $showInstructions) {
            Instructions()
        }
    }
}

#Preview {
    GeometryReader { geo in
        InstructionsButton(animateViewsIn: .constant(true), geo: geo)
    }
}
