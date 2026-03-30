//
//  ContinueButton.swift
//  HPTrivia
//
//  Created by Ana Clara Moreira Rodrigues on 29/03/26.
//

import SwiftUI

struct ContinueButton: View {
    @Binding var animateViewsIn: Bool
    @Binding var currentScreen: Screen
    @Binding var tappedCorrectAnswer: Bool
    @Binding var revealHint: Bool
    @Binding var revealBook: Bool
    @Binding var wrongAnswersTapped: [String]
    @Binding var movePointsToScore: Bool
    @Binding var animatedScore: Int
    
    @Environment(Game.self) private var game
    
    let geo: GeometryProxy
    
    var body: some View {
        VStack {
            if tappedCorrectAnswer {
                let isLastQuestion = (game.answeredQuestions.count == game.activeQuestions.count)
                Button {
                    animateViewsIn = false
                    revealHint = false
                    revealBook = false
                    tappedCorrectAnswer = false
                    wrongAnswersTapped = []
                    movePointsToScore = false
                    animatedScore = game.gameScore
                    
                    if isLastQuestion {
                        currentScreen = .finish
                    } else {
                        game.newQuestion()
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        animateViewsIn = true
                    }
                } label: {
                    Text(isLastQuestion ? "End Game" : "Next Level")
                        .minimumScaleFactor(0.5)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 10)
                        .frame(width: geo.size.width / 2.15, height: 80)
                        .background(.yellow.mix(with: .brown, by: 0.6))
                        .clipShape(.rect(cornerRadius: 25))
                        .foregroundStyle(.white)
                }
                .font(.largeTitle)
                .transition(.offset(y: geo.size.height / 3))
                .phaseAnimator([false, true]) { content, phase in
                    content
                        .scaleEffect(phase ? 1.2 : 1)
                } animation: { _ in
                        .easeInOut(duration: 1.3)
                }
            }
        }
        .animation(.easeInOut(duration: tappedCorrectAnswer ? 2.7 : 0).delay(tappedCorrectAnswer ? 2.7 : 0), value: tappedCorrectAnswer)
        .frame(width: geo.size.width)
    }
}

#Preview {
    GeometryReader { geo in
        ContinueButton(
            animateViewsIn: .constant(true),
            currentScreen: .constant(.game),
            tappedCorrectAnswer: .constant(true),
            revealHint: .constant(false),
            revealBook: .constant(false),
            wrongAnswersTapped: .constant([]),
            movePointsToScore: .constant(false),
            animatedScore: .constant(0),
            geo: geo)
        .environment(Game())
    }
}
