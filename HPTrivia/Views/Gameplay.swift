//
//  Gameplay.swift
//  HPTrivia
//
//  Created by Ana Clara Moreira Rodrigues on 23/03/26.
//

import SwiftUI
import AVKit

struct Gameplay: View {
    @Environment(Game.self) private var game
    @Environment(\.dismiss) private var dismiss
    @Namespace private var namespace
    
    @State private var musicPlayer: AVAudioPlayer!
    @State private var sfxPlayer: AVAudioPlayer!
    
    @State private var animateViewsIn = false
    @State private var revealHint = false
    @State private var revealBook = false
    @State private var tappedCorrectAnswer = false
    @State private var wrongAnswersTapped: [String] = []
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
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
                    HStack {
                        Button("End Game"){
                            game.endGame()
                            dismiss()
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.red.opacity(0.5))
                        
                        Spacer()
                        
                        Text("Score: \(game.gameScore)")
                    }
                    .padding(30)
                    .padding(.top, 30)
                    
                    // MARK: Question
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
                    .animation(.easeInOut(duration: 2), value: animateViewsIn)
                    .padding(.bottom, 20)
                    
//                    Spacer()
                    
                    // MARK: Hints
                    HStack {
                        VStack {
                            if animateViewsIn {
                                Image(systemName: "questionmark.app.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100)
                                    .foregroundStyle(.blue)
                                    .padding()
                                    .transition(.offset(x: -geo.size.width / 2))
                                    .phaseAnimator([false, true]) { content, phase in
                                        content
                                            .rotationEffect(.degrees(phase ? -13 : -17))
                                    } animation: { _ in
                                            .easeInOut(duration: 0.7)
                                    }
                                    .onTapGesture {
                                        withAnimation(.easeOut(duration: 1)) {
                                            revealHint = true
                                        }
                                        playFlipSound()
                                        game.gameScore -= 1
                                    }
                                    .rotation3DEffect(.degrees(revealHint ? 1440 : 0), axis: (x: 0, y: 1, z: 0))
                                    .scaleEffect(revealHint ? 5 : 1)
                                    .offset(x: revealHint ? geo.size.width / 3 : 0)
                                    .opacity(revealHint ? 0 : 1)
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
                        .animation(.easeOut(duration: 1.5).delay(2), value: animateViewsIn)
                        
                        Spacer()
                        
                        VStack {
                            if animateViewsIn {
                                Image(systemName: "app.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: revealBook ? 150 : 100)
                                    .foregroundStyle(.blue)
                                    .overlay {
                                        Image(systemName: "book.closed")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 48)
                                            .foregroundStyle(.black)
                                    }
                                    .padding()
                                    .transition(.offset(x: geo.size.width / 2))
                                    .phaseAnimator([false, true]) { content, phase in
                                        content
                                            .rotationEffect(.degrees(phase ? 13 : 17))
                                    } animation: { _ in
                                            .easeInOut(duration: 0.7)
                                    }
                                    .onTapGesture {
                                        withAnimation(.easeOut(duration: 1)) {
                                            revealBook = true
                                        }
                                        playFlipSound()
                                        game.gameScore -= 1
                                    }
                                    .rotation3DEffect(.degrees(revealBook ? -1440 : 0), axis: (x: 0, y: 1, z: 0))
                                    .scaleEffect(revealBook ? 5 : 1)
                                    .offset(x: revealBook ? -geo.size.width / 3 : 0)
                                    .opacity(revealBook ? 0 : 1)
                                    .overlay {
                                        VStack {
                                            Image("hp\(game.currentQuestion.book)")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(maxHeight: 200)
                                            Text("Book \(game.currentQuestion.book)")
                                                .minimumScaleFactor(0.5)
                                                .multilineTextAlignment(.center)
                                        }
                                        .opacity(revealBook ? 1 : 0)
                                        .scaleEffect(revealBook ? 1.33 : 1)
                                    }
                            }
                        }
                        .frame(height: 250, alignment: revealBook ? .center : .bottom)
                        .animation(.easeOut(duration: 1.5).delay(2), value: animateViewsIn)
                    }
                    .padding()
                    
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
                                                game.correct()
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
                                            .transition(.asymmetric(insertion: .offset(y: geo.size.height / 2), removal: .scale(scale: 3).combined(with: .opacity)))
                                        }
                                    }
                                }
                                .animation(.easeOut(duration: 1.5).delay(2), value: animateViewsIn)
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
                                .animation(.easeOut(duration: 1.5).delay(2), value: animateViewsIn)
                            }
                        }
                    }
                    
                    Spacer()
                }
                .frame(width: geo.size.width, height: geo.size.height)
                
                // MARK: Celebration
                VStack {
                    if tappedCorrectAnswer {
                        Text(game.currentQuestion.answer)
                            .minimumScaleFactor(0.5)
                            .multilineTextAlignment(.center)
                            .padding(10)
                            .frame(width: geo.size.width / 2.15, height: 80)
                            .background(tappedCorrectAnswer ? .green.opacity(0.5) : .yellow.opacity(0.5))
                            .clipShape(.rect(cornerRadius: 25))
                            .scaleEffect(2)
                            .matchedGeometryEffect(id: 1, in: namespace)
                    }
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .foregroundStyle(.white)
        }
        .ignoresSafeArea()
        .onAppear {
            game.startGame()
            
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
    
    private func playFlipSound() {
        let sound = Bundle.main.path(forResource: "page-flip", ofType: "mp3")
        sfxPlayer = try! AVAudioPlayer(contentsOf: URL(filePath: sound!))
        sfxPlayer.play()
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
    
}

#Preview {
    Gameplay()
        .environment(Game())
}
