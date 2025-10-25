import SwiftUI

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
