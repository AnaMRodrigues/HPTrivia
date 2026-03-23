//
//  SettingsButton.swift
//  HPTrivia
//
//  Created by Ana Clara Moreira Rodrigues on 17/03/26.
//

import SwiftUI

struct SettingsButton: View {
    @Binding var animateViewsIn: Bool
    @State private var showSettings = false
    
    let geo: GeometryProxy
    
    var body: some View {
        VStack {
            if animateViewsIn {
                Button {
                    showSettings.toggle()
                } label: {
                    Image(systemName: "gearshape.fill")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                        .shadow(radius: 5)
                }
                .transition(.offset(x: geo.size.width/2))
            }
        }
        .animation(.easeOut(duration: 0.7).delay(1.5), value: animateViewsIn)
        .sheet(isPresented: $showSettings) {
            SelectBooks()
        }
    }
}

#Preview {
    GeometryReader { geo in
        SettingsButton(animateViewsIn: .constant(true), geo: geo)
            .environment(Game())
    }
}
