import SwiftUI

struct MovieListView: View {
    @StateObject private var viewModel = MovieViewModel()
    @State private var searchText = ""
    @State private var sortOption: SortOption = .none
    
    enum SortOption: String, CaseIterable, Identifiable {
        case none = "Default"
        case priceLowToHigh = "Price: Low to High"
        case priceHighToLow = "Price: High to Low"
        
        var id: String { self.rawValue }
    }
    
    // Grid için 2 sütun
    let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    // Filtre + sıralama
    var filteredMovies: [Movie] {
        var movies = viewModel.movies
        
        // Arama
        if !searchText.isEmpty {
            movies = movies.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.director.localizedCaseInsensitiveContains(searchText) ||
                $0.category.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // Sıralama
        switch sortOption {
        case .priceLowToHigh:
            movies = movies.sorted { $0.price < $1.price }
        case .priceHighToLow:
            movies = movies.sorted { $0.price > $1.price }
        case .none:
            break
        }
        
        return movies
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                
                Picker("Sort", selection: $sortOption) {
                    ForEach(SortOption.allCases) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(filteredMovies) { movie in
                            NavigationLink(destination: MovieDetailView(movie: movie)) {
                                VStack(alignment: .leading, spacing: 8) {
                                    AsyncImage(url: URL(string: "http://kasimadalan.pe.hu/movies/images/\(movie.image)")) { image in
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(height: 200)
                                            .cornerRadius(10)
                                    } placeholder: {
                                        Rectangle()
                                            .fill(Color.gray.opacity(0.3))
                                            .frame(height: 200)
                                            .cornerRadius(10)
                                            .overlay(ProgressView())
                                    }
                                    
                                    Text(movie.name)
                                        .font(.headline)
                                        .lineLimit(1)
                                        .foregroundColor(.black)
                                    
                                    Text("$\(movie.price)")
                                        .font(.subheadline)
                                        .foregroundColor(.green)
                                }
                                .padding(8)
                                .background(Color(.systemBackground))
                                .cornerRadius(10)
                                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                            }
                        }
                    }
                    .padding()
                }
            }
            
            .onAppear {
                viewModel.fetchMovies()
            }
            .searchable(text: $searchText, prompt: "Search movies...")
        }
    }
}
