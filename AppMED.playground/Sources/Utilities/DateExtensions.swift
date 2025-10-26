import Foundation

extension Date {
    public func formatted(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.dateFormat = format
        return formatter.string(from: self)
    }

    public var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
}

extension DateInterval {
    public static func thisWeek() -> DateInterval {
        let calendar = Calendar.current
        let now = Date()
        let weekOfYear = calendar.component(.weekOfYear, from: now)
        let yearForWeekOfYear = calendar.component(.yearForWeekOfYear, from: now)
        var components = DateComponents()
        components.weekOfYear = weekOfYear
        components.yearForWeekOfYear = yearForWeekOfYear
        let start = calendar.date(from: components) ?? now.startOfDay
        let end = calendar.date(byAdding: .day, value: 7, to: start) ?? now
        return DateInterval(start: start, end: end)
    }
}
