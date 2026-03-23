//
//  PlayButton.swift
//  HPTrivia
//
//  Created by Ana Clara Moreira Rodrigues on 17/03/26.
//

import SwiftUI

struct PlayButton: View {
    @Binding var animateViewsIn: Bool
    @Binding var playGame: Bool
    
    @State private var scalePlayButton = false
    
    let geo: GeometryProxy
    
    var body: some View {
        VStack {
            if animateViewsIn {
                Button {
                    playGame.toggle()
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
    }
}

#Preview {
    GeometryReader { geo in
        PlayButton(animateViewsIn: .constant(true), playGame: .constant(false), geo: geo)
    }
}
