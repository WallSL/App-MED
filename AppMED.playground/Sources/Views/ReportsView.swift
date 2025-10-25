import SwiftUI

public struct ReportsView: View {
    @EnvironmentObject private var store: StudyDataStore
    @State private var selectedSubject: Subject?

    public init() {}

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    summaryCards
                    gradeEvolution
                    workloadBreakdown
                    goalsOverview
                }
                .padding()
            }
            .navigationTitle("Relatórios e notas")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("Todas as disciplinas") { selectedSubject = nil }
                        ForEach(store.subjects) { subject in
                            Button(subject.name) { selectedSubject = subject }
                        }
                    } label: {
                        Label(selectedSubject?.name ?? "Filtro", systemImage: "line.3.horizontal.decrease.circle")
                    }
                }
            }
        }
    }

    private var summaryCards: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Indicadores principais")
                .font(.headline)
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                SummaryCard(title: "Horas na semana", value: String(format: "%.1f h", store.weeklyStudyHours), icon: "hourglass")
                SummaryCard(title: "Média geral", value: String(format: "%.0f%%", store.overallAverageGrade()), icon: "rosette")
                SummaryCard(title: "Tarefas pendentes", value: "\(store.tasks.count - store.completedTasks.count)", icon: "list.bullet")
                SummaryCard(title: "Sessões concluídas", value: "\(store.completedSessions.count)", icon: "checkmark.circle")
            }
        }
    }

    private var gradeEvolution: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Evolução das notas")
                .font(.headline)
            if filteredGrades.isEmpty {
                EmptyStateView(message: "Ainda não há notas registradas para o filtro atual.")
            } else {
                ForEach(filteredGrades.sorted(by: { $0.date > $1.date })) { grade in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(grade.title)
                                .font(.subheadline)
                            Text(grade.date.formatted(date: .abbreviated, time: .omitted))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Text(String(format: "%.1f / %.1f", grade.score, grade.maxScore))
                            .font(.headline)
                    }
                    .padding()
                    .background(Color(.systemBackground), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
                }
            }
        }
    }

    private var workloadBreakdown: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Distribuição de estudo")
                .font(.headline)
            if store.subjects.isEmpty {
                EmptyStateView(message: "Cadastre disciplinas para visualizar a distribuição de carga horária.")
            } else {
                ForEach(store.subjects) { subject in
                    let totalMinutes = store.sessions
                        .filter { $0.subject.id == subject.id }
                        .compactMap { $0.actualDuration ?? $0.plannedDuration }
                        .reduce(0, +) / 60
                    HStack {
                        VStack(alignment: .leading) {
                            Text(subject.name)
                                .font(.subheadline)
                            Text("\(Int(totalMinutes)) minutos")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        ProgressView(value: min(totalMinutes / 600, 1))
                            .frame(width: 160)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
    }

    private var goalsOverview: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Metas e progresso")
                .font(.headline)
            if store.goals.isEmpty {
                EmptyStateView(message: "Crie metas para acompanhar objetivos de horas, tarefas ou notas.")
            } else {
                ForEach(store.goals) { goal in
                    GoalProgressView(goal: goal)
                }
            }
        }
    }

    private var filteredGrades: [ExamGrade] {
        guard let subject = selectedSubject else {
            return store.grades
        }
        return store.grades.filter { $0.subject.id == subject.id }
    }
}

private struct SummaryCard: View {
    let title: String
    let value: String
    let icon: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(title, systemImage: icon)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.title2)
                .fontWeight(.semibold)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

private extension StudyDataStore {
    var completedTasks: [StudyTask] {
        tasks.filter { $0.status == .concluida }
    }

    var completedSessions: [StudySession] {
        sessions.filter { $0.actualEnd != nil }
    }
}
