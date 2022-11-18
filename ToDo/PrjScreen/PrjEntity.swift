import Foundation
import CoreData

struct CategorySection {
    var sectionTitle:String
    let objectID:NSManagedObjectID
    var data:[TaskCoreData]
    var expandable:Bool
}


