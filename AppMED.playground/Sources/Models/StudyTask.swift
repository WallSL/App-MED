import Foundation

public enum TaskPriority: String, CaseIterable, Codable, Identifiable {
    case baixa
    case media
    case alta

    public var id: String { rawValue }

    public var title: String {
        switch self {
        case .baixa: return "Baixa"
        case .media: return "Média"
        case .alta: return "Alta"
        }
    }
}

public enum TaskStatus: String, CaseIterable, Codable, Identifiable {
    case pendente
    case emAndamento
    case concluida

    public var id: String { rawValue }

    public var title: String {
        switch self {
        case .pendente: return "Pendente"
        case .emAndamento: return "Em andamento"
        case .concluida: return "Concluída"
        }
    }
}

public struct StudyTask: Identifiable, Codable {
    public let id: UUID
    public var title: String
    public var details: String
    public var subject: Subject
    public var dueDate: Date?
    public var priority: TaskPriority
    public var status: TaskStatus

    public init(
        id: UUID = UUID(),
        title: String,
        details: String,
        subject: Subject,
        dueDate: Date? = nil,
        priority: TaskPriority = .media,
        status: TaskStatus = .pendente
    ) {
        self.id = id
        self.title = title
        self.details = details
        self.subject = subject
        self.dueDate = dueDate
        self.priority = priority
        self.status = status
    }
}
