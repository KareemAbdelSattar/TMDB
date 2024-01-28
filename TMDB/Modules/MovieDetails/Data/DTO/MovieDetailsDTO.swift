import Foundation

struct MovieDetailsDTO: Codable {
    let id: Int
    let originalTitle, overview: String
    let posterPath: String
    let releaseDate: String

    enum CodingKeys: String, CodingKey {
        case id
        case originalTitle = "original_title"
        case overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
    }
}

extension MovieDetailsDTO {
    func toDomain() -> MovieDetails {
        MovieDetails(
            id: id,
            title: originalTitle,
            year: releaseDate,
            overview: overview,
            poster: posterPath
        )
    }
}
