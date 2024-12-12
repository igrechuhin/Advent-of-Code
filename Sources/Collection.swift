import Foundation

extension Collection {
    subscript (safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
    
    var isNotEmpty: Bool { !isEmpty }
}

extension [[Int]] {
    subscript (safe position: Point2D) -> Int? {
        self[safe: position.y]?[safe: position.x]
    }
}

extension [[Character]] {
    var size: Point2D {
        Point2D(y: count, x: self[0].count)
    }
    
    var indices: (ClosedRange<Int>, ClosedRange<Int>) {
        (0 ... count - 1, 0 ... self[0].count - 1)
    }
    
    subscript (safe position: Point2D) -> Character? {
        self[safe: position.y]?[safe: position.x]
    }
    
    func contains(point: Point2D) -> Bool {
        indices.0.contains(point.y) && indices.1.contains(point.x)
    }
    
    func mutated(position: Point2D, value: Character) -> [[Character]] {
        guard self[safe: position] != nil else { return self }
        var copy = self
        copy[position.y][position.x] = value
        return copy
    }
    
    func subArray(from start: Point2D, to end: Point2D) -> [[Character]]? {
        assert(start.x <= end.x)
        assert(start.y <= end.y)
        
        var result = [[Character]]()
        
        for y in start.y ... end.y {
            var row = [Character]()
            for x in start.x ... end.x {
                if let character = self[safe: Point2D(y: y, x: x)] {
                    row.append(character)
                } else {
                    return nil
                }
            }
            result.append(row)
        }
        
        return result
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
    
    func getUniqueCharacters() -> Set<Character> {
        reduce(into: []) { result, row in
            result.formUnion(row)
        }
    }

    func prettyPrint() {
        for row in self {
            print(String(row))
        }
    }
}

extension Collection where Element == Point2D {
    func connectedRegions(directions: [Direction2D]) -> [Set<Point2D>] {
        var regions: [Set<Point2D>] = []
        
        for position in self {
            // Find all regions connected to the current position
            let connectedIndices = regions.indices.filter { index in
                regions[index].contains {
                    $0.isConnectedTo(position, directions: directions)
                }
            }
            
            if connectedIndices.isEmpty {
                // No connected regions, create a new one
                regions.append([position])
            } else {
                // Merge all connected regions and add the current position
                var mergedRegion = Set([position])
                for index in connectedIndices.reversed() {
                    mergedRegion.formUnion(regions.remove(at: index))
                }
                regions.append(mergedRegion)
            }
        }
        
        return regions
    }
}
