import SwiftUI

struct MovieDetailView: View {
    let movie: Movie
    @State private var quantity: Int = 1
    @StateObject private var cartVM = CartViewModel()
    @State private var addedToCart = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                AsyncImage(url: URL(string: "http://kasimadalan.pe.hu/movies/images/\(movie.image)")) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .cornerRadius(12)
                } placeholder: {
                    ProgressView()
                }
                
                Text(movie.name)
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("\(String(movie.year)) • \(movie.director)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack {
                    Text("⭐️ \(movie.rating, specifier: "%.1f")")
                    Spacer()
                    Text("$\(movie.price)")
                        .font(.headline)
                        .foregroundColor(.green)
                }
                
                Text(movie.description)
                    .font(.body)
                    .padding(.top, 8)
                
                Stepper("Quantity: \(quantity)", value: $quantity, in: 1...10)
                    .padding(.vertical)
                
                Button(action: {
                    cartVM.addToCart(movie: movie, amount: quantity)
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                        addedToCart = true
                    }
                    
                    // 2 saniye sonra mesaj kaybolsun
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            addedToCart = false
                        }
                    }
                }) {
                    Text("Add to Cart")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top)
                
                if addedToCart {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .font(.title)
                            .scaleEffect(addedToCart ? 1.2 : 0.8)
                            .transition(.scale.combined(with: .opacity))
                        
                        Text("Added to Cart")
                            .font(.headline)
                            .foregroundColor(.green)
                    }
                    .padding(.top, 8)
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
