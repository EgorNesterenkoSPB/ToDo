//
//  Task+CoreDataProperties.swift
//  
//
//  Created by no name on 03.11.2022.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var descriptionTask: String?
    @NSManaged public var name: String?
    @NSManaged public var priority: String?
    @NSManaged public var time: Date?
    @NSManaged public var category: Category?

}
