import SwiftUI

struct TaskPlannerView: View {
    @EnvironmentObject private var store: StudyPlannerStore
    @State private var filter: TaskStatus? = nil

    private var filteredTasks: [StudyTask] {
        if let filter {
            return store.tasks.filter { $0.status == filter }
        }
        return store.tasks
    }

    var body: some View {
        NavigationView {
            List {
                Section {
                    Picker("Filtro", selection: Binding(get: {
                        filter?.id ?? "Todos"
                    }, set: { newValue in
                        if newValue == "Todos" {
                            filter = nil
                        } else {
                            filter = TaskStatus(rawValue: newValue)
                        }
                    })) {
                        Text("Todos").tag("Todos")
                        ForEach(TaskStatus.allCases) { status in
                            Text(status.label).tag(status.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                ForEach(groupedBySubject(), id: \.key.id) { entry in
                    Section(header: SubjectHeader(subject: entry.key, pendingCount: entry.value.filter { $0.status != .done }.count)) {
                        ForEach(entry.value) { task in
                            TaskRow(task: task) {
                                store.recordCompletion(for: task.id)
                            }
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Planejamento")
        }
    }

    private func groupedBySubject() -> [(key: Subject, value: [StudyTask])] {
        let dictionary = Dictionary(grouping: filteredTasks) { $0.subject }
        return dictionary.sorted { lhs, rhs in lhs.key.name < rhs.key.name }
    }
}

private struct SubjectHeader: View {
    var subject: Subject
    var pendingCount: Int

    var body: some View {
        HStack {
            SubjectIcon(color: subject.accentColor, systemImage: subject.icon)
            Text(subject.name)
                .font(.headline)
            Spacer()
            if pendingCount > 0 {
                Text("\(pendingCount) pendentes")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

private struct TaskRow: View {
    var task: StudyTask
    var completionHandler: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(task.title)
                    .font(.headline)
                Spacer()
                Text(task.status.label)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            if !task.details.isEmpty {
                Text(task.details)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            HStack {
                Text("Prazo: \(StudyFormatters.dateFormatter.string(from: task.dueDate))")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Button(action: completionHandler) {
                    Label("Concluir", systemImage: "checkmark.circle")
                }
                .buttonStyle(.bordered)
                .tint(task.subject.accentColor)
            }
        }
        .padding(.vertical, 4)
    }
}
