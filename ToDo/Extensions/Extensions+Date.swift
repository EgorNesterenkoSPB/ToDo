import Foundation

extension Date {
    
    init(timestampMillis: Int64) {
        self.init(timeIntervalSince1970: TimeInterval(timestampMillis/1000))
    }
    
    func timestampMillis() -> Int64 {
        return timestamp() * 1000
    }
    
    func timestamp() -> Int64 {
        return Int64(self.timeIntervalSince1970)
    }
}
