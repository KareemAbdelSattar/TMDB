import Foundation

final class DateUtils {
    private let dateFormatter: DateFormatter = {
          let formatter = DateFormatter()
          return formatter
      }()
    
   static func parseDate(from dateString: String, format: String = "yyyy-MM-dd") -> Date? {
        MoviesListViewModel.dateFormatter.dateFormat = format
        return MoviesListViewModel.dateFormatter.date(from: dateString)
    }
    
    static func extractYear(from date: Date?) -> String {
        guard let date else { return "Unknown" }
        MoviesListViewModel.dateFormatter.dateFormat = "yyyy"
        return MoviesListViewModel.dateFormatter.string(from: date)
    }
}
