import Foundation

struct MovieListDTO: Decodable {
    let page: Int
    let results: [MovieDTO]
    let totalPages, totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

extension MovieListDTO {
    func toDomain() -> MoviesList {
        return MoviesList(
            page: page,
            totalPage: totalPages,
            movies: results.map { $0.toDomain() }
        )
    }
}


struct MovieDTO: Codable {
    let id: Int
    let posterPath, releaseDate, title: String

    enum CodingKeys: String, CodingKey {
        case id
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
    }
}

extension MovieDTO {
    func toDomain() -> Movie {
        Movie(
            id: id,
            title: title,
            image: posterPath,
            releaseDate: releaseDate
        )
    }
}
