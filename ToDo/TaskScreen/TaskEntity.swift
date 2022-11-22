import Foundation

protocol TaskContent {
    var name:String {get set}
    var description:String? {get set}
    var priority:Int64? {get set}
    var path:String {get set}
    var isFinished:Bool {get set}
    var time:Date? {get set}
}
