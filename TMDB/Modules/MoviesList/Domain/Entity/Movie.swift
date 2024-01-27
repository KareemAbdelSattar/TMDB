import Foundation

struct MoviesList {
    let page: Int
    let totalPage: Int
    let movies: [Movie]
}

struct Movie {
    let id: String
    let title: String
    let image: String
}
