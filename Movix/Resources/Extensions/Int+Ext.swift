import Foundation

extension Int {
    func formattedRuntime() -> String {
        let hours = self / 60
        let remainingMinutes = self % 60
        return "\(hours)h \(remainingMinutes)m"
    }
}
