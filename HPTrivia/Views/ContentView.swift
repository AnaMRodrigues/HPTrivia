//
//  ContentView.swift
//  HPTrivia
//
//  Created by Ana Clara Moreira Rodrigues on 26/02/26.
//

import SwiftUI
import AVKit

enum Screen {
    case home
    case game
    case finish
}

struct ContentView: View {
    @State private var audioPlayer: AVAudioPlayer!
    @State private var animateViewsIn = false
    @State private var finishGame = false
    @State private var currentScreen: Screen = .home
    
    var body: some View {
        ZStack {
            switch currentScreen {
            case .home:
                GeometryReader { geo in
                    ZStack {
                        AnimatedBackground(geo: geo)
                        
                        VStack {
                            Spacer()
                            
                            GameTitle(animateViewsIn: $animateViewsIn)
                            
                            Spacer()
                            
                            RecentScores(animateViewsIn: $animateViewsIn)
                            
                            Spacer()
                            
                            ButtonBar(animateViewsIn: $animateViewsIn, currentScreen: $currentScreen, geo: geo)
                            
                            Spacer()
                        }
                        .frame(width: geo.size.width)
                        
                    }
                    .frame(width: geo.size.width, height: geo.size.height)
                }
                .ignoresSafeArea()
                .onAppear {
                    animateViewsIn = true
                    playAudio()
                }
                .transition(.move(edge: .trailing))
                
            case .game:
                Gameplay(currentScreen: $currentScreen)
                    .transition(.move(edge: .trailing))
            case .finish:
                Finish(currentScreen: $currentScreen)
                    .transition(.move(edge: .trailing))
            }
        }
        .animation(.easeInOut(duration: 0.5), value: currentScreen)
    }
    
    private func playAudio() {
        let sound = Bundle.main.path(forResource: "magic-in-the-air", ofType: "mp3")
        audioPlayer = try! AVAudioPlayer(contentsOf: URL(filePath: sound!))
        audioPlayer.numberOfLoops = -1 //equals infinity
        //audioPlayer.play()
    }
}

#Preview {
    ContentView()
        .environment(Game())
}
