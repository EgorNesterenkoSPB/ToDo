import Foundation
import CoreData

struct CategorySection {
    var sectionTitle:String?
    let objectID:NSManagedObjectID?
    var categoryData:[TaskCoreData]?
    var commonTasks:[CommonTaskCoreData]?
    var expandable:Bool?
}


