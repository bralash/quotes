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
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Day \(viewModel.currentDay) / 365")
                    .font(.headline)
                    .padding()
                
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
                
                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        Button("New Quote") {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                animateNewQuote = true
                                viewModel.fetchQuote()
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                animateNewQuote = false
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .scaleEffect(animateNewQuote ? 1.1 : 1.0)
                        
                        Spacer()
                        
                        Button("Play Game") {
                            showingGame = true
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding(.horizontal)
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
        }
    }
}


#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
