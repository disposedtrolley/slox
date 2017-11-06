//
//  Token.swift
//  slox
//
//  Created by James Liu on 6/11/17.
//  Copyright © 2017 James Liu. All rights reserved.
//

import Foundation

struct Token : CustomStringConvertible {
    let type: TokenType
    let lexeme: String
    let literal: Any
    let line: Int
    
    var description: String {
        return "\(type) \(lexeme) \(literal)"
    }
}
