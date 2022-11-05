import Foundation

//struct MainSection {
//    var sectionTitle:String
//    var data:[String] //TODO: - Test string type
//    var expandable:Bool
//}

struct Project:Codable {
    let name:String
    let categories:[Category]
}

struct Category:Codable {
    let name:String
    let tasks:[Task]
}

struct Task:Codable {
    let name:String
    let description:String
    let priority:String
    let time:String
    let isOverdue:Bool
}
