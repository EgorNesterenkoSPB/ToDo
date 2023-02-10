import Foundation

extension String {
    func localized() -> String {
        return NSLocalizedString(self, tableName: Resources.lozalizedKey, bundle: .main, value: self, comment: self)
    }
}
