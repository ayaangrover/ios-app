import Foundation

struct Article: Identifiable, Codable {
    let id = UUID()
    let title: String
    let abstract: String
    let url: String
    let multimedia: [Media]?
    
    private enum CodingKeys: String, CodingKey {
        case title, abstract, url, multimedia
    }
}

struct Media: Codable {
    let url: String
    let format: String
}
