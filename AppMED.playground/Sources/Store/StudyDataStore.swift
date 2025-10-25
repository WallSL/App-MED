import Foundation
import Combine
public final class StudyDataStore: ObservableObject {
    @Published public private(set) var subjects: [Subject]
    @Published public private(set) var tasks: [StudyTask]
    @Published public private(set) var sessions: [StudySession]
    @Published public private(set) var grades: [ExamGrade]
    @Published public private(set) var goals: [Goal]

    public init(
        subjects: [Subject] = StudyDataStore.sampleSubjects,
        tasks: [StudyTask] = StudyDataStore.sampleTasks,
        sessions: [StudySession] = StudyDataStore.sampleSessions,
        grades: [ExamGrade] = StudyDataStore.sampleGrades,
        goals: [Goal] = StudyDataStore.sampleGoals
    ) {
        self.subjects = subjects
        self.tasks = tasks
        self.sessions = sessions
        self.grades = grades
        self.goals = goals
    }

    // MARK: - Subjects

    public func add(subject: Subject) {
        subjects.append(subject)
    }

    // MARK: - Tasks

    public func add(task: StudyTask) {
        tasks.append(task)
    }

    public func update(task: StudyTask) {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else { return }
        tasks[index] = task
    }

    public func tasks(for subject: Subject) -> [StudyTask] {
        tasks.filter { $0.subject.id == subject.id }
    }

    public func tasks(dueOn date: Date) -> [StudyTask] {
        tasks.filter { $0.dueDate?.startOfDay == date.startOfDay }
    }

    // MARK: - Sessions

    public func add(session: StudySession) {
        sessions.append(session)
    }

    public func sessions(for date: Date) -> [StudySession] {
        sessions.filter { Calendar.current.isDate($0.plannedStart, inSameDayAs: date) }
            .sorted { $0.plannedStart < $1.plannedStart }
    }

    // MARK: - Grades

    public func add(grade: ExamGrade) {
        grades.append(grade)
    }

    public func averageGrade(for subject: Subject) -> Double {
        let subjectGrades = grades.filter { $0.subject.id == subject.id }
        guard !subjectGrades.isEmpty else { return 0 }
        let total = subjectGrades.reduce(0) { $0 + ($1.percentage) }
        return total / Double(subjectGrades.count)
    }

    public func overallAverageGrade() -> Double {
        guard !grades.isEmpty else { return 0 }
        let total = grades.reduce(0) { $0 + $1.percentage }
        return total / Double(grades.count)
    }

    // MARK: - Goals

    public func progress(for goal: Goal) -> Double {
        switch goal.type {
        case .horasPorSemana:
            let totalHours = sessions
                .filter { goal.period.contains($0.plannedStart) }
                .compactMap { $0.actualDuration ?? $0.plannedDuration }
                .reduce(0, +) / 3600
            return min(totalHours / goal.targetValue, 1)
        case .tarefasConcluidas:
            let completed = tasks
                .filter { goal.period.contains($0.dueDate ?? Date()) && $0.status == .concluida }
                .count
            return min(Double(completed) / goal.targetValue, 1)
        case .mediaNotas:
            let gradesInPeriod = grades.filter { goal.period.contains($0.date) }
            guard !gradesInPeriod.isEmpty else { return 0 }
            let average = gradesInPeriod.reduce(0) { $0 + $1.percentage } / Double(gradesInPeriod.count)
            return min(average / goal.targetValue, 1)
        }
    }
}

// MARK: - Sample Data

private extension StudyDataStore {
    private static let anatomyID = UUID()
    private static let physiologyID = UUID()
    private static let pathologyID = UUID()
    private static let pharmacologyID = UUID()

    static let sampleSubjects: [Subject] = [
        Subject(id: anatomyID, name: "Anatomia", colorHex: "#7B1FA2"),
        Subject(id: physiologyID, name: "Fisiologia", colorHex: "#1E88E5"),
        Subject(id: pathologyID, name: "Patologia", colorHex: "#43A047"),
        Subject(id: pharmacologyID, name: "Farmacologia", colorHex: "#F4511E")
    ]

    static let sampleTasks: [StudyTask] = [
        StudyTask(
            title: "Revisar sistema cardiovascular",
            details: "Resumo do capítulo 5 e flashcards",
            subject: sampleSubjects[1],
            dueDate: Calendar.current.date(byAdding: .day, value: 1, to: Date()),
            priority: .alta
        ),
        StudyTask(
            title: "Montar mapa mental de cranianos",
            details: "Foco em nervos pares",
            subject: sampleSubjects[0],
            dueDate: Calendar.current.date(byAdding: .day, value: 2, to: Date()),
            priority: .media
        ),
        StudyTask(
            title: "Resolver questões de antibióticos",
            details: "Aplicativo MedMaster, bloco de 40 questões",
            subject: sampleSubjects[3],
            dueDate: Calendar.current.date(byAdding: .day, value: 3, to: Date()),
            priority: .alta
        )
    ]

    static let sampleSessions: [StudySession] = {
        let now = Date()
        return [
            StudySession(
                subject: sampleSubjects[0],
                task: sampleTasks.first,
                plannedStart: now,
                plannedDuration: 60 * 60,
                actualStart: now,
                actualEnd: now.addingTimeInterval(55 * 60),
                technique: .pomodoro,
                notes: "Boa retenção, revisar flashcards amanhã",
                productivityScore: 8
            ),
            StudySession(
                subject: sampleSubjects[1],
                task: sampleTasks[1],
                plannedStart: now.addingTimeInterval(3600 * 5),
                plannedDuration: 90 * 60,
                technique: .focoProfundo
            ),
            StudySession(
                subject: sampleSubjects[2],
                plannedStart: now.addingTimeInterval(3600 * 24),
                plannedDuration: 120 * 60,
                technique: .revisaoEspacada,
                notes: "Preparar para prova prática"
            )
        ]
    }()

    static let sampleGrades: [ExamGrade] = [
        ExamGrade(subject: sampleSubjects[0], title: "Prova prática de anatomia", date: Date().addingTimeInterval(-3600 * 24 * 7), score: 8.7, maxScore: 10),
        ExamGrade(subject: sampleSubjects[1], title: "Simulado cardio", date: Date().addingTimeInterval(-3600 * 24 * 14), score: 36, maxScore: 40),
        ExamGrade(subject: sampleSubjects[2], title: "OSCE - Patologia", date: Date().addingTimeInterval(-3600 * 24 * 30), score: 82, maxScore: 100)
    ]

    static let sampleGoals: [Goal] = [
        Goal(type: .horasPorSemana, targetValue: 25, period: DateInterval.thisWeek(), progressValue: 12),
        Goal(type: .tarefasConcluidas, targetValue: 10, period: DateInterval.thisWeek(), progressValue: 4),
        Goal(type: .mediaNotas, targetValue: 85, period: DateInterval(start: Date().addingTimeInterval(-3600 * 24 * 30), end: Date()), progressValue: 78)
    ]
}
