//
//  quoteCard.swift
//  quotes
//
//  Created by Emmanuel  Asaber on 10/1/24.
//

import SwiftUI

struct QuoteCard: View {
    let quote: Quote
    let onFavorite: () -> Void
    @State private var showingShareSheet = false
    @State private var animateHeart = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Quote content
            VStack(alignment: .leading, spacing: 8) {
                Text(quote.q)
                    .font(.body)
                    .foregroundColor(QuoteStyle.textColor)
                Text("- \(quote.a)")
                    .font(.caption)
                    .foregroundColor(QuoteStyle.authorColor)
            }
            
            // Action buttons
            HStack {
                Spacer()
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        animateHeart = true
                        onFavorite()
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        animateHeart = false
                    }
                }) {
                    Image(systemName: quote.isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(quote.isFavorite ? .red : .gray)
                        .scaleEffect(animateHeart ? 1.3 : 1.0)
                }
                .buttonStyle(BorderlessButtonStyle())
                
                Spacer()
                
                Button(action: {
                    showingShareSheet = true
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(.blue)
                }
                .buttonStyle(BorderlessButtonStyle())
                Spacer()
            }
        }
        .padding(QuoteStyle.padding)
        .background(QuoteStyle.backgroundColor)
        .cornerRadius(QuoteStyle.cornerRadius)
        .shadow(radius: QuoteStyle.shadowRadius)
        .sheet(isPresented: $showingShareSheet) {
            ShareSheet(activityItems: [renderQuoteImage()])
        }
        .transition(.asymmetric(insertion: .scale.combined(with: .opacity), removal: .opacity))
    }
    
    
    private func renderQuoteImage() -> UIImage {
        let renderer = ImageRenderer(content: QuoteImageView(quote: quote))
        renderer.scale = 3.0
        return renderer.uiImage ?? UIImage()
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
