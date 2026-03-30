//
//  HintsView.swift
//  HPTrivia
//
//  Created by Ana Clara Moreira Rodrigues on 29/03/26.
//

import SwiftUI
import AVKit

struct HintsView: View {
    @Binding var animateViewsIn: Bool
    @Binding var revealHint: Bool
    @Binding var revealBook: Bool
    
    @Environment(Game.self) private var game
    
    @State private var sfxPlayer: AVAudioPlayer!
    
    let geo: GeometryProxy
    
    var body: some View {
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
                            game.questionScore -= 1
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
            .animation(.easeOut(duration: animateViewsIn ? 1.5 : 0).delay(animateViewsIn ? 2 : 0), value: animateViewsIn)
            
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
                            game.questionScore -= 1
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
            .animation(.easeOut(duration: animateViewsIn ? 1.5 : 0).delay(animateViewsIn ? 2 : 0), value: animateViewsIn)
        }
        .padding()
    }
    
    private func playFlipSound() {
        let sound = Bundle.main.path(forResource: "page-flip", ofType: "mp3")
        sfxPlayer = try! AVAudioPlayer(contentsOf: URL(filePath: sound!))
        sfxPlayer.play()
    }
}

#Preview {
    GeometryReader { geo in
        HintsView(animateViewsIn: .constant(true), revealHint: .constant(false), revealBook: .constant(false), geo: geo)
    }
}
