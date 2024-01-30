import XCTest
@testable import TMDB

final class MoviesListDTOTests: XCTestCase {
    
    func testMapMoviesListDTOToDomain_OnSuccess_ReturnMoviesListEntity() {
        //Given
        let moviesDTO = [
            MovieDTO(id: 1, posterPath: "poster1", releaseDate: "2022-10-02", title: "title1"),
            MovieDTO(id: 2, posterPath: "poster2", releaseDate: "2023-10-02", title: "title2"),
            MovieDTO(id: 3, posterPath: "poster3", releaseDate: "2024-10-02", title: "title3")
        ]
        let moviesListDTO = MovieListDTO(
            page: 1,
            results: moviesDTO,
            totalPages: 5,
            totalResults: 10
        )
        
        //When
        let returnedResult = moviesListDTO.toDomain()
        
        //Then
   
        XCTAssertEqual(returnedResult.page, moviesListDTO.page)
        XCTAssertEqual(returnedResult.totalPage, moviesListDTO.totalPages)
        XCTAssertEqual(returnedResult.movies.count, moviesListDTO.results.count)

        for (index, movieDTO) in moviesListDTO.results.enumerated() {
            let movie = returnedResult.movies[index]
            XCTAssertEqual(movie.id, movieDTO.id)
            XCTAssertEqual(movie.title, movieDTO.title)
            XCTAssertEqual(movie.releaseDate, movieDTO.releaseDate)
            XCTAssertEqual(movie.image, movieDTO.posterPath)
        }
    }
    
    func testMapMoviesListDTOToDomain_OnSuccess_ReturnEmptyMovieListEntity() {
        //Given
        let moviesListDTO = MovieListDTO(
            page: 1,
            results: [],
            totalPages: 1,
            totalResults: 1
        )
        
        //When
        let returnedResult = moviesListDTO.toDomain()
        
        //Then
   
        XCTAssertEqual(returnedResult.page, moviesListDTO.page)
        XCTAssertEqual(returnedResult.totalPage, moviesListDTO.totalPages)
        XCTAssertTrue(returnedResult.movies.isEmpty)
    }
    
    func testMovieListDTODecoding_OnSuccess_DecodeJsonToMovieListDTO() {
        // Given
        let json = """
        {
            "page": 1,
            "results": [
                {"id": 1, "poster_path": "path1", "release_date": "2022-01-01", "title": "Title 1"}
            ],
            "total_pages": 10,
            "total_results": 100
        }
        """
        do {
            // When
            let data = json.data(using: .utf8)!
            let movieListDTO = try JSONDecoder().decode(MovieListDTO.self, from: data)
            
            //Then
            XCTAssertEqual(movieListDTO.page, 1)
            XCTAssertEqual(movieListDTO.totalPages, 10)
            XCTAssertEqual(movieListDTO.results.count, 1)
        } catch {
            XCTFail("Expected to decode success")
        }
    }
    
    func testMovieListDTODecoding_OnFail_CatchError() {
        //Given
        let json = """
        {
            "page": 1,
            "results": [
                {"id": "1", "poster_path": "path1", "release_date": "2022-01-01", "title": "Title 1"}
            ],
            "total_pages": 10,
            "total_results": 100
        }
        """
        //When
        let data = json.data(using: .utf8)!
        
        //Then
        XCTAssertThrowsError(try JSONDecoder().decode(MovieListDTO.self, from: data))
    }
    
    func testMovieDTODecoding_OnSuccess_DecodeJsonToMovieDTO() {
        //Given
        let json = """
        {
            "id": 1, "poster_path": "path1", "release_date": "2022-01-01", "title": "Title 1"
        }
        """
        
        do {
            //When
            let data = json.data(using: .utf8)!
            let movieDTO = try JSONDecoder().decode(MovieDTO.self, from: data)
            
            //Then
            XCTAssertEqual(movieDTO.id, 1)
            XCTAssertEqual(movieDTO.title, "Title 1")
            XCTAssertEqual(movieDTO.posterPath, "path1")
            XCTAssertEqual(movieDTO.releaseDate, "2022-01-01")
        } catch {
            XCTFail("Expected to decode success")
        }
    }
    
    func testMovieDTODecoding_OnFail_CatchError() {
        //Given
        let json = """
        {
            "id": "1", "poster_path": "path1", "release_date": "2022-01-01", "title": "Title 1"
        }
        """
        
        //When
        let data = json.data(using: .utf8)!
  
        //Then
        XCTAssertThrowsError(try JSONDecoder().decode(MovieDTO.self, from: data))
    }
}
