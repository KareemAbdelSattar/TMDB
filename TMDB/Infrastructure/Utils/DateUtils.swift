import Foundation

final class DateUtils {
    static let dateFormatter: DateFormatter = {
          let formatter = DateFormatter()
          return formatter
      }()
    
   static func parseDate(from dateString: String, format: String = "yyyy-MM-dd") -> Date? {
       DateUtils.dateFormatter.dateFormat = format
        return DateUtils.dateFormatter.date(from: dateString)
    }
    
    static func extractYear(from date: Date?) -> String {
        guard let date else { return "Unknown" }
        DateUtils.dateFormatter.dateFormat = "yyyy"
        return DateUtils.dateFormatter.string(from: date)
    }
}
