import SwiftUI

public struct TaskListView: View {
    @EnvironmentObject private var store: StudyDataStore
    @State private var selectedStatus: TaskStatus? = nil
    @State private var selectedPriority: TaskPriority? = nil

    public init() {}

    public var body: some View {
        NavigationStack {
            List {
                filtersSection
                ForEach(filteredTasks) { task in
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(task.title)
                                .font(.headline)
                            Spacer()
                            Text(task.priority.title)
                                .font(.caption)
                                .foregroundStyle(priorityColor(for: task.priority))
                        }
                        Text(task.subject.name)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        if let dueDate = task.dueDate {
                            Label(dueDate.formatted(date: .abbreviated, time: .shortened), systemImage: "calendar")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Text(task.details)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                        statusTag(for: task.status)
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("Tarefas")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        addQuickTask()
                    } label: {
                        Label("Nova tarefa", systemImage: "plus")
                    }
                }
            }
        }
    }

    private var filtersSection: some View {
        Section("Filtros") {
            Picker("Status", selection: Binding<TaskStatus?>(
                get: { selectedStatus },
                set: { selectedStatus = $0 }
            )) {
                Text("Todos").tag(TaskStatus?.none)
                ForEach(TaskStatus.allCases) { status in
                    Text(status.title).tag(TaskStatus?.some(status))
                }
            }
            .pickerStyle(.segmented)

            Picker("Prioridade", selection: Binding<TaskPriority?>(
                get: { selectedPriority },
                set: { selectedPriority = $0 }
            )) {
                Text("Todas").tag(TaskPriority?.none)
                ForEach(TaskPriority.allCases) { priority in
                    Text(priority.title).tag(TaskPriority?.some(priority))
                }
            }
            .pickerStyle(.segmented)
        }
    }

    private var filteredTasks: [StudyTask] {
        store.tasks.filter { task in
            let statusMatches = selectedStatus.map { $0 == task.status } ?? true
            let priorityMatches = selectedPriority.map { $0 == task.priority } ?? true
            return statusMatches && priorityMatches
        }
    }

    private func statusTag(for status: TaskStatus) -> some View {
        Text(status.title)
            .font(.caption2)
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            .background(statusColor(for: status).opacity(0.15))
            .foregroundStyle(statusColor(for: status))
            .clipShape(Capsule())
    }

    private func statusColor(for status: TaskStatus) -> Color {
        switch status {
        case .pendente: return .orange
        case .emAndamento: return .blue
        case .concluida: return .green
        }
    }

    private func priorityColor(for priority: TaskPriority) -> Color {
        switch priority {
        case .baixa: return .green
        case .media: return .orange
        case .alta: return .red
        }
    }

    private func addQuickTask() {
        guard let subject = store.subjects.first else { return }
        let task = StudyTask(
            title: "Nova tarefa rápida",
            details: "Defina os detalhes e prazo dessa tarefa",
            subject: subject,
            dueDate: Date().addingTimeInterval(3600 * 24),
            priority: .media
        )
        store.add(task: task)
    }
}
