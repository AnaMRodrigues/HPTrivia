//
//  ShowHintButton.swift
//  HPTrivia
//
//  Created by Ana Clara Moreira Rodrigues on 29/03/26.
//

import SwiftUI
import AVKit

struct ShowHintButton: View {
    @Binding var animateViewsIn: Bool
    @Binding var revealHint: Bool
    
    @Environment(Game.self) private var game
    
    @State private var sfxPlayer: AVAudioPlayer!
    
    let geo: GeometryProxy
    
    var body: some View {
        VStack {
            if animateViewsIn {
                let baseImage = Image(systemName: "questionmark.app.fill")
                    .resizable()
                    .scaledToFit()
                    .background(.black)
                    .clipShape(.rect(cornerRadius: 26))
                    .frame(width: 100)
                    .foregroundStyle(.blue)
                    .padding()
                
                let animatedImage = baseImage
                    .transition(.offset(x: -geo.size.width / 2))
                    .phaseAnimator([false, true]) { content, phase in
                        content
                            .rotationEffect(.degrees(phase ? -13 : -17))
                    } animation: { _ in
                            .easeInOut(duration: 0.7)
                    }
                let transformedImage = animatedImage
                    .rotation3DEffect(.degrees(revealHint ? 1440 : 0), axis: (x: 0, y: 1, z: 0))
                    .scaleEffect(revealHint ? 5 : 1)
                    .offset(x: revealHint ? geo.size.width / 3 : 0)
                    .opacity(revealHint ? 0 : 1)
                
                transformedImage
                    .onTapGesture {
                        withAnimation(.easeOut(duration: 1)) {
                            revealHint = true
                        }
                        playFlipSound()
                        game.questionScore -= 1
                    }
                    .overlay {
                        Text("\(game.currentQuestion.hint)")
                            .padding(.leading, 20)
                            .minimumScaleFactor(0.5)
                            .multilineTextAlignment(.center)
                            .opacity(revealHint ? 1 : 0)
                            .scaleEffect(revealHint ? 1.33 : 1)
                    }
            }
        }
        .frame(height: 250, alignment: revealHint ? .center : .bottom)
        .animation(.easeOut(duration: animateViewsIn ? 1.5 : 0).delay(animateViewsIn ? 2 : 0), value: animateViewsIn)
    }
    
    func playFlipSound() {
        let sound = Bundle.main.path(forResource: "page-flip", ofType: "mp3")
        sfxPlayer = try! AVAudioPlayer(contentsOf: URL(filePath: sound!))
        sfxPlayer.play()
    }
    
}

#Preview {
    GeometryReader { geo in
        ShowHintButton(animateViewsIn: .constant(true), revealHint: .constant(false), geo: geo)
            .environment(Game())
    }
}
