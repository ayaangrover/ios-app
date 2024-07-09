import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = NewsViewModel(apiKey: "DYGdeGsK3PoebT5s9vGguTWMwZQxXGS4", urlString: "https://api.nytimes.com/svc/topstories/v2/home.json?api-key=")
    
    var body: some View {
        NavigationView {
            List(viewModel.articles) { article in
                VStack(alignment: .leading) {
                    if let multimedia = article.multimedia?.first?.url {
                        AsyncImage(url: URL(string: multimedia))
                            .aspectRatio(contentMode: .fit)
                    } else {
                        Text("No Image Available")
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, minHeight: 200)
                            .background(Color.gray.opacity(0.1))
                    }
                    Text(article.title)
                        .font(.headline)
                    Text(article.abstract)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding()
            }
            .navigationTitle("Top Headlines")
        }
        .onAppear {
            viewModel.fetchNews()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
