//
//  CartViewModel.swift
//  FinalProjectSwiftUI
//
//  Created by Ahmed Tayyib Kaya on 23.09.2025.
//

import Foundation
import Combine

class CartViewModel: ObservableObject {
    @Published var cartItems: [CartItem] = []
    private let service = MovieService()
    
    func fetchCart() {
        service.getCart { [weak self] items in
            
            let grouped = Dictionary(grouping: items, by: { $0.name })
            
            let merged = grouped.map { (_, values) -> CartItem in
                var first = values.first!
                let totalAmount = values.reduce(0) { $0 + $1.orderAmount }
                first = CartItem(
                    cartId: first.cartId,
                    name: first.name,
                    image: first.image,
                    price: first.price,
                    category: first.category,
                    rating: first.rating,
                    year: first.year,
                    director: first.director,
                    description: first.description,
                    orderAmount: totalAmount,
                    userName: first.userName
                )
                return first
            }
            
            DispatchQueue.main.async {
                self?.cartItems = merged
            }
        }
    }

    
    func addToCart(movie: Movie, amount: Int) {
        service.insertMovie(movie: movie, amount: amount) { [weak self] success in
            if success {
                self?.fetchCart()
            }
        }
    }
    
    func removeFromCart(cartId: Int) {
        service.deleteMovie(cartId: cartId) { [weak self] success in
            if success {
                self?.fetchCart()
            }
        }
    }
    
    func updateQuantity(item: CartItem, newAmount: Int) {
        if newAmount <= 0 {
            removeFromCart(cartId: item.cartId)
            return
        }
        
        service.deleteMovie(cartId: item.cartId) { [weak self] success in
            if success {
                let movie = Movie(
                    id: item.cartId,
                    name: item.name,
                    image: item.image,
                    price: item.price,
                    category: item.category,
                    rating: item.rating,
                    year: item.year,
                    director: item.director,
                    description: item.description
                )
                
                self?.service.insertMovie(movie: movie, amount: newAmount) { insertSuccess in
                    if insertSuccess {
                        self?.fetchCart()
                    }
                }
            }
        }
    }

}
