//
//  quoteGuessGame.swift
//  quotes
//
//  Created by Emmanuel  Asaber on 10/1/24.
//

import SwiftUI

struct QuoteGuessGame: View {
    @StateObject private var gameViewModel = QuoteGuessGameViewModel()
    @State private var showingResult = false
    @State private var gameOver = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Guess the Author")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            if gameViewModel.isLoading {
                ProgressView("Loading quotes...")
            } else if let error = gameViewModel.error {
                Text("Error: \(error.localizedDescription)")
                    .foregroundColor(.red)
                Button("Try Again") {
                    gameViewModel.startGame()
                }
                .buttonStyle(.borderedProminent)
            } else if gameOver {
                Text("Game Over!")
                    .font(.title)
                Text("Your score: \(gameViewModel.score)/\(gameViewModel.totalQuestions)")
                    .font(.title2)
                Button("Play Again") {
                    gameViewModel.startGame()
                    gameOver = false
                }
                .buttonStyle(.borderedProminent)
            } else {
                Text(gameViewModel.currentQuote?.q ?? "Loading...")
                    .font(.title3)
                    .padding()
                    .frame(height: 150)
                
                ForEach(gameViewModel.currentChoices, id: \.self) { author in
                    Button(action: {
                        showingResult = true
                        gameViewModel.checkGuess(author)
                    }) {
                        Text(author)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                
                if showingResult {
                    Text(gameViewModel.lastGuessCorrect ? "Correct!" : "Incorrect.")
                        .foregroundColor(gameViewModel.lastGuessCorrect ? .green : .red)
                    Text("The correct answer is: \(gameViewModel.currentQuote?.a ?? "")")
                    
                    Button("Next Quote") {
                        gameViewModel.nextQuote()
                        showingResult = false
                        if gameViewModel.isGameOver {
                            gameOver = true
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
        .padding()
        .onAppear {
            gameViewModel.startGame()
        }
    }
}
