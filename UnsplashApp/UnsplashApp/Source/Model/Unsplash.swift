import Foundation


struct Photos: Decodable {
    let urls: Size
}

struct Size: Decodable {
    let small: String
}
