import SwiftUI

struct GuardianNewsView: View {
    @StateObject var viewModel = GuardianNewsViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.articles) { article in
                    VStack(alignment: .leading) {
                        if let thumbnail = article.fields?.thumbnail, let url = URL(string: thumbnail) {
                            AsyncImage(url: url)
                                .aspectRatio(contentMode: .fit)
                        } else {
                            Text("No Image Available")
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, minHeight: 200)
                                .background(Color.gray.opacity(0.1))
                        }
                        Link(destination: URL(string: article.webUrl)!) {
                            Text(article.webTitle)
                                .font(.headline)
                                .foregroundColor(.blue) // Optional: Change the color to indicate it's a link
                        }
                        if let trailText = article.fields?.trailText {
                            Text(trailText)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .onAppear {
                        if article == viewModel.articles.last {
                            viewModel.fetchNews()
                        }
                    }
                }
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .navigationTitle("The Guardian")
        }
        .onAppear {
            viewModel.fetchNews()
        }
    }
}

struct GuardianNewsView_Previews: PreviewProvider {
    static var previews: some View {
        GuardianNewsView()
    }
}
