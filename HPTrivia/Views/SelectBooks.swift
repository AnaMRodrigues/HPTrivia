//
//  SelectBooks.swift
//  HPTrivia
//
//  Created by Ana Clara Moreira Rodrigues on 23/03/26.
//

import SwiftUI

struct SelectBooks: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(Game.self) private var game
    
    @State private var showTempAlert = false
    
    var body: some View {
        ZStack {
            Image(.parchment)
                .resizable()
                .ignoresSafeArea()
                .background(.brown)
            
            VStack {
                Text("Which books would you like to see questions from?")
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .padding()
                
                ScrollView {
                    LazyVGrid(columns: [GridItem(), GridItem()]) {
                        ForEach(game.bookQuestions.books) { book in
                            if book.status == .active {
                                ZStack(alignment: .bottomTrailing) {
                                    Image(book.image)
                                        .resizable()
                                        .scaledToFit()
                                        .shadow(radius: 7)
                                    
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.largeTitle)
                                        .foregroundStyle(.green)
                                        .shadow(radius: 1)
                                        .padding(3)
                                }
                                .onTapGesture {
                                    game.bookQuestions.changeStatus(of: book.id, to: .inactive)
                                }
                            } else if book.status == .inactive {
                                ZStack(alignment: .bottomTrailing) {
                                    Image(book.image)
                                        .resizable()
                                        .scaledToFit()
                                        .shadow(radius: 7)
                                        .grayscale(1)
                                    
                                    Image(systemName: "circle")
                                        .font(.largeTitle)
                                        .foregroundStyle(.white.mix(with: .gray, by: 0.4))
                                        .shadow(radius: 1)
                                        .padding(3)
                                }
                                .onTapGesture {
                                    game.bookQuestions.changeStatus(of: book.id, to: .active)
                                }
                            } else {
                                ZStack {
                                    Image(book.image)
                                        .resizable()
                                        .scaledToFit()
                                        .shadow(radius: 7)
                                        .grayscale(1)
                                        .overlay {
                                            Rectangle().opacity(0.75)
                                        }
                                    
                                    Image(systemName: "lock.fill")
                                        .font(.largeTitle)
                                        .imageScale(.large)
                                        .foregroundStyle(.white.mix(with: .gray, by: 0.4))
                                        .shadow(radius: 1)
                                        .padding(3)
                                }
                                .onTapGesture {
                                    showTempAlert.toggle()
                                    
                                    game.bookQuestions.changeStatus(of: book.id, to: .active)
                                }
                            }
                        }
                    }
                    .padding()
                }
                
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
            .foregroundStyle(.black)
        }
        .alert("You successfully purchased a new question pack. Enjoy!", isPresented: $showTempAlert) {
            //No action needed
        }
    }
}

#Preview {
    SelectBooks()
        .environment(Game())
}
