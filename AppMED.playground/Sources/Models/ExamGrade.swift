import Foundation

public struct ExamGrade: Identifiable, Codable {
    public let id: UUID
    public var subject: Subject
    public var title: String
    public var date: Date
    public var score: Double
    public var maxScore: Double
    public var notes: String

    public init(
        id: UUID = UUID(),
        subject: Subject,
        title: String,
        date: Date,
        score: Double,
        maxScore: Double = 10,
        notes: String = ""
    ) {
        self.id = id
        self.subject = subject
        self.title = title
        self.date = date
        self.score = score
        self.maxScore = maxScore
        self.notes = notes
    }

    public var percentage: Double {
        guard maxScore > 0 else { return 0 }
        return (score / maxScore) * 100
    }
}
