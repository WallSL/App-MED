import SwiftUI

public struct CalendarView: View {
    @EnvironmentObject private var store: StudyDataStore

    public init() {}

    public var body: some View {
        NavigationStack {
            List {
                ForEach(sortedDates, id: \.self) { date in
                    Section(date.formatted(date: .abbreviated, time: .omitted)) {
                        ForEach(store.sessions(for: date)) { session in
                            VStack(alignment: .leading, spacing: 6) {
                                Text(session.subject.name)
                                    .font(.headline)
                                if let task = session.task {
                                    Text(task.title)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                                HStack {
                                    Label(session.plannedStart.formatted(date: .omitted, time: .shortened), systemImage: "clock")
                                    Label("\(Int(session.plannedDuration / 60)) min", systemImage: "timer")
                                }
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                if !session.notes.isEmpty {
                                    Text(session.notes)
                                        .font(.caption)
                                }
                            }
                            .padding(.vertical, 8)
                        }
                    }
                }
            }
            .navigationTitle("Agenda de sessões")
        }
    }

    private var sortedDates: [Date] {
        store.upcomingSessionsByDay.keys.sorted()
    }
}
