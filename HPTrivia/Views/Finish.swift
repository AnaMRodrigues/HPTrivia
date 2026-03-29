//
//  Finish.swift
//  HPTrivia
//
//  Created by Ana Clara Moreira Rodrigues on 29/03/26.
//

import SwiftUI

struct Finish: View {
    @Binding var currentScreen: Screen
    @Environment(Game.self) private var game
    
    @State private var scalePlayButton = false
    @State private var animateViewsIn = false
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                AnimatedBackground(geo: geo)
                
                VStack {
                    Spacer()
                    
                    VStack {
                        if animateViewsIn {
                            Text("The End")
                                .font(.custom("PartyLetPlain", size: 70))
                                .transition(.asymmetric(
                                    insertion: .move(edge: .top).combined(with: .opacity),
                                    removal: .opacity
                                ))
                        }
                    }
                    .animation(.easeOut(duration: 1).delay(0.75), value: animateViewsIn)
                    
                    Spacer()
                    
                    ZStack(alignment: .leading) {
                        HStack {
                            Text("Final Score:")
                                .offset(y: animateViewsIn ? 0 : 13)
                            
                            Text("10 points")
                                .hidden()
                        }
                        
                        HStack {
                            Spacer()
                                .frame(width: 120)
                            
                            if animateViewsIn {
                                Text("\(game.gameScore) points")
                                    .transition(.opacity)
                            }
                        }
                    }
                    .font(.title2)
                    .padding(50)
                    .animation(.linear(duration: 1).delay(2), value: animateViewsIn)
                    .background(.black.opacity(0.4))
                    .clipShape(.rect(cornerRadius: 15))
                    
                    Spacer()
                    
                    HStack {
                        if animateViewsIn {
                            Button {
                                game.endGame()
                                game.answeredQuestions = []
                                currentScreen = .home
                            } label: {
                                Text("Home")
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
                    .animation(.easeOut(duration: 2).delay(1), value: animateViewsIn)
                    
                    Spacer()
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .foregroundStyle(.white)
            .onAppear {
                animateViewsIn = true
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    Finish(currentScreen: .constant(.finish))
        .environment(Game())
}
