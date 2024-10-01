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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(quote.q)
                .font(.system(size: 18, weight: .medium, design: .serif))
                .foregroundColor(.primary)
                .padding(.bottom, 8)
            
            HStack {
                Text("— \(quote.a)")
                    .font(.system(size: 14, weight: .regular, design: .serif))
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Button(action: onFavorite) {
                    Image(systemName: quote.isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(quote.isFavorite ? .red : .gray)
                }
            }
        }
        .padding(20)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}
