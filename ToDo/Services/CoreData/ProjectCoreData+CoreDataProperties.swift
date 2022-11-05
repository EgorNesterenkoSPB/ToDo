//
//  ProjectCoreData+CoreDataProperties.swift
//  
//
//  Created by no name on 05.11.2022.
//
//

import Foundation
import CoreData


extension ProjectCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProjectCoreData> {
        return NSFetchRequest<ProjectCoreData>(entityName: "ProjectCoreData")
    }

    @NSManaged public var name: String?
    @NSManaged public var categories: NSSet?

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
