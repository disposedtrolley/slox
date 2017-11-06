//
//  main.swift
//  slox
//
//  Created by James Liu on 1/11/17.
//  Copyright © 2017 James Liu. All rights reserved.
//

import Foundation

let argCount = CommandLine.argc     // retrieve the count of arguments
let args = CommandLine.arguments    // retrieve the arguments themselves

if argCount > 2 {
    print("Usage: slox [script]")
} else if argCount == 2 {
    try Slox.runFile(path: args[1])
} else {
    Slox.runPrompt()
}
