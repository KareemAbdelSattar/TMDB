import Foundation

struct MoviesListsEndPoint {
    static func getMoviesList() -> EndPoint<MovieListDTO> {
        EndPoint(
            path: "discover/movie",
            method: .GET
        )
    }
}
