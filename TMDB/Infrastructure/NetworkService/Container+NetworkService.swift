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
                    headers: ["Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwNDI1ZTRkZDNhNzJmODMxZGNmNmNmYTQ1NmQyNTZjMiIsInN1YiI6IjYzN2Y1ZmI0YTRhZjhmMDA5N2JlZTI2MiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.x-NuPpCDErSOt2NXGK8IN7O4qxj-Rrywo1wQpXO08pM"]
                )
            }
            return DefaultNetworkConfigurable(baseURL: baseURL, isFullPath: false) }
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
