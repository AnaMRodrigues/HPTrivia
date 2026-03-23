//
//  HPTriviaApp.swift
//  HPTrivia
//
//  Created by Ana Clara Moreira Rodrigues on 26/02/26.
//

import SwiftUI

@main
struct HPTriviaApp: App {
    private var game = Game()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(game)//to access this from any view of the app
        }
    }
}

//control + i - Indent the code

/*      Command + Control + Space For emojis
 App Development Plan:
 🟦 Game Intro Screen
 - Gameplay Screen
 🟨 Game Logic (Questions, Score, etc.)
 - Celebration
 🟨 Audio
 🟨 Animations
 - In-app purchases
 - Store
 ✅ Instruction Screen
 🟦 Books
 - Persist Scores
 
 ✅ = Done
 🟨 = Started
 🟦 = Almost finished
 🇧🇷
 */
