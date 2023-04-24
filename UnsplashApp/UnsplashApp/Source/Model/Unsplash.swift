import Foundation


struct Photos: Decodable {
    let alt_description: String?
    let urls: Size
}

struct Size: Decodable {
    let regular: String
}
