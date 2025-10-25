import Foundation

public extension StudyDataStore {
    var tasksDueToday: [StudyTask] {
        tasks.filter { task in
            guard let dueDate = task.dueDate else { return false }
            return Calendar.current.isDateInToday(dueDate)
        }
    }

    var priorityTasks: [StudyTask] {
        tasks.filter { $0.priority == .alta && $0.status != .concluida }
            .sorted { first, second in
                switch (first.dueDate, second.dueDate) {
                case let (lhs?, rhs?):
                    return lhs < rhs
                case (nil, _?):
                    return false
                case (_?, nil):
                    return true
                default:
                    return first.title < second.title
                }
            }
    }

    var weeklyStudyHours: Double {
        let interval = DateInterval.thisWeek()
        let totalSeconds = sessions
            .filter { interval.contains($0.plannedStart) }
            .compactMap { $0.actualDuration ?? $0.plannedDuration }
            .reduce(0, +)
        return totalSeconds / 3600
    }

    var upcomingSessionsByDay: [Date: [StudySession]] {
        let grouped = Dictionary(grouping: sessions) { session in
            session.plannedStart.startOfDay
        }
        return grouped.mapValues { $0.sorted(by: { $0.plannedStart < $1.plannedStart }) }
    }
}
