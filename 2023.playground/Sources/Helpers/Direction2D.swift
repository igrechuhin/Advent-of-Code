import Foundation

public enum Direction2D: CaseIterable {
    case north
    case west
    case south
    case east
    
    public var point2D: Point2D {
        switch self {
        case .north: return Point2D(y: -1, x: 0)
        case .west: return Point2D(y: 0, x: -1)
        case .south: return Point2D(y: 1, x: 0)
        case .east: return Point2D(y: 0, x: 1)
        }
    }
}
