import Foundation

struct MoviesList {
    let page: Int
    let totalPage: Int
    let movies: [Movie]
}

struct Movie {
    let id: Int
    let title: String
    let image: String
    let releaseDate: String
}
