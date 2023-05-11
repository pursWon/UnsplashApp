import Foundation

struct Search {
    let results: [Results]
}

struct Results {
    let description: String?
    let urls: Urls
}

struct Urls {
    let regular: String
}
