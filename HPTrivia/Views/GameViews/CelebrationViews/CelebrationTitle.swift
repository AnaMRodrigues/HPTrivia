//
//  CelebrationTitle.swift
//  HPTrivia
//
//  Created by Ana Clara Moreira Rodrigues on 29/03/26.
//

import SwiftUI

struct CelebrationTitle: View {
    @Binding var tappedCorrectAnswer: Bool
    
    let geo: GeometryProxy
    
    var body: some View {
        VStack {
            if tappedCorrectAnswer {
                Text("Brilliant")
                    .font(.custom("PartyLetPlain", size: 100))
                    .transition(.scale.combined(with: .offset(y: -geo.size.height / 2)))
            }
        }
        .animation(.easeInOut(duration: tappedCorrectAnswer ? 1 : 0).delay(tappedCorrectAnswer ? 1 : 0), value: tappedCorrectAnswer)
        .frame(width: geo.size.width)
    }
}

#Preview {
    GeometryReader { geo in
        CelebrationTitle(tappedCorrectAnswer: .constant(true), geo: geo)
    }
}
