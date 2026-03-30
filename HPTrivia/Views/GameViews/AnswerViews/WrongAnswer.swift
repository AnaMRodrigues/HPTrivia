//
//  WrongAnswer.swift
//  HPTrivia
//
//  Created by Ana Clara Moreira Rodrigues on 30/03/26.
//

import SwiftUI
import AVKit

struct WrongAnswer: View {
    @Binding var animateViewsIn: Bool
    @Binding var wrongAnswersTapped: [String]
    
    @Environment(Game.self) private var game
    
    @State private var sfxPlayer: AVAudioPlayer!
    
    let answer: String
    let geo: GeometryProxy
    
    var body: some View {
        VStack {
            if animateViewsIn {
                Button {
                    withAnimation(.easeOut(duration: 0.75)) {
                        wrongAnswersTapped.append(answer)
                    }
                    playWrongSound()
                    game.questionScore -= 1
                } label: {
                    Text(answer)
                        .minimumScaleFactor(0.5)
                        .multilineTextAlignment(.center)
                        .padding(10)
                        .frame(width: geo.size.width / 2.15, height: 80)
                        .background(wrongAnswersTapped.contains(answer) ? .red.mix(with: .black, by: 0.4).opacity(0.5) : .yellow.opacity(0.5))
                        .clipShape(.rect(cornerRadius: 25))
                        .scaleEffect(wrongAnswersTapped.contains(answer) ? 0.8 : 1)
                }
                .sensoryFeedback(.error, trigger: wrongAnswersTapped)
                .disabled(wrongAnswersTapped.contains(answer))
            }
        }
        .transition(.offset(y: geo.size.height / 2))
    }
    
    private func playWrongSound() {
        let sound = Bundle.main.path(forResource: "negative-beeps", ofType: "mp3")
        sfxPlayer = try! AVAudioPlayer(contentsOf: URL(filePath: sound!))
        sfxPlayer.play()
    }
}

#Preview {
    GeometryReader { geo in
        WrongAnswer(animateViewsIn: .constant(true), wrongAnswersTapped: .constant([]), answer: "Wrong Answer", geo: geo)
            .environment(Game())
    }
}
