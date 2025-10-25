import SwiftUI

struct ContentView: View {
    @StateObject private var store = StudyPlannerStore()

    var body: some View {
        StudyPlannerRootView()
            .environmentObject(store)
    }
}

struct StudyPlannerRootView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            OverviewView()
                .tabItem {
                    Label("Resumo", systemImage: "rectangle.grid.2x2")
                }
                .tag(0)

            TaskPlannerView()
                .tabItem {
                    Label("Tarefas", systemImage: "checklist")
                }
                .tag(1)

            SessionsView()
                .tabItem {
                    Label("Sessões", systemImage: "timer")
                }
                .tag(2)

            ReportsView()
                .tabItem {
                    Label("Relatórios", systemImage: "chart.bar")
                }
                .tag(3)
        }
    }
}
