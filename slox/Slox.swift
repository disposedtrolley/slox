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
    
    /**
     Runs the Slox interpreter on a given file.
    */
    static func runFile(path: String) throws {
        let url = URL(fileURLWithPath: path)
        let string = try String(contentsOf: url)
        run(source: string)
        
        // Indicate the error in the exit code.
        if hadError { exit(65) }
    }
    
    /**
     Runs the Slox interpreter as a REPL.
    */
    static func runPrompt() {
        while true {
            print("> ")
            guard let input = readLine() else { continue }
            run(source: input)
            hadError = false
        }
    }
    
    /**
     Initiates the Slox interpreter with a given string.
    */
    private static func run(source: String) {
        let scanner: Scanner = Scanner(source: source)
        let tokens: Array<Token> = scanner.scanTokens()
        
        for token in tokens {
            print(token)
        }
    }
    
    /**
     Utility method to log errors.
    */
    static func error(line: Int, message: String) {
        Slox.report(line: line, column: "", message: message)
    }
    
    static func report(line: Int, column: String, message: String) {
        print("[line \(line)] Error \(column) : \(message)")
        hadError = true
    }
}
