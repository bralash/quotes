//
//  quoteOfTheDayView.swift
//  quotes
//
//  Created by Emmanuel  Asaber on 10/1/24.
//
import SwiftUI

struct QuoteOfTheDayView: View {
    let quote: Quote
    let currentDay: Int
    let totalDays: Int
    let onClose: () -> Void
    
    @State private var showingShareSheet = false
    
    var body: some View {
        ZStack {
            Color(UIColor.systemBackground).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Text("Quote of the Day")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Day \(currentDay)/\(totalDays)")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                VStack(spacing: 16) {
                    Text(quote.q)
                        .font(.title2)
                        .fontWeight(.medium)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    Text("- \(quote.a)")
                        .font(.title3)
                        .fontWeight(.regular)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(15)
                
                Spacer()
                
                HStack {
                    Button(action: onClose) {
                        Text("Close")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        showingShareSheet = true
                    }) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(width: 50, height: 50)
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
            }
            .padding()
        }
        .sheet(isPresented: $showingShareSheet) {
            ActivityViewController(activityItems: ["\(quote.q) - \(quote.a)"])
        }
    }
}

struct ActivityViewController: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
