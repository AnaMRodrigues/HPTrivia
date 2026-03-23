//
//  InactiveBook.swift
//  HPTrivia
//
//  Created by Ana Clara Moreira Rodrigues on 23/03/26.
//

import SwiftUI

struct InactiveBook: View {
    @State var book: Book
    
    var body: some View {
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
    }
}

#Preview {
    InactiveBook(book: BookQuestions().books[0])
}
