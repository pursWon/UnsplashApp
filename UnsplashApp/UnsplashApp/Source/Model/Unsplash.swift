import Foundation

struct Unsplash: Decodable {
    let description: String?
    let urls: PhotoSize
}

struct PhotoSize: Decodable {
    let regular: String
}
