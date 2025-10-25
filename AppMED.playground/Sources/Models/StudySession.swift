import Foundation

public enum StudyTechnique: String, CaseIterable, Codable, Identifiable {
    case pomodoro
    case focoProfundo
    case revisaoEspacada

    public var id: String { rawValue }

    public var title: String {
        switch self {
        case .pomodoro: return "Pomodoro"
        case .focoProfundo: return "Foco profundo"
        case .revisaoEspacada: return "Revisão espaçada"
        }
    }
}

public struct StudySession: Identifiable, Codable {
    public let id: UUID
    public var subject: Subject
    public var task: StudyTask?
    public var plannedStart: Date
    public var plannedDuration: TimeInterval
    public var actualStart: Date?
    public var actualEnd: Date?
    public var technique: StudyTechnique
    public var notes: String
    public var productivityScore: Int?

    public init(
        id: UUID = UUID(),
        subject: Subject,
        task: StudyTask? = nil,
        plannedStart: Date,
        plannedDuration: TimeInterval,
        actualStart: Date? = nil,
        actualEnd: Date? = nil,
        technique: StudyTechnique = .pomodoro,
        notes: String = "",
        productivityScore: Int? = nil
    ) {
        self.id = id
        self.subject = subject
        self.task = task
        self.plannedStart = plannedStart
        self.plannedDuration = plannedDuration
        self.actualStart = actualStart
        self.actualEnd = actualEnd
        self.technique = technique
        self.notes = notes
        self.productivityScore = productivityScore
    }

    public var actualDuration: TimeInterval? {
        guard let start = actualStart, let end = actualEnd else { return nil }
        return end.timeIntervalSince(start)
    }
}
