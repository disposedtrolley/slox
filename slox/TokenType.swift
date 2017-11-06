//
//  TokenType.swift
//  slox
//
//  Created by James Liu on 6/11/17.
//  Copyright © 2017 James Liu. All rights reserved.
//

import Foundation

enum TokenType {
    // Single-character token.
    case LEFT_PAREN, RIGHT_PAREN, LEFT_BRACE, RIGHT_BRACE
    case COMMA, DOT, MINUS, PLUS, SEMICOLON, SLASH, STAR
    
    // One or two character tokens.
    case BANG, BANG_EQUAL
    case EQUAL, EQUAL_EQUAL
    case GREATER, GREATER_EQUAL
    case LESS, LESS_EQUAL
    
    // Literals.
    case IDENTIFIER, STRING, NUMBER
    
    // Keywords.
    case AND, CLASS, ELSE, FALSE, FUN, FOR, IF, NIL, OR
    case PRINT, RETURN, SUPER, THIS, TRUE, VAR, WHILE
    
    case EOF
}
