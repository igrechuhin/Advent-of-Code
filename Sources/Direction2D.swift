import Foundation

enum Direction2D: CaseIterable {
    case north
    case west
    case south
    case east
    
    var point2D: Point2D {
        switch self {
        case .north: return Point2D(y: -1, x: 0)
        case .west: return Point2D(y: 0, x: -1)
        case .south: return Point2D(y: 1, x: 0)
        case .east: return Point2D(y: 0, x: 1)
        }
    }
    
    var rotatedLeft: Direction2D {
        switch self {
        case .north: return .west
        case .west: return .south
        case .south: return .east
        case .east: return .north
        }
    }
    
    var rotatedRight: Direction2D {
        switch self {
        case .north: return .east
        case .west: return .north
        case .south: return .west
        case .east: return .south
        }
    }
    
    var isHorizontal: Bool {
        switch self {
        case .north, .south: return false
        case .east, .west: return true
        }
    }
}
