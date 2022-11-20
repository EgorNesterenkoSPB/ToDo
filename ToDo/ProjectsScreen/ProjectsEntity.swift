import Foundation
import UIKit

struct ProjectsSection {
    let sectionTitle:String
    var data:[ProjectCoreData]
    var expandable:Bool
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
