import Foundation

public struct Subject: Identifiable, Hashable, Codable {
    public let id: UUID
    public var name: String
    public var professor: String?
    public var colorHex: String
    public var tags: [String]

    public init(id: UUID = UUID(), name: String, professor: String? = nil, colorHex: String = "#2E86AB", tags: [String] = []) {
        self.id = id
        self.name = name
        self.professor = professor
        self.colorHex = colorHex
        self.tags = tags
    }
}
