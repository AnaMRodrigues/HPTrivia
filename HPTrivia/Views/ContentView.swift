//
//  ContentView.swift
//  HPTrivia
//
//  Created by Ana Clara Moreira Rodrigues on 26/02/26.
//

import SwiftUI
import AVKit

struct ContentView: View {
    @State private var audioPlayer: AVAudioPlayer!
    @State private var animateViewsIn = false
    @State private var scalePlayButton = false
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image(.hogwarts)
                    .resizable()
                    .frame(width: geo.size.width * 3, height: geo.size.height)
                    .padding(.top, 2)
                    .phaseAnimator([false, true]) { content, phase in
                        content
                            .offset(x: phase ? geo.size.width/1.1 : -geo.size.width/1.1)
                    } animation: { _ in
                            .linear(duration: 60)//in seconds
                    }
                
                VStack {
                    VStack {
                        if animateViewsIn {
                            VStack {
                                Image(systemName: "bolt.fill")
                                    .imageScale(.large)
                                    .font(.largeTitle)
                                
                                Text("HP")
                                    .font(.custom("PartyLetPlain", size: 70))
                                    .padding(.bottom, -50)
                                
                                Text("Trivia")
                                    .font(.custom("PartyLetPlain", fixedSize: 60))
                            }
                            .padding(.top, 70)
                            .transition(.move(edge: .top))
                        }
                    }
                    .animation(.easeOut(duration: 1).delay(0.75), value: animateViewsIn)
                    
                    Spacer()
                    
                    Spacer()
                    
                    Spacer()
                    
                    VStack {
                        if animateViewsIn {
                            Button {
                                
                            } label: {
                                Text("Play")
                                    .font(.largeTitle)
                                    .foregroundStyle(.white)
                                    .padding(.vertical, 7)
                                    .padding(.horizontal, 50)
                                    .background(.yellow.mix(with: .brown, by: 0.5))
                                    .clipShape(.rect(cornerRadius: 7))
                                    .shadow(radius: 5)
                                    .scaleEffect(scalePlayButton ? 1.2 : 1)
                                    .onAppear() {
                                        withAnimation(.easeInOut(duration: 1.3).repeatForever()) {
                                            scalePlayButton.toggle()
                                        }
                                    }
                            }
                            .transition(.offset(y: geo.size.height/3))
                        }
                    }
                    .animation(.easeOut(duration: 1).delay(0.75), value: animateViewsIn)
                    
                    Spacer()
                }

            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .ignoresSafeArea()
        .onAppear {
            animateViewsIn = true
            playAudio()
        }
    }
    
    private func playAudio() {
        let sound = Bundle.main.path(forResource: "magic-in-the-air", ofType: "mp3")
        audioPlayer = try! AVAudioPlayer(contentsOf: URL(filePath: sound!))
        audioPlayer.numberOfLoops = -1 //equals infinity
        audioPlayer.play()
    }
}

#Preview {
    ContentView()
}
