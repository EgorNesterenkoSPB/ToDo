import Foundation
import CoreData


extension CommonTaskCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CommonTaskCoreData> {
        return NSFetchRequest<CommonTaskCoreData>(entityName: "CommonTaskCoreData")
    }

    @NSManaged public var descriptionTask: String?
    @NSManaged public var isFinished: Bool
    @NSManaged public var name: String?
    @NSManaged public var priority: Int64
    @NSManaged public var time: Date?
    @NSManaged public var timeFinished: Date?
    @NSManaged public var project: ProjectCoreData?

}

extension CommonTaskCoreData : Identifiable {

}
