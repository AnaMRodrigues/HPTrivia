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
                                                .transition(.asymmetric(insertion: .offset(y: geo.size.height / 2), removal: .scale(scale: 4).combined(with: .opacity)))
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
                VStack {
                    Spacer()
                    
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
                    
                    Spacer()
                    
                    VStack {
                        if tappedCorrectAnswer {
                            Text("Brilliant")
                                .font(.custom("PartyLetPlain", size: 100))
                                .transition(.scale.combined(with: .offset(y: -geo.size.height / 2)))
                        }
                    }
                    .animation(.easeInOut(duration: tappedCorrectAnswer ? 1 : 0).delay(tappedCorrectAnswer ? 1 : 0), value: tappedCorrectAnswer)
                    
                    Spacer()
                    
                    if tappedCorrectAnswer {
                        Text(game.currentQuestion.answer)
                            .minimumScaleFactor(0.5)
                            .multilineTextAlignment(.center)
                            .padding(10)
                            .frame(width: geo.size.width / 2.15, height: 80)
                            .background(tappedCorrectAnswer ? .green.opacity(0.7) : .yellow.opacity(0.5))
                            .clipShape(.rect(cornerRadius: 25))
                            .scaleEffect(2)
                            .matchedGeometryEffect(id: 1, in: namespace)
                    }
                    
                    Spacer()
                    Spacer()
                    
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
                    
                    Spacer()
                    Spacer()
                }
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
