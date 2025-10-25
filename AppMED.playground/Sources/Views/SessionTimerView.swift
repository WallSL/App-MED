import SwiftUI
import Combine
#if canImport(AVFoundation)
import AVFoundation
#endif
#if canImport(AudioToolbox)
import AudioToolbox
#endif

public struct SessionTimerView: View {
    @EnvironmentObject private var store: StudyDataStore
    @State private var selectedSubject: Subject?
    @State private var selectedTechnique: StudyTechnique = .pomodoro
    @State private var duration: TimeInterval = 25 * 60
    @State private var remainingTime: TimeInterval = 25 * 60
    @State private var isRunning = false
    @State private var cancellable: AnyCancellable?
    @State private var notes: String = ""

    public init() {}

    public var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                subjectPicker
                techniquePicker
                durationStepper
                timerDisplay
                notesSection
                startButton
                Spacer()
            }
            .padding()
            .navigationTitle("Sessão de estudo")
        }
        .onAppear {
            selectedSubject = store.subjects.first
        }
    }

    private var subjectPicker: some View {
        Picker("Disciplina", selection: Binding(
            get: { selectedSubject ?? store.subjects.first },
            set: { selectedSubject = $0 }
        )) {
            ForEach(store.subjects) { subject in
                Text(subject.name).tag(Subject?.some(subject))
            }
        }
        .pickerStyle(.navigationLink)
    }

    private var techniquePicker: some View {
        Picker("Técnica", selection: $selectedTechnique) {
            ForEach(StudyTechnique.allCases) { technique in
                Text(technique.title).tag(technique)
            }
        }
        .pickerStyle(.segmented)
    }

    private var durationStepper: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Duração: \(Int(duration / 60)) minutos")
            Stepper(value: Binding(
                get: { Int(duration / 60) },
                set: { newValue in
                    duration = TimeInterval(newValue * 60)
                    if !isRunning {
                        remainingTime = duration
                    }
                }
            ), in: 10...120, step: 5) {
                Text("Ajustar duração")
            }
        }
    }

    private var timerDisplay: some View {
        VStack(spacing: 16) {
            Text(timeString(from: remainingTime))
                .font(.system(size: 48, weight: .semibold, design: .monospaced))
            ProgressView(value: duration == 0 ? 0 : 1 - (remainingTime / duration))
            HStack(spacing: 12) {
                Button(action: toggleTimer) {
                    Label(isRunning ? "Pausar" : "Iniciar", systemImage: isRunning ? "pause.fill" : "play.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)

                Button(action: resetTimer) {
                    Label("Resetar", systemImage: "arrow.clockwise")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .disabled(!isRunning && remainingTime == duration)
            }
        }
    }

    private var notesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Notas da sessão")
                .font(.headline)
            TextEditor(text: $notes)
                .frame(height: 120)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.2)))
        }
    }

    private var startButton: some View {
        Button(action: finalizeSession) {
            Label("Registrar sessão", systemImage: "checkmark.circle.fill")
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .disabled(selectedSubject == nil)
    }

    private func toggleTimer() {
        guard !isRunning else {
            cancellable?.cancel()
            cancellable = nil
            isRunning = false
            return
        }

        isRunning = true
        remainingTime = max(remainingTime, 0)
        let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        cancellable = timer.sink { _ in
            if remainingTime > 0 {
                remainingTime -= 1
            } else {
                #if canImport(AudioToolbox)
                AudioServicesPlaySystemSound(1005)
                #endif
                resetTimer()
            }
        }
    }

    private func resetTimer() {
        cancellable?.cancel()
        cancellable = nil
        isRunning = false
        remainingTime = duration
    }

    private func finalizeSession() {
        guard let subject = selectedSubject else { return }
        let now = Date()
        let session = StudySession(
            subject: subject,
            plannedStart: now,
            plannedDuration: duration,
            actualStart: now,
            actualEnd: now.addingTimeInterval(duration - remainingTime),
            technique: selectedTechnique,
            notes: notes,
            productivityScore: Int.random(in: 6...10)
        )
        store.add(session: session)
        resetTimer()
        notes = ""
    }

    private func timeString(from interval: TimeInterval) -> String {
        let minutes = Int(interval) / 60
        let seconds = Int(interval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
