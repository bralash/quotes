//
//  quoteModel.swift
//  quotes
//
//  Created by Emmanuel  Asaber on 10/1/24.
//

import Foundation

struct Quote: Identifiable, Codable {
    let id: UUID
    let q: String
    let a: String
    let h: String
    var isFavorite: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case q, a, h
    }
    
    init(id: UUID = UUID(), q: String, a: String, h: String, isFavorite: Bool = false) {
        self.id = id
        self.q = q
        self.a = a
        self.h = h
        self.isFavorite = isFavorite
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        q = try container.decode(String.self, forKey: .q)
        a = try container.decode(String.self, forKey: .a)
        h = try container.decode(String.self, forKey: .h)
        id = UUID()
        isFavorite = false
    }
}
