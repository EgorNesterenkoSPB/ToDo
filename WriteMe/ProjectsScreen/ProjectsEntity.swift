import Foundation
import UIKit

struct ProjectsSection {
    let sectionTitle:String?
    var projectsData:[ProjectCoreData]?
    var expandable:Bool?
    var modelsData:[CommonCellOption]?
}

struct Color {
    let hex:String
    let name:String
}

struct ColorSection {
    let data:[Color]
    var expandable:Bool
}


struct CommonCellOption {
    let title:String
    let icon:UIImage?
    let iconBackgroundColor:UIColor?
    var handler: (() -> Void)
}

struct Section {
    let title:String
    let options:[CommonCellOption]
}
