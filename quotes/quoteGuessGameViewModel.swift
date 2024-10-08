//
//  quoteGuessGameViewModel.swift
//  quotes
//
//  Created by Emmanuel  Asaber on 10/1/24.
//

import Foundation

class QuoteGuessGameViewModel: ObservableObject {
    @Published var currentQuote: Quote?
    @Published var currentChoices: [String] = []
    @Published var score = 0
    @Published var isLoading = false
    @Published var error: Error?
    @Published var selectedAnswer: String?
    @Published var showCorrectAnswer = false
    @Published var quoteIndex = 0
    @Published var isGameOver = false

    let totalQuestions = 5
    private var quotes: [Quote] = []
    
    func startGame() {
        resetGame()
        fetchQuotes()
    }
    
    func fetchQuotes() {
        isLoading = true
        error = nil
        
        guard let url = URL(string: "https://zenquotes.io/api/quotes") else {
            isLoading = false
            error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let error = error {
                    self.error = error
                    return
                }
                
                guard let data = data else {
                    self.error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                    return
                }
                
                do {
                    self.quotes = try JSONDecoder().decode([Quote].self, from: data)
                    self.quotes.shuffle()
                    self.nextQuote()
                } catch {
                    self.error = error
                }
            }
        }.resume()
    }
    
    func nextQuote() {
        if quoteIndex < min(quotes.count, totalQuestions) {
            currentQuote = quotes[quoteIndex]
            generateChoices()
            selectedAnswer = nil
            showCorrectAnswer = false
            quoteIndex += 1
        } else {
            isGameOver = true
        }
    }
    
    func generateChoices() {
        guard let correctAuthor = currentQuote?.a else { return }
        currentChoices = [correctAuthor]
        
        while currentChoices.count < 4 {
            if let randomQuote = quotes.randomElement(), !currentChoices.contains(randomQuote.a) {
                currentChoices.append(randomQuote.a)
            }
        }
        
        currentChoices.shuffle()
    }
    
    func checkGuess(_ guess: String) {
        selectedAnswer = guess
        showCorrectAnswer = true
        if guess == currentQuote?.a {
            score += 1
        }
    }
    
    func resetGame() {
        quoteIndex = 0
        score = 0
        quotes = []
        currentQuote = nil
        currentChoices = []
        selectedAnswer = nil
        showCorrectAnswer = false
        isGameOver = false
    }
}
