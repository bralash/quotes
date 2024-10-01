//
//  ContentView.swift
//  quotes
//
//  Created by Emmanuel  Asaber on 10/1/24.
//

import SwiftUI


struct ContentView: View {
    @StateObject private var viewModel = QuoteViewModel()
    @State private var showingFavorites = false
    @State private var animateNewQuote = false
    @State private var showingGame = false
    @State private var showingQuoteOfTheDay = true
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading && viewModel.quotes.isEmpty {
                    ProgressView()
                } else if let error = viewModel.error {
                    Text("Error: \(error.localizedDescription)")
                        .foregroundColor(.red)
                } else {
                    List {
                        ForEach(showingFavorites ? viewModel.favoriteQuotes : viewModel.quotes) { quote in
                            QuoteCard(quote: quote) {
                                viewModel.toggleFavorite(quote)
                            }
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                        }
                        .animation(.spring(), value: showingFavorites)
                    }
                    .listStyle(PlainListStyle())
                }
                
                HStack(spacing: 20) {
                    Button(action: {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                            animateNewQuote = true
                            viewModel.fetchQuote()
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            animateNewQuote = false
                        }
                    }) {
                        Image(systemName: "quote.bubble")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                            .background(Color.blue)
                            .clipShape(Circle())
                    }
                    .scaleEffect(animateNewQuote ? 1.1 : 1.0)
                    
                    Button(action: {
                        showingGame = true
                    }) {
                        Image(systemName: "gamecontroller")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                            .background(Color.green)
                            .clipShape(Circle())
                    }
                }
                .padding(.bottom, 20)
            }
            .navigationTitle("Quotes")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(showingFavorites ? "All Quotes" : "Favorites") {
                        withAnimation(.easeInOut) {
                            showingFavorites.toggle()
                        }
                    }
                }
            }
            .sheet(isPresented: $showingGame) {
                QuoteGuessGame()
            }
        }
        .onAppear {
            if viewModel.quotes.isEmpty {
                viewModel.fetchQuote()
            }
            viewModel.fetchQuoteOfTheDay()
        }
        .overlay {
            if viewModel.shouldShowQuoteOfTheDay, let quoteOfTheDay = viewModel.quoteOfTheDay {
                QuoteOfTheDayView(
                    quote: quoteOfTheDay,
                    currentDay: viewModel.currentDay,
                    totalDays: viewModel.totalDaysInYear
                ) {
                    viewModel.shouldShowQuoteOfTheDay = false
                }
                .transition(.opacity)
                .animation(.easeInOut, value: viewModel.shouldShowQuoteOfTheDay)
            }
        }
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
