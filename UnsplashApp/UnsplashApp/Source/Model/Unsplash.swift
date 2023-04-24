import Foundation

struct Photos: Decodable {
    let alt_description: String?
    let urls: Size
}

struct PhotoSize: Decodable {
    let regular: String
}
