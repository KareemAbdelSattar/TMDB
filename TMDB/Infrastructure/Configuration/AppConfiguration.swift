import Foundation
import Factory

final class AppConfiguration {
    static let shared = AppConfiguration()
    
    @Injected(\.config) private var config: Configuration
    
    var baseURL: String {
        config.value(.baseURL)
    }
    
    var apiKey: String {
        "fb99f7adb34fb6386f72a3b6ca654295"
    }
}
