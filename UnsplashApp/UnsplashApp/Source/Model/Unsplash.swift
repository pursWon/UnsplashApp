import UIKit

struct PhotoData: Decodable {
    let data: [Photos]
}

struct Photos: Decodable {
    let description: String
    let urls: PhotoUrl
}

struct PhotoUrl: Decodable {
    let raw: String
}


