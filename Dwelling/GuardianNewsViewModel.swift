import Foundation

class GuardianNewsViewModel: ObservableObject {
    @Published var articles = [GuardianArticle]()
    @Published var currentPage = 1
    @Published var isLoading = false
    
    private let apiKey = "7260105f-68fb-49d0-8195-a630c31e57b2"
    private let pageSize = 50
    private let urlString = "https://content.guardianapis.com/search?order-by=newest&show-fields=thumbnail,headline,trailText&page-size="
    
    init() {
        fetchNews()
    }
    
    func fetchNews() {
        guard !isLoading else { return }
        isLoading = true
        
        let fullURLString = "\(urlString)\(pageSize)&page=\(currentPage)&api-key=\(apiKey)"
        guard let url = URL(string: fullURLString) else {
            print("Invalid URL")
            isLoading = false
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Failed to fetch data:", error)
                self.isLoading = false
                return
            }
            
            guard let data = data else {
                print("No data received")
                self.isLoading = false
                return
            }
            
            do {
                let result = try JSONDecoder().decode(GuardianNewsResponse.self, from: data)
                DispatchQueue.main.async {
                    self.articles.append(contentsOf: result.response.results)
                    self.currentPage += 1
                    self.isLoading = false
                }
            } catch {
                print("Failed to decode JSON:", error)
                self.isLoading = false
            }
        }.resume()
    }
}

struct GuardianNewsResponse: Codable {
    let response: GuardianResponse
}

struct GuardianResponse: Codable {
    let results: [GuardianArticle]
}

struct GuardianArticle: Identifiable, Codable, Equatable {
    let id: String
    let webTitle: String
    let fields: GuardianFields?
    let webUrl: String
    
    var identifier: UUID {
        return UUID()
    }
    
    static func == (lhs: GuardianArticle, rhs: GuardianArticle) -> Bool {
        return lhs.id == rhs.id
    }
}

struct GuardianFields: Codable {
    let thumbnail: String?
    let trailText: String?
}
