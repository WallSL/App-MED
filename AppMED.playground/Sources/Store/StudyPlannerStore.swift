import Foundation
import Combine

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
