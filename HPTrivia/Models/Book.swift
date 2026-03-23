//
//  Book.swift
//  HPTrivia
//
//  Created by Ana Clara Moreira Rodrigues on 23/03/26.
//

struct Book: Identifiable {
    let id: Int
    let image: String
    let questions: [Question]
    var status: BookStatus
}

enum BookStatus {
    case active, inactive, locked
}
