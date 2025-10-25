import Foundation
import SwiftUI

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

private extension Date {
    func startOfWeek() -> Date {
        let calendar = Calendar(identifier: .iso8601)
        return calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) ?? self
    }
}
