//
//  HintsView.swift
//  HPTrivia
//
//  Created by Ana Clara Moreira Rodrigues on 29/03/26.
//

import SwiftUI

struct HintView: View {
    @Binding var animateViewsIn: Bool
    @Binding var revealHint: Bool
    @Binding var revealBook: Bool
    
    @Environment(Game.self) private var game
    
    let geo: GeometryProxy
    
    var body: some View {
        HStack {
            ShowHintButton(animateViewsIn: $animateViewsIn, revealHint: $revealHint, geo: geo)
            
            Spacer()
            
            ShowBookButton(animateViewsIn: $animateViewsIn, revealBook: $revealBook, geo: geo)
        }
        .padding()
    }
}

#Preview {
    GeometryReader { geo in
        HintView(animateViewsIn: .constant(true), revealHint: .constant(false), revealBook: .constant(false), geo: geo)
            .environment(Game())
    }
}
