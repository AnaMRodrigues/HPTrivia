//
//  Celebration.swift
//  HPTrivia
//
//  Created by Ana Clara Moreira Rodrigues on 29/03/26.
//

import SwiftUI

struct Celebration: View {
    @Binding var animateViewsIn: Bool
    @Binding var currentScreen: Screen
    @Binding var revealHint: Bool
    @Binding var revealBook: Bool
    @Binding var tappedCorrectAnswer: Bool
    @Binding var wrongAnswersTapped: [String]
    @Binding var movePointsToScore: Bool
    @Binding var animatedScore: Int
    
    @Environment(Game.self) private var game
    
    let geo: GeometryProxy
    var namespace: Namespace.ID
    
    var body: some View {
        VStack {
            Spacer()
            
            QuestionScore(tappedCorrectAnswer: $tappedCorrectAnswer, movePointsToScore: $movePointsToScore, geo: geo)
            
            Spacer()
            
            CelebrationTitle(tappedCorrectAnswer: $tappedCorrectAnswer, geo: geo)
            
            Spacer()
            
            CorrectAnswerSelected(tappedCorrectAnswer: $tappedCorrectAnswer, geo: geo, namespace: namespace)
            
            Spacer()
            Spacer()
            
            ContinueButton(
                animateViewsIn: $animateViewsIn,
                currentScreen: $currentScreen,
                tappedCorrectAnswer: $tappedCorrectAnswer,
                revealHint: $revealHint,
                revealBook: $revealBook,
                wrongAnswersTapped: $wrongAnswersTapped,
                movePointsToScore: $movePointsToScore,
                animatedScore: $animatedScore,
                geo: geo)
            
            Spacer()
            Spacer()
        }
        .frame(width: geo.size.width, height: geo.size.height)
        .foregroundStyle(.white)
    }
}

#Preview {
    CelebrationPreviewWrapper()
}

struct CelebrationPreviewWrapper: View {
    @Namespace var namespace
    
    var body: some View {
        GeometryReader { geo in
            Celebration(
                animateViewsIn: .constant(true),
                currentScreen: .constant(.game),
                revealHint: .constant(false),
                revealBook: .constant(false),
                tappedCorrectAnswer: .constant(true),
                wrongAnswersTapped: .constant([]),
                movePointsToScore: .constant(false),
                animatedScore: .constant(0),
                geo: geo,
                namespace: namespace
            )
            .environment(Game())
        }
    }
}
