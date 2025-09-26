//
//  MovieService.swift
//  FinalProjectSwiftUI
//
//  Created by Ahmed Tayyib Kaya on 23.09.2025.
//

import Foundation

class MovieService {
    private let baseUrl = "http://kasimadalan.pe.hu/movies/"
    private let userName = "ahmed" // kendi sabit kullanıcı adını belirle
    // MARK: - Bütün Filmleri Getir
    func getAllMovies(completion: @escaping ([Movie]) -> Void) {
        guard let url = URL(string: "\(baseUrl)getAllMovies.php") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("❌ Network error:", error.localizedDescription)
                return
            }
            
            guard let data = data else {
                print("❌ Empty response")
                return
            }
            
            // 🔎 API’den gelen ham JSON’u yazdır
            if let jsonString = String(data: data, encoding: .utf8) {
                print("📩 Raw JSON:", jsonString)
            }
            
            do {
                let decoded = try JSONDecoder().decode(MoviesResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(decoded.movies)
                }
            } catch {
                print("❌ Decode error:", error.localizedDescription)
            }
        }.resume()
    }


    // MARK: - Sepeti Çağır
    func getCart(completion: @escaping ([CartItem]) -> Void) {
        guard let url = URL(string: "\(baseUrl)getMovieCart.php") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let body = "userName=\(userName)"
        request.httpBody = body.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("❌ Network error:", error.localizedDescription)
                return
            }
            
            guard let data = data else {
                print("❌ Empty response")
                return
            }
            
            // 🔎 Gelen JSON'u debug için yazdıralım
            if let jsonString = String(data: data, encoding: .utf8) {
                print("📩 Cart JSON:", jsonString)
            }
            
            do {
                let decoded = try JSONDecoder().decode([String: [CartItem]].self, from: data)
                let items = decoded["movie_cart"] ?? []
                DispatchQueue.main.async {
                    completion(items)
                }
            } catch {
                print("⚠️ Decode error:", error.localizedDescription)
                
                // Eğer decode edilemezse boş dizi dönelim
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }.resume()
    }

    
    // MARK: - Sepete Film Ekle
    func insertMovie(movie: Movie, amount: Int, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(baseUrl)insertMovie.php") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let body =
        "name=\(movie.name)" +
        "&image=\(movie.image)" +
        "&price=\(movie.price)" +
        "&category=\(movie.category)" +
        "&rating=\(movie.rating)" +
        "&year=\(movie.year)" +
        "&director=\(movie.director)" +
        "&description=\(movie.description)" +
        "&orderAmount=\(amount)" +
        "&userName=\(userName)"
        
        request.httpBody = body.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            DispatchQueue.main.async {
                completion(error == nil)
            }
        }.resume()
    }
    
    // MARK: - Sepetten Film Sil
    func deleteMovie(cartId: Int, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(baseUrl)deleteMovie.php") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let body = "cartId=\(cartId)&userName=\(userName)"
        request.httpBody = body.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            DispatchQueue.main.async {
                completion(error == nil)
            }
        }.resume()
    }
}
