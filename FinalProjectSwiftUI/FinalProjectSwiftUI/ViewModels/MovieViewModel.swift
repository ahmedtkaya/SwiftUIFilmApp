//
//  MovieViewModel.swift
//  FinalProjectSwiftUI
//
//  Created by Ahmed Tayyib Kaya on 23.09.2025.
//

import Foundation
import Combine

class MovieViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    private let service = MovieService()
    
    func fetchMovies() {
        service.getAllMovies { [weak self] movies in
            self?.movies = movies
        }
    }
}

