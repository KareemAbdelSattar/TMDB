import Foundation
import Factory

final class AppConfiguration {
    static let shared = AppConfiguration()
    
    @Injected(\.config) private var config: Configuration
    
    var baseURL: String {
        config.value(.baseURL)
    }
    
    var apiKey: String {
        "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJmYjk5ZjdhZGIzNGZiNjM4NmY3MmEzYjZjYTY1NDI5NSIsInN1YiI6IjY1YjUyYTI1YjExMzFmMDE3MjI5MjYwNiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.Eqk3iIks3uHixyU0cl76iDHU5tcIFyoRx31Q2B9LOhE"
    }
}
