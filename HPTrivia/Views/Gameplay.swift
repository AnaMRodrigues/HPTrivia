//
//  Gameplay.swift
//  HPTrivia
//
//  Created by Ana Clara Moreira Rodrigues on 23/03/26.
//

import SwiftUI

struct Gameplay: View {
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image(.hogwarts)
                    .resizable()
                    .frame(width: geo.size.width * 3, height: geo.size.height * 1.05)
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .overlay {
                Rectangle()
                    .foregroundStyle(.black.opacity(0.8))
            }
            
            VStack {
                //Flags for organization of larger projects
                // MARK: Controls
                
                // MARK: Question
                
                // MARK: Hints
                
                // MARK: Answers
            }
            .frame(width: geo.size.width, height: geo.size.height)
            
            // MARK: Celebration
        }
        .ignoresSafeArea()
    }
}

#Preview {
    Gameplay()
}
