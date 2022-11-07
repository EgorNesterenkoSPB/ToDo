//
//  TaskCoreData+CoreDataProperties.swift
//  
//
//  Created by no name on 07.11.2022.
//
//

import Foundation
import CoreData


extension TaskCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskCoreData> {
        return NSFetchRequest<TaskCoreData>(entityName: "TaskCoreData")
    }

    @NSManaged public var descriptionTask: String?
    @NSManaged public var name: String?
    @NSManaged public var priority: String?
    @NSManaged public var time: Date?
    @NSManaged public var category: CategoryCoreData?

}
