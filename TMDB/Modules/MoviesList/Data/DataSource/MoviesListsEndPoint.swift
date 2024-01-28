import Foundation

struct MoviesListsEndPoint {
    static func getMoviesList() -> EndPoint<ProductListDTO> {
        EndPoint(
            path: "discover/movie",
            method: .GET
        )
    }
}
