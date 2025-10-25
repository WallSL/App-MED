import Foundation

public enum GoalType: String, CaseIterable, Codable, Identifiable {
    case horasPorSemana
    case tarefasConcluidas
    case mediaNotas

    public var id: String { rawValue }

    public var title: String {
        switch self {
        case .horasPorSemana: return "Horas por semana"
        case .tarefasConcluidas: return "Tarefas concluídas"
        case .mediaNotas: return "Média de notas"
        }
    }
}

public struct Goal: Identifiable, Codable {
    public let id: UUID
    public var type: GoalType
    public var targetValue: Double
    public var period: DateInterval
    public var progressValue: Double

    public init(
        id: UUID = UUID(),
        type: GoalType,
        targetValue: Double,
        period: DateInterval,
        progressValue: Double = 0
    ) {
        self.id = id
        self.type = type
        self.targetValue = targetValue
        self.period = period
        self.progressValue = progressValue
    }

    public var progressRatio: Double {
        guard targetValue > 0 else { return 0 }
        return min(progressValue / targetValue, 1)
    }
}
