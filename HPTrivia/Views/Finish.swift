//
//  Finish.swift
//  HPTrivia
//
//  Created by Ana Clara Moreira Rodrigues on 29/03/26.
//

import SwiftUI

struct Finish: View {
    @Binding var currentScreen: Screen
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                AnimatedBackground(geo: geo)
                
                VStack {
                    Text("The End")
                    
                    
                    Button("Back to home screen") {
                        currentScreen = .home
                    }
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    Finish(currentScreen: .constant(.finish))
}
