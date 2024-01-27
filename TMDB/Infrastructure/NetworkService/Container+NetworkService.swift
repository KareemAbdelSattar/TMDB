import Foundation
import Factory

extension Container {
    var config: Factory<Configuration> {
        self { .shared }
    }
    
    var appConfig: Factory<AppConfiguration> {
        self { .shared }
    }
    
    var networkConfig: Factory<NetworkConfigurable> {
        self {
            guard let baseURL = URL(string: self.appConfig().baseURL) else {
                return DefaultNetworkConfigurable(
                    baseURL: URL(string: "https://default.url")!,
                    isFullPath: false
                )
            }
            return DefaultNetworkConfigurable(
                baseURL: baseURL,
                isFullPath: false,
                headers: [
                    "Authorization": self.appConfig().apiKey
                ]
            ) }
    }
    
    var networkService: Factory<NetworkService> {
        self { DefaultNetworkService(config: self.networkConfig()) }
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
