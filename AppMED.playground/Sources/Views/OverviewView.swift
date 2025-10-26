import SwiftUI

struct OverviewView: View {
    @EnvironmentObject private var store: StudyPlannerStore

    private var todaysSessions: [StudySession] {
        store.sessions(for: Date())
    }

    private var pendingTasks: [StudyTask] {
        store.tasks.filter { $0.status != .done }.sorted { $0.dueDate < $1.dueDate }
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("Olá! Aqui está um panorama do seu estudo de medicina.")
                        .font(.title3)
                        .padding(.horizontal)

                    GoalsGrid(goals: store.goals)

                    if !todaysSessions.isEmpty {
                        SessionHighlights(sessions: todaysSessions)
                    }

                    if !pendingTasks.isEmpty {
                        TaskHighlights(tasks: Array(pendingTasks.prefix(3)))
                    }

                    ExamGradesOverview(grades: store.examGrades)
                }
                .padding(.bottom, 24)
            }
            .navigationTitle("Resumo semanal")
        }
    }
}

private struct GoalsGrid: View {
    var goals: [StudyGoal]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Metas da semana")
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                ForEach(goals) { goal in
                    GoalCard(goal: goal)
                }
            }
            .padding(.horizontal)
        }
    }
}

private struct GoalCard: View {
    var goal: StudyGoal

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(goal.kind.title)
                .font(.headline)
            ProgressView(value: goal.completion)
            Text("\(goal.progress) de \(goal.target)")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 16).fill(Color(.secondarySystemBackground)))
    }
}

private struct SessionHighlights: View {
    var sessions: [StudySession]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Sessões de hoje")
            ForEach(sessions) { session in
                HStack {
                    SubjectIcon(color: session.subject.accentColor, systemImage: session.subject.icon)
                    VStack(alignment: .leading) {
                        Text(session.goal)
                            .font(.headline)
                        Text(session.subject.name)
                            .foregroundColor(.secondary)
                        Text("\(session.plannedMinutes) minutos")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Text(StudyFormatters.timeFormatter.string(from: session.scheduledDate))
                        .font(.subheadline)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 16).strokeBorder(session.subject.accentColor.opacity(0.3), lineWidth: 1))
                .padding(.horizontal)
            }
        }
    }
}

private struct TaskHighlights: View {
    var tasks: [StudyTask]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Próximas tarefas")
            ForEach(tasks) { task in
                HStack(alignment: .top, spacing: 12) {
                    SubjectIcon(color: task.subject.accentColor, systemImage: task.subject.icon)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(task.title)
                            .font(.headline)
                        if !task.details.isEmpty {
                            Text(task.details)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Text("Vence em \(StudyFormatters.shortDateFormatter.string(from: task.dueDate))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 16).fill(Color(.secondarySystemBackground)))
                .padding(.horizontal)
            }
        }
    }
}

private struct ExamGradesOverview: View {
    var grades: [ExamGrade]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Notas recentes")
            if grades.isEmpty {
                Text("Cadastre notas das provas e simulados para acompanhar sua evolução.")
                    .font(.callout)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
            } else {
                ForEach(grades.sorted(by: { $0.takenOn > $1.takenOn }).prefix(3)) { grade in
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(grade.name)
                                .font(.headline)
                            Spacer()
                            Text(String(format: "%.1f%%", grade.percentage))
                                .bold()
                        }
                        Text(grade.subject.name)
                            .foregroundColor(.secondary)
                        Text(StudyFormatters.dateFormatter.string(from: grade.takenOn))
                            .font(.caption)
                            .foregroundColor(.secondary)
                        if !grade.notes.isEmpty {
                            Text(grade.notes)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 16).fill(Color(.secondarySystemBackground)))
                    .padding(.horizontal)
                }
            }
        }
        .padding(.bottom)
    }
}

private struct SectionHeader: View {
    var title: String

    var body: some View {
        Text(title)
            .font(.title2)
            .fontWeight(.semibold)
            .padding(.horizontal)
    }
}

// SubjectIcon is declared in SharedComponents.swift and reutilizado nas telas.
