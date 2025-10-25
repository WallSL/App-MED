import SwiftUI

struct SubjectIcon: View {
    var color: Color
    var systemImage: String

    var body: some View {
        ZStack {
            Circle()
                .fill(color.opacity(0.2))
                .frame(width: 44, height: 44)
            Image(systemName: systemImage)
                .foregroundColor(color)
        }
    }
}
