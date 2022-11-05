import Foundation

struct Project:Codable {
    let name:String
    let categories:[Category]
    let hexColor:String
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
