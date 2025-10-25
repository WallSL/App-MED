import SwiftUI

struct SessionTimerView: View {
    let session: StudySession
    let completionHandler: (Int, String) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var secondsElapsed = 0
    @State private var isRunning = false
    @State private var notes: String

    private var plannedSeconds: Int {
        session.plannedMinutes * 60
    }

    private var progress: Double {
        guard plannedSeconds > 0 else { return 0 }
        return min(Double(secondsElapsed) / Double(plannedSeconds), 1.0)
    }

    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    init(session: StudySession, completionHandler: @escaping (Int, String) -> Void) {
        self.session = session
        self.completionHandler = completionHandler
        _notes = State(initialValue: session.reflections ?? "")
    }

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 24) {
                header
                progressSection
                notesSection
                Spacer()
                controls
            }
            .padding()
            .navigationTitle(session.subject.name)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Fechar") { dismiss() }
                }
            }
        }
        .onReceive(timer) { _ in
            guard isRunning else { return }
            secondsElapsed += 1
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(session.goal)
                .font(.title2)
                .fontWeight(.semibold)
            Text("Planejado: \(session.plannedMinutes) minutos")
                .foregroundColor(.secondary)
        }
    }

    private var progressSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            ProgressView(value: progress)
                .progressViewStyle(.linear)
            HStack {
                Text(formattedElapsed)
                    .font(.headline)
                Spacer()
                Text(String(format: "%.0f%%", progress * 100))
                    .foregroundColor(.secondary)
            }
        }
    }

    private var notesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Anotações rápidas")
                .font(.headline)
            TextEditor(text: $notes)
                .frame(height: 120)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.2)))
        }
    }

    private var controls: some View {
        VStack(spacing: 12) {
            HStack(spacing: 16) {
                Button(isRunning ? "Pausar" : "Iniciar") {
                    isRunning.toggle()
                }
                .buttonStyle(.borderedProminent)

                Button("Reiniciar") {
                    isRunning = false
                    secondsElapsed = 0
                }
                .buttonStyle(.bordered)
            }

            Button("Registrar conclusão") {
                isRunning = false
                let minutes = max(Int(round(Double(secondsElapsed) / 60.0)), 1)
                completionHandler(minutes, notes)
                dismiss()
            }
            .buttonStyle(.borderedProminent)
        }
    }

    private var formattedElapsed: String {
        let minutes = secondsElapsed / 60
        let seconds = secondsElapsed % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
