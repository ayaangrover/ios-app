import Foundation

class SportsNewsViewModel: ObservableObject {
    @Published var articles = [SportsArticle]()
    
    private let apiKey = "b2f8516bddfc4d18bd602d4a080ec227"
    private let urlString = "https://newsapi.org/v2/top-headlines?category=sports&language=en&apiKey="
    
    init() {
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
                // Log the raw JSON response
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                    print("Raw JSON response: \(json)")
                }
                
                let result = try JSONDecoder().decode(SportsNewsResponse.self, from: data)
                DispatchQueue.main.async {
                    self.articles = result.articles
                }
            } catch {
                print("Failed to decode JSON:", error)
            }
        }.resume()
    }
}

struct SportsNewsResponse: Codable {
    let articles: [SportsArticle]
}

struct SportsArticle: Identifiable, Codable {
    let id = UUID()
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
}
