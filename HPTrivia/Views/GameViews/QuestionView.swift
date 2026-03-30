//
//  Question.swift
//  HPTrivia
//
//  Created by Ana Clara Moreira Rodrigues on 29/03/26.
//

import SwiftUI

struct QuestionView: View {
    @Binding var currentScreen: Screen
    @Binding var animateViewsIn: Bool
    
    @Environment(Game.self) private var game
    
    var body: some View {
        VStack {
            if animateViewsIn {
                Text(game.currentQuestion.question)
                    .font(.custom("PartyLetPlain", size: 50))
                    .minimumScaleFactor(0.5)
                    .multilineTextAlignment(.center)
                    .padding()
                    .transition(.scale)
            }
        }
        .animation(.easeInOut(duration: animateViewsIn ? 2 : 0), value: animateViewsIn)
        .padding(.bottom, 20)
        .onAppear {
            animateViewsIn = true
        }
    }
}

#Preview {
    QuestionView(currentScreen: .constant(.game), animateViewsIn: .constant(true))
        .environment(Game())
}
