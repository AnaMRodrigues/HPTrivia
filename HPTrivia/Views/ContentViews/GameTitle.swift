//
//  GameTitle.swift
//  HPTrivia
//
//  Created by Ana Clara Moreira Rodrigues on 13/03/26.
//

import SwiftUI

struct GameTitle: View {
    @Binding var animateViewsIn: Bool
    
    var body: some View {
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
                .transition(.move(edge: .top))
            }
        }
        .animation(.easeOut(duration: 1).delay(0.75), value: animateViewsIn)
    }
}

#Preview {
    GameTitle(animateViewsIn: .constant(true))
}
