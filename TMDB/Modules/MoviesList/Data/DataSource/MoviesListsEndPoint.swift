import Foundation

struct MoviesListsEndPoint {
    static func getMoviesList(page: Int) -> EndPoint<MovieListDTO> {
        EndPoint(
            path: "discover/movie",
            method: .GET,
            queryParameters: [
                "page": page
            ]
        )
    }
}
