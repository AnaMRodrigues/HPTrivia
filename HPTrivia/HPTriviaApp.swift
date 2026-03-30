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
 ✅ Game Intro Screen
 ✅ Gameplay Screen
 ✅ Game Logic (Questions, Score, etc.)
 ✅ Celebration
 ✅ Audio
 ✅ Animations
 ✅ In-app purchases
 ✅ Store
 ✅ Instruction Screen
 ✅ Books
 ✅ Persist Scores
 
 To try later
 ✅ Animation on the score that increases the value 1 by 1
    ✅ "Tick" sfx for the animation of increasing the score
 🟦 End of questions screen / The end
 - Alerts for cancelling the purchase
 ✅ Sky background for all screens
 
 Challenges
 - 1. Search and change the wrong sound to Voldemort's evil laugh (or any evil laugh)
 - 2. The player have to add their name before they start a new game and shows the name at the recent scores
 - 3. Make the recent scores section tappable and it goes to a full stats screen that shows all the games played
    - In this screen, do a sort filter for recent, highest score
 🟨 4. Refactor the gameplay screen
    ✅ Refactor the HintsView
    ✅ Refactor the Celebration Screen
 
 ✅ = Done
 🟨 = Started
 🟦 = Almost finished
 🇧🇷
 */
