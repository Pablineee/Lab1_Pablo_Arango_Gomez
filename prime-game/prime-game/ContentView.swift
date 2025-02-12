//
//  ContentView.swift
//  prime-game
//
//  Created by Pablo on 2025-02-11.
//

import SwiftUI

struct ContentView: View {
    // Random number generator
    @State var randomInt: Int = Int.random(in: 1...100)
    @State var answerGiven: Bool = false
    // @State var maxAttemptsReached: Bool = false
    
    // Used for monitoring correct, incorrect results, and current attempts
    @State var correctTotal: Int = 0
    @State var incorrectTotal: Int = 0
    @State var currentAttempts: Int = 0
    
    // Enum used to store the current result state
    enum Result {
        case correct, incorrect, pending
    }
    
    // Used in place of Bool value due to debugging issues
    enum MaxReached {
        case yes, no
    }
    
    @State var maxAttemptsReached: MaxReached = .no
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
    
    // Initialize timer used to update the random number every 5 seconds
    @State var timeRemaining = 5
    @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
   
    
    // Function used to update user on their current score
    func scoreUpdate() {
        // Give score update using an overlay
        // displayScore()
        
        // Reset scores and current attempts to 0
        correctTotal = 0
        incorrectTotal = 0
        currentAttempts = 0
        maxAttemptsReached = .no
        updateNumber()
    }
    
    // Function used to generate a new number
    func updateNumber() {
        randomInt = Int.random(in: 1...100)
        answerGiven = false
        
        // If turn has not been taken, increment incorrectTotal and execute takeTurn() function
        if !answerGiven && currentAttempts != 0 {
            incorrectTotal += 1
            takeTurn()
        }
    }
    
    func takeTurn() {
        // Increment currentAttempts
        currentAttempts += 1
        timeRemaining = 5
        
        // Check if currentAttempts is equal to 10
        if currentAttempts == 10 {
            scoreUpdate()
            maxAttemptsReached = .yes
        } else {
            maxAttemptsReached = .no
            updateNumber()
        }
    }
    
    var body: some View {
        Text(String(randomInt))
            .foregroundColor(.gray)
            .font(.largeTitle)
            .padding(100)
        
        // Button used for indicating that the number is a Prime number
        Button("Prime") {
            answerGiven = true
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
            answerGiven = true
            if !isPrime(num: Int(randomInt)) {
                result = .correct
                correctTotal += 1
            } else {
                result = .incorrect
                incorrectTotal += 1
            }
            takeTurn()
        }
        
        // Display time remaining and refresh timer if countdown has reached 0 or user has given an answer
        Text("\(timeRemaining)")
            .onReceive(timer) { _ in
                if timeRemaining > 0 {
                    timeRemaining -= 1
                } else if timeRemaining == 0 {
                    timeRemaining = 5
                    timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
                    updateNumber()
                }
            }
        
        // Display result based on user selection
        switch result {
        case .correct:
            Text("✅")
        case .incorrect:
            Text("❌")
        default:
            Text(" ")
        }
        
        switch maxAttemptsReached {
        case .yes:
            ZStack {
                LinearGradient(
                    colors: [.blue, .cyan],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                Text("This is a test overlay")
                    .foregroundColor(.white)
                    .font(.title)
            }
        case .no:
            Text("Test")
        }
        
    }
}

#Preview {
    ContentView()
}
