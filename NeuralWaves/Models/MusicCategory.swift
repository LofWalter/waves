import Foundation

enum MusicCategory: String, CaseIterable, Identifiable {
    case focus = "Focus"
    case relax = "Relax"
    case deepSleep = "Deep Sleep"
    
    var id: String { self.rawValue }
    
    var description: String {
        switch self {
        case .focus:
            return "Enhance concentration and productivity"
        case .relax:
            return "Unwind and reduce stress"
        case .deepSleep:
            return "Promote restful sleep"
        }
    }
    
    var iconName: String {
        switch self {
        case .focus:
            return "brain.head.profile"
        case .relax:
            return "leaf.fill"
        case .deepSleep:
            return "moon.fill"
        }
    }
    
    var color: String {
        switch self {
        case .focus:
            return "blue"
        case .relax:
            return "green"
        case .deepSleep:
            return "purple"
        }
    }
}