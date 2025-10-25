import SwiftUI

public struct ContentView: View {
    @StateObject private var store = StudyDataStore()

    public init() {}

    public var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "rectangle.grid.2x2")
                }
            TaskListView()
                .tabItem {
                    Label("Tarefas", systemImage: "checklist")
                }
            CalendarView()
                .tabItem {
                    Label("Agenda", systemImage: "calendar")
                }
            SessionTimerView()
                .tabItem {
                    Label("Sessão", systemImage: "timer")
                }
            ReportsView()
                .tabItem {
                    Label("Relatórios", systemImage: "chart.bar")
                }
        }
        .environmentObject(store)
    }
}
