import Foundation
import CoreData


extension ProjectCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProjectCoreData> {
        return NSFetchRequest<ProjectCoreData>(entityName: "ProjectCoreData")
    }

    @NSManaged public var hexColor: String?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var name: String?
    @NSManaged public var categories: NSSet?
    @NSManaged public var commonTasks: NSSet?

}

// MARK: Generated accessors for categories
extension ProjectCoreData {

    @objc(addCategoriesObject:)
    @NSManaged public func addToCategories(_ value: CategoryCoreData)

    @objc(removeCategoriesObject:)
    @NSManaged public func removeFromCategories(_ value: CategoryCoreData)

    @objc(addCategories:)
    @NSManaged public func addToCategories(_ values: NSSet)

    @objc(removeCategories:)
    @NSManaged public func removeFromCategories(_ values: NSSet)

}

// MARK: Generated accessors for commonTasks
extension ProjectCoreData {

    @objc(addCommonTasksObject:)
    @NSManaged public func addToCommonTasks(_ value: CommonTaskCoreData)

    @objc(removeCommonTasksObject:)
    @NSManaged public func removeFromCommonTasks(_ value: CommonTaskCoreData)

    @objc(addCommonTasks:)
    @NSManaged public func addToCommonTasks(_ values: NSSet)

    @objc(removeCommonTasks:)
    @NSManaged public func removeFromCommonTasks(_ values: NSSet)

}

extension ProjectCoreData : Identifiable {

}
