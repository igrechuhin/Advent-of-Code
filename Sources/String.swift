import Foundation

extension String {
    var as2DArray: [[Character]] {
        self
            .components(separatedBy: .newlines)
            .filter { !$0.isEmpty }
            .map { Array($0) }
    }
}
