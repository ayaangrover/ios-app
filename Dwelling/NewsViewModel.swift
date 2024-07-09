import Foundation

class NewsViewModel: ObservableObject {
    @Published var articles = [Article]()
    
    private let apiKey: String
    private let urlString: String
    
    init(apiKey: String, urlString: String) {
        self.apiKey = apiKey
        self.urlString = urlString
        fetchNews()
    }
    
    func fetchNews() {
        guard let url = URL(string: "\(urlString)\(apiKey)") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Failed to fetch data:", error)
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let result = try JSONDecoder().decode(NewsResponse.self, from: data)
                DispatchQueue.main.async {
                    self.articles = Array(result.results.prefix(50))
                }
            } catch {
                print("Failed to decode JSON: \(error)")
            }
        }.resume()
    }
}

struct NewsResponse: Codable {
    let results: [Article]
}
