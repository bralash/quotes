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
    @Published var quoteOfTheDay: Quote?
    @Published var shouldShowQuoteOfTheDay: Bool = false
    
    private let userDefaults = UserDefaults.standard
    private let quotesKey = "savedQuotes"
    private let favoritesKey = "favoriteQuotes"
    private let lastShownDateKey = "LastShownQuoteOfTheDayDate"
    private let quoteOfTheDayKey = "QuoteOfTheDay"
    
    private let maxQuotes = 5
    
    init() {
        loadSavedQuotes()
        loadFavoriteQuotes()
    }
    
    func fetchQuoteOfTheDay() {
        let calendar = Calendar.current
        if let lastShownDate = userDefaults.object(forKey: lastShownDateKey) as? Date,
           calendar.isDateInToday(lastShownDate),
           let savedQuote = getSavedQuoteOfTheDay() {
            quoteOfTheDay = savedQuote
            shouldShowQuoteOfTheDay = true
        } else {
            // Fetch new quote of the day
            isLoading = true
            error = nil
            
            guard let url = URL(string: "https://zenquotes.io/api/today") else {
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
                        if let todayQuote = decodedQuotes.first {
                            self.quoteOfTheDay = todayQuote
                            self.saveQuoteOfTheDay(todayQuote)
                            self.userDefaults.set(Date(), forKey: self.lastShownDateKey)
                            self.shouldShowQuoteOfTheDay = true
                        }
                    } catch {
                        self.error = error
                    }
                }
            }.resume()
        }
    }
    
    private func saveQuoteOfTheDay(_ quote: Quote) {
        if let encodedData = try? JSONEncoder().encode(quote) {
            userDefaults.set(encodedData, forKey: quoteOfTheDayKey)
        }
    }
    
    private func getSavedQuoteOfTheDay() -> Quote? {
        guard let savedData = userDefaults.data(forKey: quoteOfTheDayKey) else { return nil }
        return try? JSONDecoder().decode(Quote.self, from: savedData)
    }
    
    var currentDay: Int {
        let calendar = Calendar.current
        return calendar.ordinality(of: .day, in: .year, for: Date()) ?? 0
    }
    
    var totalDaysInYear: Int {
        let calendar = Calendar.current
        return calendar.range(of: .day, in: .year, for: Date())?.count ?? 365
    }
    
    func fetchQuote() {
        isLoading = true
        error = nil
        
        guard let url = URL(string: "https://zenquotes.io/api/quotes") else {
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
                        self.addNewQuote(newQuote)
                    }
                } catch {
                    self.error = error
                    print("Error decoding quotes: \(error)")
                }
            }
        }.resume()
    }
    
    private func addNewQuote(_ quote: Quote) {
        quotes.insert(quote, at: 0)
        if quotes.count > maxQuotes {
            quotes.removeLast()
        }
        saveQuotes()
        SharedDataManager.shared.saveQuotes(quotes)
    }
    
    func toggleFavorite(_ quote: Quote) {
        if let index = quotes.firstIndex(where: { $0.id == quote.id }) {
            quotes[index].isFavorite.toggle()
            objectWillChange.send()
            updateFavorites()
            saveQuotes()
            saveFavoriteQuotes()
        }
    }
    
    private func updateFavorites() {
        favoriteQuotes = quotes.filter { $0.isFavorite }
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
                updateFavorites()
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
