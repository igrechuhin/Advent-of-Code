import Foundation

public struct Beam2D: Hashable, CustomStringConvertible {
    public var point: Point2D
    public var direction: Direction2D
    
    public var description: String {
        "\(point)\(direction)"
    }
    
    public init(point: Point2D, direction: Direction2D) {
        self.point = point
        self.direction = direction
    }
}
