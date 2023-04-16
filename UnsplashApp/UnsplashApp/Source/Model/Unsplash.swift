import Foundation

struct PhotoData: Decodable {
    let data: [Photos]
}

struct Photos: Decodable {
    let id: String
    let urls: Size
}

struct Size: Decodable {
    let small: String
}



