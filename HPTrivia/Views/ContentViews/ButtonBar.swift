//
//  ButtonBar.swift
//  HPTrivia
//
//  Created by Ana Clara Moreira Rodrigues on 17/03/26.
//

import SwiftUI

struct ButtonBar: View {
    @Binding var animateViewsIn: Bool
    
    let geo: GeometryProxy
    
    var body: some View {
        HStack {
            Spacer()
            
            InstructionsButton(animateViewsIn: $animateViewsIn, geo: geo)
                
            Spacer()
                
            PlayButton(animateViewsIn: $animateViewsIn, geo: geo)
                
            Spacer()
            
            SettingsButton(animateViewsIn: $animateViewsIn, geo: geo)
                
            Spacer()
        }
        .animation(.easeOut(duration: 1).delay(0.75), value: animateViewsIn)
    }
}

#Preview {
    GeometryReader { geo in
        ButtonBar(animateViewsIn: .constant(true), geo: geo)
    }
}
