//
//  CorrectAnswer.swift
//  HPTrivia
//
//  Created by Ana Clara Moreira Rodrigues on 30/03/26.
//

import SwiftUI
import AVKit

struct CorrectAnswer: View {
    @Binding var animateViewsIn: Bool
    @Binding var tappedCorrectAnswer: Bool
    @Binding var animatedScore: Int
    
    @Environment(Game.self) private var game
    
    @State private var sfxPlayer: AVAudioPlayer!
    @State private var scoreTimer: Timer?
    
    let answer: String
    let geo: GeometryProxy
    let namespace: Namespace.ID
    
    var body: some View {
        VStack {
            if animateViewsIn {
                if !tappedCorrectAnswer {
                    Button {
                        withAnimation(.easeOut(duration: 1)) {
                            tappedCorrectAnswer = true
                        }
                        playCorrectSound()
                        game.answeredQuestions.append(game.currentQuestion.id)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                            game.correct()
                            animateScoreIncrement()
                        }
                    } label: {
                        Text(answer)
                            .minimumScaleFactor(0.5)
                            .multilineTextAlignment(.center)
                            .padding(10)
                            .frame(width: geo.size.width / 2.15, height: 80)
                            .background(tappedCorrectAnswer ? .green.opacity(0.5) : .yellow.opacity(0.5))
                            .clipShape(.rect(cornerRadius: 25))
                            .matchedGeometryEffect(id: 1, in: namespace)
                    }
                    .transition(.asymmetric(insertion: .offset(y: geo.size.height), removal: .scale(scale: 4).combined(with: .opacity)))
                }
            }
        }
        .transition(.offset(y: geo.size.height / 2))
    }
    
    private func playCorrectSound() {
        let sound = Bundle.main.path(forResource: "magic-wand", ofType: "mp3")
        sfxPlayer = try! AVAudioPlayer(contentsOf: URL(filePath: sound!))
        sfxPlayer.play()
    }
    
    private func animateScoreIncrement() {
        let target = game.gameScore
        
        if animatedScore >= target { return }
        
        // Invalidate any existing timer before starting a new one
        scoreTimer?.invalidate()
        
        scoreTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
            DispatchQueue.main.async {
                if self.animatedScore < target {
                    self.animatedScore += 1
                    playClick()
                } else {
                    self.scoreTimer?.invalidate()
                    self.scoreTimer = nil
                }
            }
        }
    }
    
    private func playClick(){
        let sound = Bundle.main.path(forResource: "click", ofType: "mp3")
        sfxPlayer = try! AVAudioPlayer(contentsOf: URL(filePath: sound!))
        sfxPlayer.play()
    }
    
}

#Preview {
    CorrectAnswerPreviewWrapper(answer: "Correct Answer")
}

struct CorrectAnswerPreviewWrapper: View {
    @Namespace var namespace
    let answer: String
    
    var body: some View {
        GeometryReader { geo in
            CorrectAnswer(animateViewsIn: .constant(true), tappedCorrectAnswer: .constant(false), animatedScore: .constant(0), answer: answer, geo: geo, namespace: namespace)
                .environment(Game())
        }
    }
}
