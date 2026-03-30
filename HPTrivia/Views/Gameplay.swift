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
    @State private var sfxPlayer: AVAudioPlayer!
    @State private var scoreTimer: Timer?
    
    @State private var animateViewsIn = false
    @State private var revealHint = false
    @State private var revealBook = false
    @State private var tappedCorrectAnswer = false
    @State private var wrongAnswersTapped: [String] = []
    @State private var movePointsToScore = false
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
                        LazyVGrid (columns: [GridItem(), GridItem()]) {
                            ForEach(game.answers, id: \.self) { answer in
                                if answer == game.currentQuestion.answer {
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
                                                .transition(.offset(y: geo.size.height / 2))
                                            }
                                        }
                                    }
                                    .animation(.easeOut(duration: animateViewsIn ? 1.5 : 0).delay(animateViewsIn ? 2 : 0), value: animateViewsIn)
                                } else {
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
                                            .transition(.offset(y: geo.size.height / 2))
                                            .sensoryFeedback(.error, trigger: wrongAnswersTapped)
                                            .disabled(wrongAnswersTapped.contains(answer))
                                        }
                                    }
                                    .animation(.easeOut(duration: animateViewsIn ? 1.5 : 0).delay(animateViewsIn ? 2 : 0), value: animateViewsIn)
                                }
                            }
                        }
                        
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
                    movePointsToScore: $movePointsToScore,
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
    
    private func playWrongSound() {
        let sound = Bundle.main.path(forResource: "negative-beeps", ofType: "mp3")
        sfxPlayer = try! AVAudioPlayer(contentsOf: URL(filePath: sound!))
        sfxPlayer.play()
    }
    
    private func playCorrectSound() {
        let sound = Bundle.main.path(forResource: "magic-wand", ofType: "mp3")
        sfxPlayer = try! AVAudioPlayer(contentsOf: URL(filePath: sound!))
        sfxPlayer.play()
    }
    
    private func playClick(){
        let sound = Bundle.main.path(forResource: "click", ofType: "mp3")
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
    
}

#Preview {
    Gameplay(currentScreen: .constant(.game))
        .environment(Game())
}
