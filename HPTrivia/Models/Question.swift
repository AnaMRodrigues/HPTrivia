//
//  Question.swift
//  HPTrivia
//
//  Created by Ana Clara Moreira Rodrigues on 26/02/26.
//

struct Question: Decodable {
    let id: Int
    let question: String
    let answer: String
    let wrong: [String]
    let book: Int
    let hint: String
}
