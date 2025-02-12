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
    @State var displayOverlay: Bool = false
    
    // Used to monitor correct, incorrect results, and current attempts
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
    
    // Function used to generate a new number
    func updateNumber() {
        randomInt = Int.random(in: 1...100)
        answerGiven = false
    }
    
    func finishTurn() {
        // Increment currentAttempts
        currentAttempts += 1
        timeRemaining = 5
        
        // Check if currentAttempts is equal to 10
        if currentAttempts >= 10 {
            result = .pending
            displayOverlay = true
            maxAttemptsReached = .yes
        } else {
            updateNumber()
        }
        
    }
    
    // Function used to reset values and states
    func resetGame() {
        correctTotal = 0
        incorrectTotal = 0
        currentAttempts = 0
        maxAttemptsReached = .no
        displayOverlay = false
        result = .pending
        updateNumber()
    }
    
    var body: some View {
        VStack {
            Text(String(randomInt))
                .foregroundColor(.gray)
                .font(.largeTitle)
                .padding(100)
            
            HStack {
                // Button used for indicating that the number is a Prime number
                Button(" Prime      ") {
                    if !displayOverlay {
                        answerGiven = true
                        if isPrime(num: Int(randomInt)) {
                            result = .correct
                            correctTotal += 1
                        } else {
                            result = .incorrect
                            incorrectTotal += 1
                        }
                        finishTurn()
                    }
                }
                .padding(25)
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(8)
                
                // Button used for indicating that the number is a Prime number
                Button("Not Prime") {
                    if !displayOverlay {
                        answerGiven = true
                        if !isPrime(num: Int(randomInt)) {
                            result = .correct
                            correctTotal += 1
                        } else {
                            result = .incorrect
                            incorrectTotal += 1
                        }
                        finishTurn()
                    }
                }
                .padding(25)
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(8)
                
            }
            
            // Display time remaining and refresh timer if countdown has reached 0 or user has given an answer
            Text("\(timeRemaining)")
                .onReceive(timer) { _ in
                    if !displayOverlay {
                        if timeRemaining > 0 {
                            timeRemaining -= 1
                        } else if timeRemaining == 0 && !answerGiven {
                            incorrectTotal += 1 // Added to ensure user is penalized for not answering
                            finishTurn()
                            timeRemaining = 5
                            timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect() // Reset timer
                            updateNumber()
                        }
                    }
                }
                .padding()
                .foregroundColor(.gray)
                .font(.largeTitle)
            
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
                if displayOverlay {
                    ZStack {
                        LinearGradient(
                            colors: [.blue, .cyan],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .ignoresSafeArea()
                                        
                        VStack {
                            Text("Correct - \(correctTotal)")
                                .foregroundColor(.white)
                                .font(.title)
                            Text("Incorrect - \(incorrectTotal)")
                                .foregroundColor(.white)
                                .font(.title)
                            Text("\(correctTotal * 10)%")
                                .foregroundColor(.white)
                                .font(.title)
                            Button("Restart") {
                                resetGame()
                            }
                            .padding(10)
                            .background(Color.white)
                            .cornerRadius(8)
                        }
                    }
                }
            case .no:
                Text(" ")
            }
        }
        
        
    }
}

#Preview {
    ContentView()
}
