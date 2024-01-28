import Foundation

struct ProductListDTO: Decodable {
    let page: Int
    let results: [ProductDTO]
    let totalPages, totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

extension ProductListDTO {
    func toDomain() -> MoviesList {
        return MoviesList(
            page: page,
            totalPage: totalPages,
            movies: results.map { $0.toDomain() }
        )
    }
}


struct ProductDTO: Codable {
    let id: Int
    let posterPath, releaseDate, title: String

    enum CodingKeys: String, CodingKey {
        case id
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
    }
}

extension ProductDTO {
    func toDomain() -> Movie {
        Movie(
            id: id,
            title: title,
            image: posterPath,
            releaseDate: releaseDate
        )
    }
}
