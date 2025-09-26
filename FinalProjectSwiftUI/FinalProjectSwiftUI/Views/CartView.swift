//
//  CartView.swift
//  FinalProjectSwiftUI
//
//  Created by Ahmed Tayyib Kaya on 23.09.2025.
//

import SwiftUI

struct CartView: View {
    @StateObject private var cartVM = CartViewModel()
    
    var totalPrice: Int {
        cartVM.cartItems.reduce(0){$0 + ($1.price * $1.orderAmount)}
    }
    
    var body: some View {
        NavigationStack {
            VStack{
                if cartVM.cartItems.isEmpty {
                    Text("🛒 Your cart is empty").font(.headline).foregroundColor(.secondary).padding()
                }else{
                    List {
                        ForEach(cartVM.cartItems) { item in
                            HStack(spacing: 12) {
                                AsyncImage(url: URL(string: "http://kasimadalan.pe.hu/movies/images/\(item.image)")) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 60, height: 90)
                                        .cornerRadius(8)
                                } placeholder: {
                                    ProgressView()
                                }
                                
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(item.name)
                                        .font(.headline)
                                    Text("Quantity: \(item.orderAmount)")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    Text("$\(item.price * item.orderAmount)")
                                        .font(.subheadline)
                                        .foregroundColor(.green)
                                }
                                
                                Spacer()
                                
                                
                                Button(role: .destructive) {
                                    cartVM.removeFromCart(cartId: item.cartId)
                                } label: {
                                    Image(systemName: "trash")
                                }
                            }
                        }
                    }
                    HStack{
                        Text("Total:").font(.headline)
                        Text("$\(totalPrice)").font(.title2).fontWeight(.bold).foregroundColor(.green)
                        Spacer()
                        
                        Button(action: {
                            print("Buy button is working")
                        }){
                            Text("Buy").font(.headline).padding(.horizontal, 16).padding(.vertical,8).background(Color.blue).foregroundColor(.white).cornerRadius(8)
                        }
                    }.padding()
                }
            }
                    
                    .onAppear {
                        cartVM.fetchCart()
                    }
                }
            }
        }

