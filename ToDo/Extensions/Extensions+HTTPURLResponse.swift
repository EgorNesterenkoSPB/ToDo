import Foundation

extension HTTPURLResponse {
    func isSuccessful() -> Bool {
        return statusCode >= 200 && statusCode <= 299
    }
}
