import SwiftUI
import Combine
import PlaygroundSupport

// MARK: - Models

struct Subject: Identifiable, Hashable {
    let id: UUID
    var name: String
    var category: String
    var accentColor: Color
    var icon: String

    init(id: UUID = UUID(), name: String, category: String, accentColor: Color, icon: String) {
        self.id = id
        self.name = name
        self.category = category
        self.accentColor = accentColor
        self.icon = icon
    }

    static func == (lhs: Subject, rhs: Subject) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

enum TaskStatus: String, CaseIterable, Identifiable, Codable {
    case planned
    case inProgress
    case done

    var id: String { rawValue }

    var label: String {
        switch self {
        case .planned: return "Planejada"
        case .inProgress: return "Em andamento"
        case .done: return "Concluída"
        }
    }

    var systemImage: String {
        switch self {
        case .planned: return "circle"
        case .inProgress: return "timer"
        case .done: return "checkmark.circle.fill"
        }
    }
}

struct StudyTask: Identifiable, Hashable {
    let id: UUID
    var title: String
    var details: String
    var subject: Subject
    var dueDate: Date
    var estimatedMinutes: Int
    var status: TaskStatus

    init(
        id: UUID = UUID(),
        title: String,
        details: String = "",
        subject: Subject,
        dueDate: Date,
        estimatedMinutes: Int,
        status: TaskStatus = .planned
    ) {
        self.id = id
        self.title = title
        self.details = details
        self.subject = subject
        self.dueDate = dueDate
        self.estimatedMinutes = estimatedMinutes
        self.status = status
    }
}

struct StudySession: Identifiable, Hashable {
    let id: UUID
    var subject: Subject
    var goal: String
    var scheduledDate: Date
    var plannedMinutes: Int
    var completedMinutes: Int?
    var reflections: String?

    init(
        id: UUID = UUID(),
        subject: Subject,
        goal: String,
        scheduledDate: Date,
        plannedMinutes: Int,
        completedMinutes: Int? = nil,
        reflections: String? = nil
    ) {
        self.id = id
        self.subject = subject
        self.goal = goal
        self.scheduledDate = scheduledDate
        self.plannedMinutes = plannedMinutes
        self.completedMinutes = completedMinutes
        self.reflections = reflections
    }
}

struct ExamGrade: Identifiable, Hashable {
    let id: UUID
    var subject: Subject
    var name: String
    var score: Double
    var maximumScore: Double
    var takenOn: Date
    var notes: String

    init(
        id: UUID = UUID(),
        subject: Subject,
        name: String,
        score: Double,
        maximumScore: Double,
        takenOn: Date,
        notes: String = ""
    ) {
        self.id = id
        self.subject = subject
        self.name = name
        self.score = score
        self.maximumScore = maximumScore
        self.takenOn = takenOn
        self.notes = notes
    }

    var percentage: Double {
        guard maximumScore > 0 else { return 0 }
        return (score / maximumScore) * 100
    }
}

struct StudyGoal: Identifiable, Hashable {
    enum Kind: String, CaseIterable, Identifiable {
        case hoursPerWeek
        case tasksPerWeek
        case revisionSessions

        var id: String { rawValue }

        var title: String {
            switch self {
            case .hoursPerWeek: return "Horas de estudo"
            case .tasksPerWeek: return "Tarefas"
            case .revisionSessions: return "Revisões"
            }
        }
    }

    let id: UUID
    var kind: Kind
    var target: Int
    var progress: Int
    var weekOf: Date

    init(id: UUID = UUID(), kind: Kind, target: Int, progress: Int, weekOf: Date) {
        self.id = id
        self.kind = kind
        self.target = target
        self.progress = progress
        self.weekOf = weekOf
    }

    var completion: Double {
        guard target > 0 else { return 0 }
        return min(Double(progress) / Double(target), 1.0)
    }
}

// MARK: - Sample Data

struct SampleData {
    static let calendar = Calendar(identifier: .iso8601)

    static let subjects: [Subject] = [
        Subject(name: "Anatomia", category: "Base", accentColor: .red, icon: "figure.stand"),
        Subject(name: "Fisiologia", category: "Base", accentColor: .orange, icon: "waveform.path.ecg"),
        Subject(name: "Patologia", category: "Clínica", accentColor: .purple, icon: "bandage"),
        Subject(name: "Farmacologia", category: "Clínica", accentColor: .blue, icon: "pills"),
        Subject(name: "Saúde Pública", category: "Comunidade", accentColor: .green, icon: "stethoscope")
    ]

    static let tasks: [StudyTask] = [
        StudyTask(
            title: "Mapear artérias do membro superior",
            details: "Completar os mapas mentais no Notability",
            subject: subjects[0],
            dueDate: calendar.date(byAdding: .day, value: 1, to: .now) ?? .now,
            estimatedMinutes: 60
        ),
        StudyTask(
            title: "Revisar potencial de ação cardiomiocitário",
            details: "Vídeo e flashcards",
            subject: subjects[1],
            dueDate: calendar.date(byAdding: .day, value: 2, to: .now) ?? .now,
            estimatedMinutes: 45,
            status: .inProgress
        ),
        StudyTask(
            title: "Flashcards sobre anti-hipertensivos",
            details: "Deck Anki cap. 5",
            subject: subjects[3],
            dueDate: calendar.date(byAdding: .day, value: 3, to: .now) ?? .now,
            estimatedMinutes: 30
        ),
        StudyTask(
            title: "Plano de aula para UBS",
            details: "Coleta de dados + roteiro",
            subject: subjects[4],
            dueDate: calendar.date(byAdding: .day, value: 4, to: .now) ?? .now,
            estimatedMinutes: 90,
            status: .done
        )
    ]

    static let sessions: [StudySession] = [
        StudySession(
            subject: subjects[0],
            goal: "Revisar músculos do antebraço",
            scheduledDate: calendar.date(byAdding: .hour, value: -6, to: .now) ?? .now,
            plannedMinutes: 50,
            completedMinutes: 45,
            reflections: "Usar modelos 3D ajudou"
        ),
        StudySession(
            subject: subjects[2],
            goal: "Estudar inflamação crônica",
            scheduledDate: calendar.date(byAdding: .hour, value: 3, to: .now) ?? .now,
            plannedMinutes: 60
        ),
        StudySession(
            subject: subjects[1],
            goal: "Praticar questões cardio",
            scheduledDate: calendar.date(byAdding: .day, value: 1, to: .now) ?? .now,
            plannedMinutes: 90
        )
    ]

    static let goals: [StudyGoal] = [
        StudyGoal(kind: .hoursPerWeek, target: 20, progress: 14, weekOf: .now.startOfWeek()),
        StudyGoal(kind: .tasksPerWeek, target: 10, progress: 6, weekOf: .now.startOfWeek()),
        StudyGoal(kind: .revisionSessions, target: 5, progress: 3, weekOf: .now.startOfWeek())
    ]

    static let examGrades: [ExamGrade] = [
        ExamGrade(
            subject: subjects[0],
            name: "Prova prática de anatomia",
            score: 18,
            maximumScore: 20,
            takenOn: calendar.date(byAdding: .day, value: -7, to: .now) ?? .now,
            notes: "Erro na identificação de vasos profundos"
        ),
        ExamGrade(
            subject: subjects[2],
            name: "Patologia I - prova escrita",
            score: 7.2,
            maximumScore: 10,
            takenOn: calendar.date(byAdding: .day, value: -30, to: .now) ?? .now,
            notes: "Rever mecanismos de necrose"
        ),
        ExamGrade(
            subject: subjects[4],
            name: "Saúde coletiva - seminário",
            score: 9.5,
            maximumScore: 10,
            takenOn: calendar.date(byAdding: .day, value: -12, to: .now) ?? .now,
            notes: "Ótimo feedback do preceptor"
        )
    ]
}

// MARK: - Utilities

enum StudyFormatters {
    static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()

    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()

    static let shortDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM"
        return formatter
    }()
}

private extension Date {
    func startOfWeek() -> Date {
        let calendar = Calendar(identifier: .iso8601)
        return calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) ?? self
    }
}

struct SubjectIcon: View {
    var color: Color
    var systemImage: String

    var body: some View {
        ZStack {
            Circle()
                .fill(color.opacity(0.2))
                .frame(width: 44, height: 44)
            Image(systemName: systemImage)
                .foregroundColor(color)
        }
    }
}

// MARK: - Store

final class StudyPlannerStore: ObservableObject {
    @Published var subjects: [Subject]
    @Published var tasks: [StudyTask]
    @Published var sessions: [StudySession]
    @Published var goals: [StudyGoal]
    @Published var examGrades: [ExamGrade]

    private var cancellables = Set<AnyCancellable>()

    init(
        subjects: [Subject] = SampleData.subjects,
        tasks: [StudyTask] = SampleData.tasks,
        sessions: [StudySession] = SampleData.sessions,
        goals: [StudyGoal] = SampleData.goals,
        examGrades: [ExamGrade] = SampleData.examGrades
    ) {
        self.subjects = subjects
        self.tasks = tasks
        self.sessions = sessions
        self.goals = goals
        self.examGrades = examGrades

        setUpStatusAutomation()
    }

    func tasks(for subject: Subject) -> [StudyTask] {
        tasks.filter { $0.subject.id == subject.id }
    }

    func sessions(for date: Date) -> [StudySession] {
        let calendar = Calendar.current
        return sessions.filter { calendar.isDate($0.scheduledDate, inSameDayAs: date) }
    }

    func recordCompletion(for taskID: StudyTask.ID) {
        guard let index = tasks.firstIndex(where: { $0.id == taskID }) else { return }
        tasks[index].status = .done
    }

    func schedule(session: StudySession) {
        if let index = sessions.firstIndex(where: { $0.id == session.id }) {
            sessions[index] = session
        } else {
            sessions.append(session)
        }
    }

    func addGrade(_ grade: ExamGrade) {
        examGrades.append(grade)
    }

    func updateGoal(_ goal: StudyGoal) {
        guard let index = goals.firstIndex(where: { $0.id == goal.id }) else { return }
        goals[index] = goal
    }

    private func setUpStatusAutomation() {
        $sessions
            .sink { [weak self] sessions in
                guard let self else { return }
                let totalMinutes = sessions
                    .compactMap { $0.completedMinutes }
                    .reduce(0, +)
                if let index = self.goals.firstIndex(where: { $0.kind == .hoursPerWeek }) {
                    let hours = Int(round(Double(totalMinutes) / 60.0))
                    self.goals[index].progress = hours
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - Views

struct ContentView: View {
    @StateObject private var store = StudyPlannerStore()

    var body: some View {
        StudyPlannerRootView()
            .environmentObject(store)
    }
}

struct StudyPlannerRootView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            OverviewView()
                .tabItem {
                    Label("Resumo", systemImage: "rectangle.grid.2x2")
                }
                .tag(0)

            TaskPlannerView()
                .tabItem {
                    Label("Tarefas", systemImage: "checklist")
                }
                .tag(1)

            SessionsView()
                .tabItem {
                    Label("Sessões", systemImage: "timer")
                }
                .tag(2)

            ReportsView()
                .tabItem {
                    Label("Relatórios", systemImage: "chart.bar")
                }
                .tag(3)
        }
    }
}

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

struct SessionTimerView: View {
    let session: StudySession
    let completionHandler: (Int, String) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var secondsElapsed = 0
    @State private var isRunning = false
    @State private var notes: String

    private var plannedSeconds: Int {
        session.plannedMinutes * 60
    }

    private var progress: Double {
        guard plannedSeconds > 0 else { return 0 }
        return min(Double(secondsElapsed) / Double(plannedSeconds), 1.0)
    }

    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    init(session: StudySession, completionHandler: @escaping (Int, String) -> Void) {
        self.session = session
        self.completionHandler = completionHandler
        _notes = State(initialValue: session.reflections ?? "")
    }

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 24) {
                header
                progressSection
                notesSection
                Spacer()
                controls
            }
            .padding()
            .navigationTitle(session.subject.name)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Fechar") { dismiss() }
                }
            }
        }
        .onReceive(timer) { _ in
            guard isRunning else { return }
            secondsElapsed += 1
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(session.goal)
                .font(.title2)
                .fontWeight(.semibold)
            Text("Planejado: \(session.plannedMinutes) minutos")
                .foregroundColor(.secondary)
        }
    }

    private var progressSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            ProgressView(value: progress)
                .progressViewStyle(.linear)
            HStack {
                Text(formattedElapsed)
                    .font(.headline)
                Spacer()
                Text(String(format: "%.0f%%", progress * 100))
                    .foregroundColor(.secondary)
            }
        }
    }

    private var notesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Anotações rápidas")
                .font(.headline)
            TextEditor(text: $notes)
                .frame(height: 120)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.2)))
        }
    }

    private var controls: some View {
        VStack(spacing: 12) {
            HStack(spacing: 16) {
                Button(isRunning ? "Pausar" : "Iniciar") {
                    isRunning.toggle()
                }
                .buttonStyle(.borderedProminent)

                Button("Reiniciar") {
                    isRunning = false
                    secondsElapsed = 0
                }
                .buttonStyle(.bordered)
            }

            Button("Registrar conclusão") {
                isRunning = false
                let minutes = max(Int(round(Double(secondsElapsed) / 60.0)), 1)
                completionHandler(minutes, notes)
                dismiss()
            }
            .buttonStyle(.borderedProminent)
        }
    }

    private var formattedElapsed: String {
        let minutes = secondsElapsed / 60
        let seconds = secondsElapsed % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct ReportsView: View {
    @EnvironmentObject private var store: StudyPlannerStore

    private var averageScore: Double {
        let percentages = store.examGrades.map { $0.percentage }
        guard !percentages.isEmpty else { return 0 }
        return percentages.reduce(0, +) / Double(percentages.count)
    }

    private var subjectAverages: [(subject: Subject, value: Double)] {
        let groups = Dictionary(grouping: store.examGrades, by: { $0.subject })
        return groups.map { subject, grades in
            let avg = grades.map { $0.percentage }.reduce(0, +) / Double(grades.count)
            return (subject, avg)
        }
        .sorted { $0.value > $1.value }
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    SummaryCard(averageScore: averageScore, totalExams: store.examGrades.count)
                        .padding(.horizontal)

                    if !subjectAverages.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            ReportSectionHeader(title: "Desempenho por disciplina")
                            ForEach(subjectAverages, id: \.subject.id) { entry in
                                SubjectScoreRow(entry: entry)
                            }
                        }
                    }

                    GradesList(grades: store.examGrades)
                }
                .padding(.bottom, 32)
            }
            .navigationTitle("Relatórios")
        }
    }
}

private struct SummaryCard: View {
    var averageScore: Double
    var totalExams: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Visão geral")
                .font(.title2)
                .fontWeight(.semibold)
            HStack(spacing: 24) {
                VStack(alignment: .leading) {
                    Text("Média geral")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(String(format: "%.1f%%", averageScore))
                        .font(.system(size: 36, weight: .bold))
                }
                Divider()
                    .frame(height: 60)
                VStack(alignment: .leading) {
                    Text("Avaliações registradas")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("\(totalExams)")
                        .font(.system(size: 36, weight: .bold))
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 20).fill(Color(.secondarySystemBackground)))
    }
}

private struct SubjectScoreRow: View {
    var entry: (subject: Subject, value: Double)

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                SubjectIcon(color: entry.subject.accentColor, systemImage: entry.subject.icon)
                Text(entry.subject.name)
                    .font(.headline)
                Spacer()
                Text(String(format: "%.1f%%", entry.value))
                    .fontWeight(.semibold)
            }
            ProgressView(value: entry.value / 100)
        }
        .padding(.horizontal)
    }
}

private struct GradesList: View {
    var grades: [ExamGrade]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ReportSectionHeader(title: "Notas cadastradas")
            if grades.isEmpty {
                Text("Adicione notas de provas, simulados ou OSCE para alimentar este painel.")
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
            } else {
                ForEach(grades.sorted(by: { $0.takenOn > $1.takenOn })) { grade in
                    GradeRow(grade: grade)
                }
            }
        }
    }
}

private struct GradeRow: View {
    var grade: ExamGrade

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(grade.name)
                    .font(.headline)
                Spacer()
                Text(String(format: "%.1f / %.1f", grade.score, grade.maximumScore))
                    .font(.subheadline)
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

private struct ReportSectionHeader: View {
    var title: String

    var body: some View {
        Text(title)
            .font(.title3)
            .fontWeight(.semibold)
            .padding(.horizontal)
    }
}

// MARK: - Playground live view

let contentView = ContentView()
PlaygroundPage.current.setLiveView(contentView)
