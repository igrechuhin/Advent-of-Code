import Foundation

public struct Point2D: Hashable, CustomStringConvertible {
    public var y: Int
    public var x: Int
    
    public init(y: Int, x: Int) {
        self.y = y
        self.x = x
    }
    
    public var description: String {
        "(\(x):\(y))"
    }
    
    public static func + (left: Point2D, right: Point2D) -> Point2D {
        Point2D(
            y: left.y + right.y,
            x: left.x + right.x
        )
    }
    
    public static func - (left: Point2D, right: Point2D) -> Point2D {
        Point2D(
            y: left.y - right.y,
            x: left.x - right.x
        )
    }
    
    public static func * (left: Point2D, right: Int) -> Point2D {
        Point2D(
            y: left.y * right,
            x: left.x * right
        )
    }
    
    public static func += (left: inout Point2D, right: Point2D) {
        left = left + right
    }
    
    public static func -= (left: inout Point2D, right: Point2D) {
        left = left - right
    }
    
    public static var zero: Point2D { Point2D(y: 0, x: 0) }
    
    public func moved(_ direction: Direction2D) -> Point2D {
        self + direction.point2D
    }
    
    public func looped(size: Point2D) -> Point2D {
        Point2D(
            y: ((y % size.y) + size.y) % size.y,
            x: ((x % size.x) + size.x) % size.x
        )
    }
}

extension [Point2D] {
    var area: Int {
        var area = 0
        var perimeter = 0
        
        for vertexId in indices {
            let p1 = self[vertexId]
            let p2 = self[(vertexId + 1) % count]
            area += p1.x * p2.y - p2.x * p1.y
            // Simplified
            perimeter += abs(p1.x - p2.x) + abs(p1.y - p2.y)
        }
        
        area = abs(area) / 2
        perimeter = perimeter / 2
        //  The interior area of a polygon can be calculated using Pick's Theorem:
        //  I = A - B/2 + 1
        return area + perimeter + 1
    }
}
