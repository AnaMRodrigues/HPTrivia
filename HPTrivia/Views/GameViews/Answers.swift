//
//  Answers.swift
//  HPTrivia
//
//  Created by Ana Clara Moreira Rodrigues on 30/03/26.
//

import SwiftUI

struct Answers: View {
    @Binding var animateViewsIn: Bool
    @Binding var tappedCorrectAnswer: Bool
    @Binding var wrongAnswersTapped: [String]
    @Binding var animatedScore: Int
    
    @Environment(Game.self) private var game
    
    let geo: GeometryProxy
    let namespace: Namespace.ID
    
    var body: some View {
        LazyVGrid (columns: [GridItem(), GridItem()]) {
            ForEach(game.answers, id: \.self) { answer in
                if answer == game.currentQuestion.answer {
                    CorrectAnswer(
                        animateViewsIn: $animateViewsIn,
                        tappedCorrectAnswer: $tappedCorrectAnswer,
                        animatedScore: $animatedScore,
                        answer: answer,
                        geo: geo,
                        namespace: namespace)
                } else {
                    WrongAnswer(
                        animateViewsIn: $animateViewsIn,
                        wrongAnswersTapped: $wrongAnswersTapped,
                        answer: answer,
                        geo: geo)
                }
            }
        }
        .frame(width: geo.size.width)
        .animation(.easeOut(duration: animateViewsIn ? 1.5 : 0).delay(animateViewsIn ? 2 : 0), value: animateViewsIn)
    }
    
}

#Preview {
    AnswersPreviewWrapper()
}

struct AnswersPreviewWrapper: View {
    @Namespace var namespace
    
    var body: some View {
        GeometryReader { geo in
            Answers(animateViewsIn: .constant(true), tappedCorrectAnswer: .constant(false), wrongAnswersTapped: .constant([]), animatedScore: .constant(0), geo: geo, namespace: namespace)
                .environment(Game())
        }
    }
}
