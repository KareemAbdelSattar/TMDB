import Foundation

struct HTTPMethod: RawRepresentable, Hashable, Equatable {
    static let GET = HTTPMethod(rawValue: "GET")
    static let POST = HTTPMethod(rawValue: "POST")

    let rawValue: String

    init(rawValue: String) {
        self.rawValue = rawValue
    }
}
