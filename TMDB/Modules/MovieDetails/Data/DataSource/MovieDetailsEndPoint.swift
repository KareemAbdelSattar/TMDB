import Foundation

struct MovieDetailsEndPoint {
    static func getMovieDetails(id: Int) -> EndPoint<MovieDetailsDTO> {
        EndPoint(
            path: "movie/\(id)",
            method: .GET
        )
    }
}
