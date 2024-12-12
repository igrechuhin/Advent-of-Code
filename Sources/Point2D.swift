import Foundation

struct Point2D: Hashable, CustomStringConvertible {
    var y: Int
    var x: Int
    
    init(y: Int, x: Int) {
        self.y = y
        self.x = x
    }
    
    var description: String {
        "(\(y):\(x))"
    }
    
    static func + (left: Point2D, right: Point2D) -> Point2D {
        Point2D(
            y: left.y + right.y,
            x: left.x + right.x
        )
    }
    
    static func - (left: Point2D, right: Point2D) -> Point2D {
        Point2D(
            y: left.y - right.y,
            x: left.x - right.x
        )
    }
    
    static func * (left: Point2D, right: Int) -> Point2D {
        Point2D(
            y: left.y * right,
            x: left.x * right
        )
    }
    
    static func += (left: inout Point2D, right: Point2D) {
        left = left + right
    }
    
    static func -= (left: inout Point2D, right: Point2D) {
        left = left - right
    }
    
    static var zero: Point2D { Point2D(y: 0, x: 0) }
    
    func moved(_ direction: Direction2D) -> Point2D {
        self + direction.point2D
    }
    
    func looped(size: Point2D) -> Point2D {
        Point2D(
            y: ((y % size.y) + size.y) % size.y,
            x: ((x % size.x) + size.x) % size.x
        )
    }
    
    func isConnectedTo(_ other: Point2D, directions: [Direction2D]) -> Bool {
        directions.contains { self + $0.point2D == other }
    }
}
