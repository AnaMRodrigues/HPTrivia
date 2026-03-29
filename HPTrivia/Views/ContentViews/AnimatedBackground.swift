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
        Image(.sky)
            .resizable()
            .frame(width: geo.size.width * 4, height: geo.size.height)
            .phaseAnimator([false, true]) { content, phase in
                content
                    .offset(x: phase ? -geo.size.width : geo.size.width)
            } animation: { _ in
                    .linear(duration: 60)
            }
        
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
            .overlay {
                Color.black.opacity(0.3)
                    .blendMode(.darken)
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
