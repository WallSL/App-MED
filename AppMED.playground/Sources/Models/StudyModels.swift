import Foundation
import SwiftUI

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
