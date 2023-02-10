//
//  TaskCoreData+CoreDataProperties.swift
//  
//
//  Created by no name on 22.11.2022.
//
//

import Foundation
import CoreData


extension TaskCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskCoreData> {
        return NSFetchRequest<TaskCoreData>(entityName: "TaskCoreData")
    }

    @NSManaged public var descriptionTask: String?
    @NSManaged public var isFinished: Bool
    @NSManaged public var name: String?
    @NSManaged public var priority: Int64
    @NSManaged public var time: Date?
    @NSManaged public var timeFinished: Date?
    @NSManaged public var category: CategoryCoreData?

}
