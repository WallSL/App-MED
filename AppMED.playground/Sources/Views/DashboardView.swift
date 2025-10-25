import SwiftUI

public struct DashboardView: View {
    @EnvironmentObject private var store: StudyDataStore

    public init() {}

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    headerSection
                    todaysSessionsSection
                    tasksSection
                    goalsSection
                    gradesSection
                }
                .padding()
            }
            .navigationTitle("Resumo do dia")
        }
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Olá! Vamos organizar seus estudos?")
                .font(.title2)
                .fontWeight(.semibold)
            Text("Você tem \(store.sessions(for: Date()).count) sessão(ões) planejadas hoje e \(store.tasksDueToday.count) tarefas para revisar.")
                .font(.callout)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private var todaysSessionsSection: some View {
        DashboardSection(title: "Sessões de hoje", systemImage: "timer") {
            if store.sessions(for: Date()).isEmpty {
                EmptyStateView(message: "Nenhuma sessão agendada para hoje. Planeje uma nova sessão para manter o ritmo!")
            } else {
                ForEach(store.sessions(for: Date())) { session in
                    SessionRowView(session: session)
                }
            }
        }
    }

    private var tasksSection: some View {
        DashboardSection(title: "Tarefas prioritárias", systemImage: "exclamationmark.circle") {
            if store.priorityTasks.isEmpty {
                EmptyStateView(message: "Sem tarefas prioritárias. Aproveite para revisar conteúdos pendentes.")
            } else {
                ForEach(store.priorityTasks) { task in
                    TaskRowView(task: task)
                }
            }
        }
    }

    private var goalsSection: some View {
        DashboardSection(title: "Metas da semana", systemImage: "target") {
            if store.goals.isEmpty {
                EmptyStateView(message: "Defina metas semanais para acompanhar seu progresso.")
            } else {
                ForEach(store.goals) { goal in
                    GoalProgressView(goal: goal)
                }
            }
        }
    }

    private var gradesSection: some View {
        DashboardSection(title: "Notas recentes", systemImage: "rosette") {
            if store.grades.isEmpty {
                EmptyStateView(message: "Ainda não há notas registradas. Adicione os resultados das avaliações para gerar relatórios.")
            } else {
                ForEach(store.grades.sorted(by: { $0.date > $1.date }).prefix(3)) { grade in
                    GradeRowView(grade: grade)
                }
            }
        }
    }
}

private struct DashboardSection<Content: View>: View {
    let title: String
    let systemImage: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(title, systemImage: systemImage)
                .font(.headline)
            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct EmptyStateView: View {
    let message: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "sparkles")
                .foregroundStyle(.secondary)
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

private struct SessionRowView: View {
    let session: StudySession

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(session.subject.name)
                    .font(.headline)
                Spacer()
                Text(session.plannedStart.formatted(date: .omitted, time: .shortened))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            if let task = session.task {
                Text(task.title)
                    .font(.subheadline)
            }
            HStack {
                Label("\(Int(session.plannedDuration / 60)) min", systemImage: "clock")
                Label(session.technique.title, systemImage: "bolt")
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color(.systemBackground), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

private struct TaskRowView: View {
    let task: StudyTask

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(task.title)
                    .font(.headline)
                Spacer()
                Text(task.priority.title)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(priorityColor.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            }
            Text(task.subject.name)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            if let due = task.dueDate {
                Label(due.formatted(date: .abbreviated, time: .omitted), systemImage: "calendar")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }

    private var priorityColor: Color {
        switch task.priority {
        case .baixa: return .green
        case .media: return .orange
        case .alta: return .red
        }
    }
}

private struct GoalProgressView: View {
    let goal: Goal

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(goal.type.title)
                .font(.headline)
            ProgressView(value: goal.progressRatio)
            HStack {
                Text("Progresso: \(Int(goal.progressRatio * 100))%")
                Spacer()
                Text("Meta: \(Int(goal.targetValue))")
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color(.systemBackground), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

private struct GradeRowView: View {
    let grade: ExamGrade

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(grade.title)
                    .font(.headline)
                Spacer()
                Text(grade.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Text(grade.subject.name)
                .font(.subheadline)
            Text(String(format: "Nota: %.1f / %.1f (%.0f%%)", grade.score, grade.maxScore, grade.percentage))
                .font(.caption)
                .foregroundStyle(.secondary)
            if !grade.notes.isEmpty {
                Text(grade.notes)
                    .font(.caption)
            }
        }
        .padding()
        .background(Color(.systemBackground), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}
