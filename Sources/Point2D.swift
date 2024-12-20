import Foundation

struct Point2D: Hashable, CustomStringConvertible {
    var y: Int
    var x: Int
    
    init(raw: String) {
        let matches = raw.matches(of: /([+-]?\d+)/)
        x = Int(matches[0].0)!
        y = Int(matches[1].0)!
    }
    
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
    
    func moved(_ direction: Direction2D, distance: Int = 1) -> Point2D {
        self + (direction.point2D * distance)
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

@inline(__always)
func L1Distance(_ a: Point2D, _ b: Point2D) -> Int {
    abs(a.x - b.x) + abs(a.y - b.y)
}
