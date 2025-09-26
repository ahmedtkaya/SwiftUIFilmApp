//
//  Movie.swift
//  FinalProjectSwiftUI
//
//  Created by Ahmed Tayyib Kaya on 23.09.2025.
//

import Foundation

struct Movie: Codable, Identifiable {
    let id: Int
    let name: String
    let image: String
    let price: Int
    let category: String
    let rating: Double
    let year: Int
    let director: String
    let description: String
}
