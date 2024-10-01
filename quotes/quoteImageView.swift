//
//  quoteImageView.swift
//  quotes
//
//  Created by Emmanuel  Asaber on 10/1/24.
//
import SwiftUI

struct QuoteImageView: View {
    let quote: Quote
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(quote.q)
                .font(.body)
                .foregroundColor(QuoteStyle.textColor)
            Text("- \(quote.a)")
                .font(.caption)
                .foregroundColor(QuoteStyle.authorColor)
        }
        .padding(QuoteStyle.padding)
        .frame(width: 300)
        .background(QuoteStyle.backgroundColor)
        .cornerRadius(QuoteStyle.cornerRadius)
        .shadow(radius: QuoteStyle.shadowRadius)
    }
}
