import Foundation

public extension Collection {
    subscript (safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

public extension [[Int]] {
    subscript (safe position: Point2D) -> Int? {
        self[safe: position.y]?[safe: position.x]
    }
}

public extension [[Character]] {
    var size: Point2D {
        Point2D(y: count, x: self[0].count)
    }

    subscript (safe position: Point2D) -> Character? {
        self[safe: position.y]?[safe: position.x]
    }
    
    func getFirstPositionOfCharacter(_ character: Character) -> Point2D? {
        getPositionsOfCharacter(character).first
    }
    
    func getLastPositionOfCharacter(_ character: Character) -> Point2D? {
        getPositionsOfCharacter(character).last
    }
    
    func getPositionsOfCharacter(_ character: Character) -> [Point2D] {
        getPositions { element, _ in element == character }
    }
    
    func getPositions(where block: (Character, Point2D) -> Bool) -> [Point2D] {
        var result: [Point2D] = []
        for (rowIndex, row) in self.enumerated() {
            for (colIndex, element) in row.enumerated() {
                let position = Point2D(y: rowIndex, x: colIndex)
                if block(element, position) {
                    result.append(position)
                }
            }
        }
        return result
    }

    func prettyPrint() {
        for row in self {
            print(String(row))
        }
    }
}
