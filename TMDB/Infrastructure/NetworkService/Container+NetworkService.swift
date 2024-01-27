import Foundation
import Factory

extension Container {
    var appConfig: Factory<AppConfiguration> {
        self { .shared }
    }
    
    var config: Factory<NetworkConfigurable> {
        self {
            guard let baseURL = URL(string: self.appConfig().value(.baseURL)) else {
                return DefaultNetworkConfigurable(
                    baseURL: URL(string: "https://default.url")!,
                    isFullPath: false,
                    headers: ["Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJmYjk5ZjdhZGIzNGZiNjM4NmY3MmEzYjZjYTY1NDI5NSIsInN1YiI6IjY1YjUyYTI1YjExMzFmMDE3MjI5MjYwNiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.Eqk3iIks3uHixyU0cl76iDHU5tcIFyoRx31Q2B9LOhE"]
                )
            }
            return DefaultNetworkConfigurable(
                baseURL: baseURL,
                isFullPath: false,
                headers: ["Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJmYjk5ZjdhZGIzNGZiNjM4NmY3MmEzYjZjYTY1NDI5NSIsInN1YiI6IjY1YjUyYTI1YjExMzFmMDE3MjI5MjYwNiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.Eqk3iIks3uHixyU0cl76iDHU5tcIFyoRx31Q2B9LOhE"]
            ) }
    }
    
    var networkService: Factory<NetworkService> {
        self { DefaultNetworkService(config: self.config()) }
    }
    
    var sessions: Factory<NetworkSessionManager> {
        self { DefaultNetworkSessionManager() }
    }
    
    var dataTransferErrorResolver: Factory<DataTransferErrorResolver> {
        self { DefaultDataTransferErrorResolver() }
    }
    
    var dataTransferService: Factory<DataTransferService> {
        self { DefaultDataTransferService() }
    }
}
