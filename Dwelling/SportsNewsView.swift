import SwiftUI

struct SportsNewsView: View {
    @StateObject var viewModel = SportsNewsViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.articles) { article in
                VStack(alignment: .leading) {
                    if let imageUrl = article.urlToImage, let url = URL(string: imageUrl) {
                        AsyncImage(url: url)
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
                    if let description = article.description {
                        Text(description)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
            }
            .navigationTitle("Sports")
        }
        .onAppear {
            viewModel.fetchNews()
            // Print statement to check if the data is being fetched
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                print("Articles: \(viewModel.articles)")
            }
        }
    }
}

struct SportsNewsView_Previews: PreviewProvider {
    static var previews: some View {
        SportsNewsView()
    }
}
