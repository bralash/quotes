import Foundation

class SharedDataManager {
    static let shared = SharedDataManager()
    
    private let userDefaults: UserDefaults?
    private let quotesKey = "SavedQuotes"
    
    init() {
        userDefaults = UserDefaults(suiteName: "group.com.lashpixel.quotes")
        print("SharedDataManager initialized with UserDefaults: \(String(describing: userDefaults))")
    }
    
    func saveQuotes(_ quotes: [Quote]) {
        do {
            let encodedData = try JSONEncoder().encode(quotes)
            userDefaults?.set(encodedData, forKey: quotesKey)
            userDefaults?.synchronize()
            print("Saved \(quotes.count) quotes to UserDefaults with key: \(quotesKey)")
        } catch {
            print("Error saving quotes: \(error)")
        }
    }
    
    func getQuotes() -> [Quote] {
        guard let data = userDefaults?.data(forKey: quotesKey) else {
            print("No data found for key: \(quotesKey)")
            return []
        }
        
        do {
            let quotes = try JSONDecoder().decode([Quote].self, from: data)
            print("Retrieved \(quotes.count) quotes from UserDefaults")
            return quotes
        } catch {
            print("Error decoding quotes: \(error)")
            return []
        }
    }
    
    func getRandomQuote() -> Quote? {
        let quotes = getQuotes()
        let randomQuote = quotes.randomElement()
        print("Random quote selected: \(randomQuote?.q ?? "None")")
        return randomQuote
    }
}
