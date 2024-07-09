import SwiftUI

struct AsyncImage: View {
    @StateObject private var loader: ImageLoader
    private let placeholder: Image

    init(url: URL?, placeholder: Image = Image(systemName: "photo")) {
        _loader = StateObject(wrappedValue: ImageLoader(url: url))
        self.placeholder = placeholder
    }

    var body: some View {
        image
            .onAppear {
                loader.load()
            }
            .clipShape(RoundedRectangle(cornerRadius: 10)) // Rounded corners
//            .shadow(radius: 5) // Shadow
            .padding(.vertical, 10) // Padding to add some space around the image
    }

    private var image: some View {
        Group {
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                placeholder
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
        }
    }
}

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private let url: URL?

    init(url: URL?) {
        self.url = url
    }

    func load() {
        guard let url = url else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Failed to load image:", error)
                return
            }

            guard let data = data, let image = UIImage(data: data) else {
                print("No image data")
                return
            }

            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}
