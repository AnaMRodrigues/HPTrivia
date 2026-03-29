//
//  ControlViews.swift
//  HPTrivia
//
//  Created by Ana Clara Moreira Rodrigues on 29/03/26.
//

import SwiftUI

struct ControlBar: View {
    @Binding var animatedScore: Int
    @Binding var currentScreen: Screen
    
    var body: some View {
        HStack {
            Button("End Game"){
                currentScreen = .finish
            }
            .buttonStyle(.borderedProminent)
            .tint(.red.opacity(0.5))
            
            Spacer()
            
            Text("Score: \(animatedScore)")
        }
        .padding(30)
        .padding(.top, 30)
    }
}

#Preview {
    ControlBar(animatedScore: .constant(0), currentScreen: .constant(.game))
}
