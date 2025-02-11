//
//  ContentView.swift
//  prime-game
//
//  Created by Pablo on 2025-02-11.
//

import SwiftUI

struct ContentView: View {
    var randomInt = String(Int.random(in: 1...100))
    var body: some View {
        Text(randomInt)
    }
}

#Preview {
    ContentView()
}
