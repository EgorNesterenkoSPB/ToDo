//
//  CommonTask+CoreDataProperties.swift
//  
//
//  Created by no name on 17.11.2022.
//
//

import Foundation
import CoreData


extension CommonTaskCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CommonTaskCoreData> {
        return NSFetchRequest<CommonTaskCoreData>(entityName: "CommonTask")
    }

    @NSManaged public var name: String?
    @NSManaged public var descriptionTask: String?
    @NSManaged public var time: Date?
    @NSManaged public var priority: String?
    @NSManaged public var project: ProjectCoreData?

}
