import Foundation

extension Sequence where Element: AdditiveArithmetic {
    var sum: Element { reduce(.zero, +) }
}

extension Sequence where Element == Int {
    var leastCommonMultiple: Int {
        Set(self).reduce(1) { Math.leastCommonMultiple(for: $0, and: $1) }
    }
}

extension Sequence where Element: Numeric {
    var mul: Element { reduce(1, *) }
}

extension Zip2Sequence<[Int], [Int]> {
    var mul: [Int] { map { $0 * $1 } }
}
