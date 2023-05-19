import Foundation

struct Unsplash: Decodable {
    let alt_description: String?
    let urls: PhotoSize
}

struct PhotoSize: Decodable {
    let regular: String
}
