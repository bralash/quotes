//
//  quote.swift
//  quotes
//
//  Created by Emmanuel  Asaber on 10/1/24.
//
//import Foundation
//import SwiftUI
//
//struct Quote: Identifiable, Codable {
//    let id: UUID
//    let q: String
//    let a: String
//    let h: String
//    var isFavorite: Bool
//    
//    enum CodingKeys: String, CodingKey {
//        case q, a, h, isFavorite
//    }
//    
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        q = try container.decode(String.self, forKey: .q)
//        a = try container.decode(String.self, forKey: .a)
//        h = try container.decode(String.self, forKey: .h)
//        isFavorite = try container.decodeIfPresent(Bool.self, forKey: .isFavorite) ?? false
//        id = UUID()
//    }
//}
