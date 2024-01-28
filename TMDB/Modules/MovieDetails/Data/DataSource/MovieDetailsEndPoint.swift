import Foundation

struct MovieDetailsEndPoint {
    static func getMovieDetails(id: Int) -> EndPoint<MovieDetailsDTO> {
        EndPoint(
            path: "discover/movie/\(id)",
            method: .GET
        )
    }
}
