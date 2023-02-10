//
//  CategoryCoreData+CoreDataProperties.swift
//  ToDo
//
//  Created by no name on 10.02.2023.
//
//

import Foundation
import CoreData


extension CategoryCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoryCoreData> {
        return NSFetchRequest<CategoryCoreData>(entityName: "CategoryCoreData")
    }

    @NSManaged public var name: String?
    @NSManaged public var project: ProjectCoreData?
    @NSManaged public var tasks: NSSet?

}

// MARK: Generated accessors for tasks
extension CategoryCoreData {

    @objc(addTasksObject:)
    @NSManaged public func addToTasks(_ value: TaskCoreData)

    @objc(removeTasksObject:)
    @NSManaged public func removeFromTasks(_ value: TaskCoreData)

    @objc(addTasks:)
    @NSManaged public func addToTasks(_ values: NSSet)

    @objc(removeTasks:)
    @NSManaged public func removeFromTasks(_ values: NSSet)

}

extension CategoryCoreData : Identifiable {

}
