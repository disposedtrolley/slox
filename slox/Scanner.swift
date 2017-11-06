//
//  Scanner.swift
//  slox
//
//  Created by James Liu on 6/11/17.
//  Copyright © 2017 James Liu. All rights reserved.
//

import Foundation

public class Scanner {
    let source: String
    var tokens: Array<Token>
    var start = 0
    var current = 0
    var line = 1
    
    let keywords: Dictionary<String, TokenType> = [
        "and":      .AND,
        "class":    .CLASS,
        "else":     .ELSE,
        "false":    .FALSE,
        "for":      .FOR,
        "fun":      .FUN,
        "if":       .IF,
        "nil":      .NIL,
        "or":       .OR,
        "print":    .PRINT,
        "return":   .RETURN,
        "super":    .SUPER,
        "this":     .THIS,
        "true":     .TRUE,
        "var":      .VAR,
        "while":    .WHILE
    ]
    
    init(source: String) {
        self.source = source
        self.tokens = []
    }
    
    /**
     Scans the entire source file for tokens, and appends an EOF token if the end of the file has been reached.
    */
    func scanTokens() -> Array<Token> {
        while !isAtEnd() {
            // We are at the beginning of the next lexeme.
            start = current
            scanToken()
        }
        
        // When the end of the file is reached, append an EOF token.
        tokens.append(Token(type: .EOF, lexeme: "", literal: [], line: line))
        return tokens
    }
    
    /**
     Scans a character and creates the appropriate token.
    */
    private func scanToken() {
        let c: Character = advance()
        switch c {
        case "(": addToken(.LEFT_PAREN)
        case ")": addToken(.RIGHT_PAREN)
        case "{": addToken(.LEFT_BRACE)
        case "}": addToken(.RIGHT_BRACE)
        case ",": addToken(.COMMA)
        case ".": addToken(.DOT)
        case "-": addToken(.MINUS)
        case "+": addToken(.PLUS)
        case ";": addToken(.SEMICOLON)
        case "*": addToken(.STAR)
        case "!": addToken(match("=") ? .BANG_EQUAL : .BANG)
        case "=": addToken(match("=") ? .EQUAL_EQUAL : .EQUAL)
        case "<": addToken(match("=") ? .LESS_EQUAL : .LESS)
        case ">": addToken(match("=") ? .GREATER_EQUAL : .GREATER)
        case "/":
            if match("/") {
                while peek() != "\n" && !isAtEnd() { _ = advance() }
            } else {
                addToken(TokenType.SLASH)
            }
        case " ", "\r", "\t": break
        case "\n": line += 1
        case "\"": string()
        default:
            if isDigit(c) {
                number()
            } else if isAlpha(c) {
                identifier()
            } else {
                Slox.error(line: line, message: "Unexpected character")
            }
        }
    }
    
    /**
     Processes a token to determine whether it is an identifier or reserved keyword.
    */
    private func identifier() {
        while isAlphaNumeric(peek()) { _ = advance() }
        
        // See if the identifier is a reserved word.
        let start = source.index(source.startIndex, offsetBy: self.start)
        let current = source.index(source.startIndex, offsetBy: self.current)
        let text = String(source[start..<current])
        
        let type: TokenType = keywords[text] ?? .IDENTIFIER
        addToken(type)
    }
    
    /**
     Processes a number, starting at the first digit to the end, including any fractional parts after the "."
    */
    private func number() {
        while isDigit(peek()) { _ = advance() }
        
        // Look for a fractional part.
        if peek() == "." && isDigit(peekNext()) {
            _ = advance()   // Consume the "."
            
            while isDigit(peek()) { _ = advance() }
        }
        
        addToken(.NUMBER)
    }
    
    /**
     Processes a string, starting at the opening " until (and including) the closing ". A new token is created for a valid string stripped of the quotes.
    */
    private func string() {
        while peek() != "\"" && !isAtEnd() {
            if peek() == "\n" { line += 1}
            _ = advance()
        }
        
        // Unterminated string.
        if isAtEnd() {
            Slox.error(line: line, message: "Unterminated string")
            return
        }
        
        // Process the closing ".
        _ = advance()
        
        // Trim the surrounding quotes.
        let start = source.index(source.startIndex, offsetBy: self.start + 1)
        let current = source.index(source.startIndex, offsetBy: self.current - 1)
        let value = String(source[start..<current])
        addToken(type: .STRING, literal: value)
    }
    
    /**
     Matches a provided character with the (yet to be processed) char determined by current.
     Used to ascertain whether a single or multi-character lexeme is being used.
     - Parameter expected: the value to match against
    */
    private func match(_ expected: Character) -> Bool {
        let current = source.index(source.startIndex, offsetBy: self.current)
        if isAtEnd() { return false }
        if source[current] != expected { return false }
        
        self.current += 1
        return true
    }
    
    /**
     Lookahead function that previews the next unprocessed character but does not consume it.
    */
    private func peek() -> Character {
        if isAtEnd() { return "\0" }
        
        let index = source.index(source.startIndex, offsetBy: self.current)
        return source[index]
    }
    
    /**
     Lookahead function that returns the unprocessed character two positions in front of the last processed character.
    */
    private func peekNext() -> Character {
        if current + 1 >= source.count { return "\0" }
        
        let index = source.index(source.startIndex, offsetBy: self.current + 1)
        return source[index]
    }
    
    /**
     Checks if a given character is a letter or underscore.
     - Parameter c: the character to check
    */
    private func isAlpha(_ c: Character) -> Bool {
        return (c >= "a" && c <= "z") ||
               (c >= "A" && c <= "Z") ||
                c == "_"
    }
    
    /**
     Checks if a character is a numerical digit between (and including) 0 and 9.
     - Paramter c: the character to check
    */
    private func isDigit(_ c: Character) -> Bool {
        return c >= "0" && c <= "9"
    }
    
    /**
     Checks if a character is a letter, underscore, or number.
     - Parameter c: the character to check
    */
    private func isAlphaNumeric(_ c: Character) -> Bool {
        return isAlpha(c) || isDigit(c)
    }
    
    /**
     Returns whether the end of the source file has been reached by the Scanner.
    */
    private func isAtEnd() -> Bool {
        return current >= source.count
    }
    
    /**
     Consumes and returns the next character in the source file.
    */
    private func advance() -> Character {
        self.current += 1
        
        let index = source.index(source.startIndex, offsetBy: current - 1)
        return source[index]
    }
    
    /**
     Creates a new token with a literal value, e.g. a string or number.
     - Parameter type: the type of token to create
     - Parameter literal: the value of the token
    */
    private func addToken(type: TokenType, literal: Any) {
        let start = source.index(source.startIndex, offsetBy: self.start)
        let current = source.index(source.startIndex, offsetBy: self.current)
        let text = String(source[start..<current])
        tokens.append(Token(type: type, lexeme: text, literal: literal, line: line))
    }
    
    /**
     Creates a new token with a specified TokenType.
     - Parameter type: the type of token to create
    */
    private func addToken(_ type: TokenType) {
        addToken(type: type, literal: [])
    }
    
    
    
}
