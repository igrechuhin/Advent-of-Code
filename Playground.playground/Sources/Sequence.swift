import Foundation

public extension Sequence where Element: AdditiveArithmetic {
    var sum: Element { reduce(.zero, +) }
}

public extension Sequence where Element == Int {
    var leastCommonMultiple: Int {
        Set(self).reduce(1) { Math.leastCommonMultiple(for: $0, and: $1) }
    }
}

public extension Sequence where Element: Numeric {
    var mul: Element { reduce(1, *) }
}
