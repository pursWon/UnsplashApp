import Foundation

struct SearchData {
    let results: [Results]
}

struct Results {
    let tags: [Tags]
}

struct Tags {
    struct Source {
        let source: Information
    }
}

struct Information {
    let cover_photo: CoverPhoto
}

struct CoverPhoto {
    let urls: PhotoURL
}

struct PhotoURL {
    let regular: String
    let small: String
}
