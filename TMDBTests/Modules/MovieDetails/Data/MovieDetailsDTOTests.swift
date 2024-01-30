import XCTest
@testable import TMDB

final class MovieDetailsDTOTests: XCTestCase {
    
    func testMapMovieDetailsDTOToDomain_OnSuccess_ReturnMovieDetailsEntity() {
        //Give
        let movieDetailDTO = MovieDetailsDTO(id: 1, originalTitle: "title1", overview: "overview", posterPath: "poster", releaseDate: "2008-02-05")
        
        //When
        let returnedResult = movieDetailDTO.toDomain()
        
        //Then
        XCTAssertEqual(returnedResult.id, movieDetailDTO.id)
        XCTAssertEqual(returnedResult.title, movieDetailDTO.originalTitle)
        XCTAssertEqual(returnedResult.poster, movieDetailDTO.posterPath)
        XCTAssertEqual(returnedResult.overview, movieDetailDTO.overview)
        XCTAssertEqual(returnedResult.year, movieDetailDTO.releaseDate)
    }
    
    func testMapMovieDetailsDTODecoding_OnSuccess_DecodeJsonToMovieDetails() {
        //Give
        let json = """
        {
            "id": 1,
            "poster_path": "path1",
            "release_date": "2022-01-01",
            "original_title": "Title 1",
            "overview": "overview"
        }
        """
        
        do {
            //When
            let data = json.data(using: .utf8)!
            let movieDetailsDTO = try JSONDecoder().decode(MovieDetailsDTO.self, from: data)
            
            //Then
            XCTAssertEqual(movieDetailsDTO.id, 1)
            XCTAssertEqual(movieDetailsDTO.originalTitle, "Title 1")
            XCTAssertEqual(movieDetailsDTO.posterPath, "path1")
            XCTAssertEqual(movieDetailsDTO.overview, "overview")
            XCTAssertEqual(movieDetailsDTO.releaseDate, "2022-01-01")
        } catch {
            XCTFail("Expected to decode success")
        }
    }
    
    
    func testMapMovieDetailsDTODecoding_OnFail_CatchError() {
        //Give
        let json = """
        {
            "id": "1",
            "poster_path": "path1",
            "release_date": "2022-01-01",
            "original_title": "Title 1",
            "overview": "overview"
        }
        """
        
        //When
        let data = json.data(using: .utf8)!
        
        //Then
        XCTAssertThrowsError(try JSONDecoder().decode(MovieDetailsDTO.self, from: data))
    }
}
