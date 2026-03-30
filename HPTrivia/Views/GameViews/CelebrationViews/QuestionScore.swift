//
//  QuestionScore.swift
//  HPTrivia
//
//  Created by Ana Clara Moreira Rodrigues on 29/03/26.
//

import SwiftUI

struct QuestionScore: View {
    @Binding var tappedCorrectAnswer: Bool
    @Binding var movePointsToScore: Bool
    
    @Environment(Game.self) private var game
    
    let geo: GeometryProxy
    
    var body: some View {
        VStack {
            if tappedCorrectAnswer {
                Text("\(game.questionScore)")
                    .font(.largeTitle)
                    .padding(.top, 50)
                    .transition(.offset(y: -geo.size.height / 4))
                    .offset(x: movePointsToScore ? geo.size.width / 2.3 : 0, y: movePointsToScore ? -geo.size.height / 13 : 0)
                    .opacity(movePointsToScore ? 0 : 1)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 1.5).delay(3)) {
                            movePointsToScore = true
                        }
                    }
            }
        }
        .animation(.easeInOut(duration: 1).delay(2), value: tappedCorrectAnswer)
    }
}

#Preview {
    GeometryReader { geo in
        QuestionScore(tappedCorrectAnswer: .constant(true), movePointsToScore: .constant(false), geo: geo)
            .environment(Game())
    }
}
