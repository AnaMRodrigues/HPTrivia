//
//  LockedBook.swift
//  HPTrivia
//
//  Created by Ana Clara Moreira Rodrigues on 23/03/26.
//

import SwiftUI

struct LockedBook: View {
    @State var book: Book
    
    var body: some View {
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
                .shadow(color: .white, radius: 20)
                .padding(3)
        }
    }
}

#Preview {
    LockedBook(book: BookQuestions().books[0])
}
