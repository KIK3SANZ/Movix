import Foundation
import XCTest
@testable import Movix

class APIClientTests: XCTestCase {
    var sut: APIClient!
    let baseURL = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String ?? ""

    override func setUp() {
        super.setUp()
        sut = APIClient.shared
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testFetchPopularMovies_Success() {
        let expectation = self.expectation(description: "Completion handler called")
        let movieAPI = MovieAPI(apiClient: sut)

        movieAPI.fetchPopularMovies(page: 1) { result in
            switch result {
            case .success(let movies):
                XCTAssertGreaterThan(movies.count, 0, "Expected to receive some movies")
            case .failure(let error):
                XCTFail("Expected success but got failure with error: \(error)")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testFetchPopularMovies_Failure() {
        let expectation = self.expectation(description: "Completion handler called")
        let movieAPI = MovieAPI(apiClient: sut)

        let mockSession = URLSession(configuration: .default)
        sut = APIClient(session: mockSession, token: "tokenfalse")
        movieAPI.apiClient = sut

        movieAPI.fetchPopularMovies(page: 0) { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error as NSError):
                XCTAssertEqual(error.domain, "HTTPError")
                XCTAssertEqual(error.code, 401, "Expected error code to be 401")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
    }

    func testFetchMovieDetails_Success() {
        let expectation = self.expectation(description: "Completion handler called")
        let movieAPI = MovieAPI(apiClient: sut)
        let movieId = 573435

        movieAPI.fetchMovieDetails(movieId: movieId) { result in
            switch result {
            case .success(let movie):
                XCTAssertEqual(movie.id, movieId, "Expected to receive the movie with the specified ID")
            case .failure(let error):
                XCTFail("Expected success but got failure with error: \(error)")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testFetchMovieDetails_HTTPError() {
        let expectation = self.expectation(description: "Completion handler called")

        let movieAPI = MovieAPI(apiClient: sut)
        
        // Usa un ID de película inexistente para provocar un error 404
        let movieId = -1
        
        movieAPI.fetchMovieDetails(movieId: movieId) { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error as NSError):
                XCTAssertEqual(error.domain, "HTTPError")
                XCTAssertEqual(error.code, 404, "Expected error code to be 404")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
    }
}
