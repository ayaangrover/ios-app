import SwiftUI

struct NYTView: View {
    @StateObject var viewModel = NewsViewModel(apiKey: "API KEY", urlString: "https://api.nytimes.com/svc/topstories/v2/home.json?api-key=")
    
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
                    Link(destination: URL(string: article.url)!) {
                        Text(article.title)
                            .font(.headline)
                            .foregroundColor(.blue) // Optional: Change the color to indicate it's a link
                    }
                    Text(article.abstract)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding()
            }
            .navigationTitle("New York Times")
        }
        .onAppear {
            viewModel.fetchNews()
        }
    }
}

struct NYTView_Previews: PreviewProvider {
    static var previews: some View {
        NYTView()
    }
}
