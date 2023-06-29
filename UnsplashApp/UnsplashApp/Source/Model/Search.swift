import Foundation

struct Search: Decodable {
    let results: [Result]
}

struct Result: Decodable {
    let description: String?
    let urls: Urls
}

struct Urls: Decodable {
    let thumb: String
}