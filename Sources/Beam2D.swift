import Foundation

struct Beam2D: Hashable, CustomStringConvertible {
    var point: Point2D
    var direction: Direction2D
    
    var description: String {
        "\(point)\(direction)"
    }
    
    init(point: Point2D, direction: Direction2D) {
        self.point = point
        self.direction = direction
    }
}
