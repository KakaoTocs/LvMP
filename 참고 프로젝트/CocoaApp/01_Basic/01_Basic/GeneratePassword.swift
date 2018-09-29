//
//  GeneratePassword.swift
//  01_Basic
//
//  Created by Jinu Kim on 29/09/2018.
//  Copyright © 2018 Jinu Kim. All rights reserved.
//

import Foundation

private let characters: [Character] = Array("0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ".characters)

func generateRandomString(length: Int) -> String {
    var string = ""
    for _ in 0..<length {
        string.append(generateRandomCharacter())
    }
    return string
}

func generateRandomCharacter() -> Character {
    let index = Int(arc4random_uniform(uint32(characters.count)))
    let character = characters[index]
    return character
}
