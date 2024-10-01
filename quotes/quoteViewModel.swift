//
//  quoteViewModel.swift
//  quotes
//
//  Created by Emmanuel  Asaber on 10/1/24.
//

import Foundation
import SwiftUI

class QuoteViewModel: ObservableObject {
    @Published var quotes: [Quote] = []
    @Published var favoriteQuotes: [Quote] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    private let userDefaults = UserDefaults.standard
    private let quotesKey = "savedQuotes"
    private let favoritesKey = "favoriteQuotes"
    
    init() {
        loadSavedQuotes()
        loadFavoriteQuotes()
    }
    
    var currentDay: Int {
        let calendar = Calendar.current
        return calendar.ordinality(of: .day, in: .year, for: Date()) ?? 0
    }
    
    func fetchQuote() {
        isLoading = true
        error = nil
        
        guard let url = URL(string: "https://zenquotes.io/api/random") else {
            isLoading = false
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
                    let decodedQuotes = try JSONDecoder().decode([Quote].self, from: data)
                    if let newQuote = decodedQuotes.first {
                        self.quotes.insert(newQuote, at: 0)
                        if self.quotes.count > 5 {
                            self.quotes.removeLast()
                        }
                        self.saveQuotes()
                    }
                } catch {
                    self.error = error
                }
            }
        }.resume()
    }
    
    func toggleFavorite(_ quote: Quote) {
        if let index = quotes.firstIndex(where: { $0.id == quote.id }) {
            quotes[index].isFavorite.toggle()
            objectWillChange.send()
            if quotes[index].isFavorite {
                favoriteQuotes.append(quotes[index])
            } else {
                favoriteQuotes.removeAll { $0.id == quote.id }
            }
            saveQuotes()
            saveFavoriteQuotes()
        }
    }
    
    private func saveQuotes() {
        do {
            let encodedData = try JSONEncoder().encode(quotes)
            userDefaults.set(encodedData, forKey: quotesKey)
        } catch {
            print("Error saving quotes: \(error)")
        }
    }
    
    private func loadSavedQuotes() {
        if let savedData = userDefaults.data(forKey: quotesKey) {
            do {
                quotes = try JSONDecoder().decode([Quote].self, from: savedData)
            } catch {
                print("Error loading saved quotes: \(error)")
            }
        }
    }
    
    private func saveFavoriteQuotes() {
        do {
            let encodedData = try JSONEncoder().encode(favoriteQuotes)
            userDefaults.set(encodedData, forKey: favoritesKey)
        } catch {
            print("Error saving favorite quotes: \(error)")
        }
    }
    
    private func loadFavoriteQuotes() {
        if let savedData = userDefaults.data(forKey: favoritesKey) {
            do {
                favoriteQuotes = try JSONDecoder().decode([Quote].self, from: savedData)
            } catch {
                print("Error loading favorite quotes: \(error)")
            }
        }
    }
}
