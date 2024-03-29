import Foundation

struct Configuration {
    
    static let shared = Configuration()

    private init() {}
    
    enum Keys: String {
        case baseURL = "BASE_URL"
        case imageURL = "IMAGE_URL"
    }
    
    func value(_ key: Keys) -> String {
        guard let value = Bundle.main.infoDictionary?[key.rawValue] as? String else {
            fatalError("the key: \(key.rawValue) not found")
        }
        
        return value
    }
}
