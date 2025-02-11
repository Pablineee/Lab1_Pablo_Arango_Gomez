//
//  ContentView.swift
//  prime-game
//
//  Created by Pablo on 2025-02-11.
//

import SwiftUI

struct ContentView: View {
    // Random number generator
    var randomInt: Int = Int.random(in: 1...100)
    
    // Enum used to store the current result state
    enum Result {
        case correct, incorrect, pending
    }
    @State var result: Result = .pending
    @State var message: String = "" // Result displayed to the user
    
    // Function used to check if number is Prime or not
    func isPrime(num: Int) -> Bool {
        if num <= 1 {
            return false
        }
        let n: Int = num-1
        for i in 2...n {
            if num % i == 0 {
               return false
            }
        }
        return true
    }
    
    // Function used to update user on their current score
    func scoreUpdate() {
        // Give score update using an overlay
        
        // Reset scores and current attempts to 0
        correctTotal = 0
        incorrectTotal = 0
        currentAttempts = 0
    }
    
    
    // Used for monitoring correct and incorrect results
    @State var correctTotal: Int = 0
    @State var incorrectTotal: Int = 0
    
    
    // Current attempts
    @State var currentAttempts: Int = 0
    
    func takeTurn() {
        // Increment currentAttempts
        currentAttempts += 1
        
        // Check is currentAttempts is equal to 10
        if currentAttempts == 10 {
            scoreUpdate()
        }
    }
    
    var body: some View {
        Text(String(randomInt))
        
        // Button used for indicating that the number is a Prime number
        Button("Prime") {
            if isPrime(num: Int(randomInt)) {
                result = .correct
                correctTotal += 1
            } else {
                result = .incorrect
                incorrectTotal += 1
            }
            takeTurn()
        }
        
        // Button used for indicating that the number is a Prime number
        Button("Not Prime") {
            if !isPrime(num: Int(randomInt)) {
                result = .correct
                correctTotal += 1
            } else {
                result = .incorrect
                incorrectTotal += 1
            }
            takeTurn()
        }
        
        switch result {
        case .correct:
            Text("✅")
        case .incorrect:
            Text("❌")
        default:
            Text("")
        }
    }
}

#Preview {
    ContentView()
}
