//
//  AnimatedBackground.swift
//  HPTrivia
//
//  Created by Ana Clara Moreira Rodrigues on 09/03/26.
//

import SwiftUI

struct AnimatedBackground: View {
    let geo: GeometryProxy
    
    var body: some View {
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
    }
}

#Preview {
    GeometryReader { geo in
        AnimatedBackground(geo: geo)
            .frame(width: geo.size.width, height: geo.size.height)
    }
    .ignoresSafeArea()
}
