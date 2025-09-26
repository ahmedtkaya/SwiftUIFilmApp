//
//  ContentView.swift
//  FinalProjectSwiftUI
//
//  Created by Ahmed Tayyib Kaya on 23.09.2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            MovieListView()
                .tabItem {
                    Image(systemName: "film")
                    Text("Movies")
                }
            
            CartView()
                .tabItem {
                    Image(systemName: "cart")
                    Text("Cart")
                }
        }
    }
}

#Preview {
    ContentView()
}

