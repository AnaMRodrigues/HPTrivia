//
//  Instructions.swift
//  HPTrivia
//
//  Created by Ana Clara Moreira Rodrigues on 26/02/26.
//

import SwiftUI

struct Instructions: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Image(.parchment)
                .resizable()
                .ignoresSafeArea()
                .background(.brown)
            
            VStack {
                Image(.appiconwithradius)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150)
                    .padding(.top)
                
                Text("How To Play")
                    .font(.largeTitle)
                    .padding()
                    .foregroundStyle(.black)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Welcome to HP Trivia! In this game you will be asked random questions from the HP books and you must guess the right answer or you will lose points!😱")
                        
                        Text("Each question is worth 5 points, but if you guess a wrong answer, you lose 1 point.")
                        
                        Text("If you are struggling with a question, there is an option to reveal a hint or reveal the book that answers the question. But beware! Using these also removes 1 point each.")
                        
                        Text("When you select the correct answer, you will be awarded all the points left for that question and they will be added to your total score.")
                    }
                    .font(.title3)
                    .padding(.horizontal)
                    
                    Text("Good Luck!")
                        .font(.title)
                }
                .foregroundStyle(.black)
                
                Button("Done"){
                    dismiss()
                }
                .font(.largeTitle)
                .padding()
                .buttonStyle(.borderedProminent)
                .tint(.brown.mix(with: .black, by: 0.2))
                .foregroundStyle(.white)
                .buttonBorderShape(.roundedRectangle)
            }
        }
    }
}

#Preview {
    Instructions()
}
