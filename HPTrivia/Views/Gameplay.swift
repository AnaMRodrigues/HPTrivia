//
//  Gameplay.swift
//  HPTrivia
//
//  Created by Ana Clara Moreira Rodrigues on 23/03/26.
//

import SwiftUI
import AVKit

struct Gameplay: View {
    @Binding var currentScreen: Screen
    @Environment(Game.self) private var game
    @Namespace private var namespace
    
    @State private var musicPlayer: AVAudioPlayer!
    
    @State private var animateViewsIn = false
    @State private var revealHint = false
    @State private var revealBook = false
    @State private var tappedCorrectAnswer = false
    @State private var wrongAnswersTapped: [String] = []
    @State private var animatedScore: Int = 0
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image(.sky)
                    .resizable()
                
                Image(.hogwarts)
                    .resizable()
                    .frame(width: geo.size.width * 3, height: geo.size.height * 1.05)
                    .overlay {
                        Rectangle()
                            .foregroundStyle(.black.opacity(0.8))
                    }
                
                VStack {
                    //Flags for organization of larger projects
                    // MARK: Controls
                    ControlBar(animatedScore: $animatedScore, currentScreen: $currentScreen)
                    
                    VStack {
                        
                        // MARK: Question
                        QuestionView(currentScreen: $currentScreen, animateViewsIn: $animateViewsIn)
                        
                        // MARK: Hints
                        HintView(animateViewsIn: $animateViewsIn, revealHint: $revealHint, revealBook: $revealBook, geo: geo)
                        
                        // MARK: Answers
                        Answers(animateViewsIn: $animateViewsIn, tappedCorrectAnswer: $tappedCorrectAnswer, wrongAnswersTapped: $wrongAnswersTapped, animatedScore: $animatedScore, geo: geo, namespace: namespace)
                        
                        Spacer()
                    }
                    .disabled(tappedCorrectAnswer)
                    .opacity(tappedCorrectAnswer ? 0.1 : 1)
                    .opacity(animateViewsIn ? 1 : 0)
                }
                .frame(width: geo.size.width, height: geo.size.height)
                
                // MARK: Celebration
                Celebration(
                    animateViewsIn: $animateViewsIn,
                    currentScreen: $currentScreen,
                    revealHint: $revealHint,
                    revealBook: $revealBook,
                    tappedCorrectAnswer: $tappedCorrectAnswer,
                    wrongAnswersTapped: $wrongAnswersTapped,
                    animatedScore: $animatedScore,
                    geo: geo,
                    namespace: namespace)
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .foregroundStyle(.white)
        }
        .ignoresSafeArea()
        .onAppear {
            game.startGame()
            animatedScore = game.gameScore
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                animateViewsIn = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                playMusic()
            }
        }
    }
    
    private func playMusic() {
        let songs = ["let-the-mistery-unfold", "spellcraft", "hiding-place-in-the-forest", "deep-in-the-dell"]
        let song = songs.randomElement()!
        
        let sound = Bundle.main.path(forResource: song, ofType: "mp3")
        musicPlayer = try! AVAudioPlayer(contentsOf: URL(filePath: sound!))
        musicPlayer.numberOfLoops = -1 //equals infinity
        musicPlayer.volume = 0.1 // 10%
        //musicPlayer.play()
    }
    
}

#Preview {
    Gameplay(currentScreen: .constant(.game))
        .environment(Game())
}
