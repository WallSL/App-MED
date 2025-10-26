import SwiftUI

struct SessionsView: View {
    @EnvironmentObject private var store: StudyPlannerStore
    @State private var activeSession: StudySession?
    @State private var showTimer = false

    private var upcomingSessions: [StudySession] {
        store.sessions
            .filter { $0.scheduledDate >= Calendar.current.startOfDay(for: Date()) }
            .filter { $0.completedMinutes == nil }
            .sorted { $0.scheduledDate < $1.scheduledDate }
    }

    private var completedSessions: [StudySession] {
        store.sessions
            .filter { $0.completedMinutes != nil }
            .sorted { $0.scheduledDate > $1.scheduledDate }
    }

    var body: some View {
        NavigationView {
            List {
                if !upcomingSessions.isEmpty {
                    Section(header: Text("Próximas sessões")) {
                        ForEach(upcomingSessions) { session in
                            SessionRow(session: session) {
                                activeSession = session
                                showTimer = true
                            }
                        }
                    }
                }

                Section(header: Text("Histórico recente")) {
                    if completedSessions.isEmpty {
                        Text("Finalize sessões para acompanhar seu tempo de estudo.")
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(completedSessions.prefix(5)) { session in
                            CompletedSessionRow(session: session)
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Sessões")
            .sheet(isPresented: $showTimer) {
                if let session = activeSession {
                    SessionTimerView(session: session, completionHandler: handleSessionCompletion(minutes:notes:))
                        .presentationDetents([.medium, .large])
                }
            }
        }
    }

    private func handleSessionCompletion(minutes: Int, notes: String) {
        guard var session = activeSession else { return }
        session.completedMinutes = minutes
        session.reflections = notes
        store.schedule(session: session)
        activeSession = nil
        showTimer = false
    }
}

private struct SessionRow: View {
    var session: StudySession
    var startAction: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                SubjectIcon(color: session.subject.accentColor, systemImage: session.subject.icon)
                VStack(alignment: .leading) {
                    Text(session.goal)
                        .font(.headline)
                    Text(StudyFormatters.dateFormatter.string(from: session.scheduledDate))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
            Button(action: startAction) {
                Label("Iniciar sessão", systemImage: "play.circle")
            }
            .buttonStyle(.borderedProminent)
            .tint(session.subject.accentColor)
        }
        .padding(.vertical, 4)
    }
}

private struct CompletedSessionRow: View {
    var session: StudySession

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(session.goal)
                .font(.headline)
            HStack {
                Text(session.subject.name)
                Spacer()
                Text("\(session.completedMinutes ?? 0) min")
            }
            .font(.caption)
            .foregroundColor(.secondary)
            if let reflections = session.reflections, !reflections.isEmpty {
                Text(reflections)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
