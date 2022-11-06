import Foundation

struct ProjectsSection {
    let sectionTitle:String
    let data:[Project]
    var expandable:Bool
}

struct Color {
    let hex:String
    let name:String
}

struct ColorSection {
    let data:[Color]
    var expandable:Bool
}
