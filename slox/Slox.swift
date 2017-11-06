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
    
    static func main() throws {
        let argCount = CommandLine.argc     // retrieve the count of arguments
        let args = CommandLine.arguments    // retrieve the arguments themselves
        
        // first argument in Swift is always the executable path
        if argCount > 2 {
            print("Usage: slox [script]")
        } else if argCount == 2 {
            try Slox.runFile(path: args[1])
        } else {
            Slox.runPrompt()
        }
    }
    
    private static func runFile(path: String) throws {
        let url = URL(fileURLWithPath: path)
        let string = try String(contentsOf: url)
        run(source: string)
        
        // Indicate the error in the exit code.
        if hadError { exit(65) }
    }
    
    private static func runPrompt() {
        while true {
            print("> ")
            guard let input = readLine() else { continue }
            run(source: input)
            hadError = false
        }
    }
    
    private static func run(source: String) {
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
