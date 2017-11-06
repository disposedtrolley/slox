//
//  Slox.swift
//  slox
//
//  Created by James Liu on 1/11/17.
//  Copyright © 2017 James Liu. All rights reserved.
//

import Foundation

public final class Slox {
    
    static var hadError = false
    
    static func runFile(path: String) throws {
        let url = URL(fileURLWithPath: path)
        let string = try String(contentsOf: url)
        run(source: string)
        
        // Indicate the error in the exit code.
        if hadError { exit(65) }
    }
    
    static func runPrompt() {
        while true {
            print("> ")
            guard let input = readLine() else { continue }
            run(source: input)
            hadError = false
        }
    }
    
    static func run(source: String) {
        let scanner: Scanner = Scanner(source: source)
        let tokens: Array<Token> = scanner.scanTokens()
        
        for token in tokens {
            print(token)
        }
    }
    
    static func error(line: Int, message: String) {
        Slox.report(line: line, where: "", message: message)
    }
    
    static func report(line: Int, where: String, message: String) {
        print("[line \(line)] Error  : \(message)")
    }
}
