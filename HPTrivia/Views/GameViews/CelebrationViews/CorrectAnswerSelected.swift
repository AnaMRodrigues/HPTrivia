//
//  CorrectAnswerSelected.swift
//  HPTrivia
//
//  Created by Ana Clara Moreira Rodrigues on 29/03/26.
//

import SwiftUI

struct CorrectAnswerSelected: View {
    @Binding var tappedCorrectAnswer: Bool
    
    @Environment(Game.self) private var game
    
    let geo: GeometryProxy
    var namespace: Namespace.ID
    
    var body: some View {
        VStack{
            if tappedCorrectAnswer {
                Text(game.currentQuestion.answer)
                    .minimumScaleFactor(0.5)
                    .multilineTextAlignment(.center)
                    .padding(10)
                    .frame(width: geo.size.width / 2.15, height: 80)
                    .background(tappedCorrectAnswer ? .green.opacity(0.7) : .yellow.opacity(0.5))
                    .clipShape(.rect(cornerRadius: 25))
                    .scaleEffect(2)
                    .matchedGeometryEffect(id: 1, in: namespace)
            }
        }
        .frame(width: geo.size.width)
    }
}

#Preview {
    CorrectAnswerSelectedPreviewWrapper()
}

struct CorrectAnswerSelectedPreviewWrapper: View {
    @Namespace var namespace
    
    var body: some View {
        GeometryReader { geo in
            CorrectAnswerSelected(
                tappedCorrectAnswer: .constant(true),
                geo: geo,
                namespace: namespace
            )
            .environment(Game())
        }
    }
}
