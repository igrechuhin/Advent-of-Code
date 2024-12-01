import Foundation

extension AoC2023 {
    private static func getDay19Input() -> String {
        //"""
        //px{a<2006:qkq,m>2090:A,rfg}
        //pv{a>1716:R,A}
        //lnx{m>1548:A,A}
        //rfg{s<537:gd,x>2440:R,A}
        //qs{s>3448:A,lnx}
        //qkq{x<1416:A,crn}
        //crn{x>2662:A,R}
        //in{s<1351:px,qqz}
        //qqz{s>2770:qs,m<1801:hdj,R}
        //gd{a>3333:R,R}
        //hdj{m>838:A,pv}
        //
        //{x=787,m=2655,a=1222,s=2876}
        //{x=1679,m=44,a=2067,s=496}
        //{x=2036,m=264,a=79,s=2244}
        //{x=2461,m=1339,a=466,s=291}
        //{x=2127,m=1623,a=2188,s=1013}
        //"""
        
        getInput(fileName: "Day19Input")
    }
    
    //: # --- Day 19: Aplenty ---
    //: The Elves of Gear Island are thankful for your help and send you on your way. They even have a hang glider that someone stole from Desert Island; since you're already going that direction, it would help them a lot if you would use it to get down there and return it to them.
    //:
    //: As you reach the bottom of the **relentless avalanche of machine parts**, you discover that they're already forming a formidable heap. Don't worry, though - a group of Elves is already here organizing the parts, and they have a **system**.
    //:
    //: To start, each part is rated in each of four categories:
    //:
    //: - x: E**x**tremely cool looking
    //: - m: **M**usical (it makes a noise when you hit it)
    //: - a: **A**erodynamic
    //: - s: **S**hiny
    //:
    //: Then, each part is sent through a series of **workflows** that will ultimately **accept** or **reject** the part. Each workflow has a name and contains a list of **rules**; each rule specifies a condition and where to send the part if the condition is true. The first rule that matches the part being considered is applied immediately, and the part moves on to the destination described by the rule. (The last rule in each workflow has no condition and always applies if reached.)
    //:
    //: Consider the workflow ex{x>10:one,m<20:two,a>30:R,A}. This workflow is named ex and contains four rules. If workflow ex were considering a specific part, it would perform the following steps in order:
    //:
    //: - Rule "x>10:one": If the part's x is more than 10, send the part to the workflow named one.
    //: - Rule "m<20:two": Otherwise, if the part's m is less than 20, send the part to the workflow named two.
    //: - Rule "a>30:R": Otherwise, if the part's a is more than 30, the part is immediately rejected (R).
    //: - Rule "A": Otherwise, because no other rules matched the part, the part is immediately accepted (A).
    //:
    //: If a part is sent to another workflow, it immediately switches to the start of that workflow instead and never returns. If a part is **accepted** (sent to A) or **rejected** (sent to R), the part immediately stops any further processing.
    //:
    //: The system works, but it's not keeping up with the torrent of weird metal shapes. The Elves ask if you can help sort a few parts and give you the list of workflows and some part ratings (your puzzle input). For example:
    //:
    //: ```
    //: px{a<2006:qkq,m>2090:A,rfg}
    //: pv{a>1716:R,A}
    //: lnx{m>1548:A,A}
    //: rfg{s<537:gd,x>2440:R,A}
    //: qs{s>3448:A,lnx}
    //: qkq{x<1416:A,crn}
    //: crn{x>2662:A,R}
    //: in{s<1351:px,qqz}
    //: qqz{s>2770:qs,m<1801:hdj,R}
    //: gd{a>3333:R,R}
    //: hdj{m>838:A,pv}
    //:
    //: {x=787,m=2655,a=1222,s=2876}
    //: {x=1679,m=44,a=2067,s=496}
    //: {x=2036,m=264,a=79,s=2244}
    //: {x=2461,m=1339,a=466,s=291}
    //: {x=2127,m=1623,a=2188,s=1013}
    //: ```
    //:
    //: The workflows are listed first, followed by a blank line, then the ratings of the parts the Elves would like you to sort. All parts begin in the workflow named in. In this example, the five listed parts go through the following workflows:
    //:
    //: - `{x=787,m=2655,a=1222,s=2876}`: `in` -> `qqz` -> `qs` -> `lnx` -> **`A`**
    //: - `{x=1679,m=44,a=2067,s=496}`: `in` -> `px` -> `rfg` -> `gd` -> **`R`**
    //: - `{x=2036,m=264,a=79,s=2244}`: `in` -> `qqz` -> `hdj` -> `pv` -> **`A`**
    //: - `{x=2461,m=1339,a=466,s=291}`: `in` -> `px` -> `qkq` -> `crn` -> **`R`**
    //: - `{x=2127,m=1623,a=2188,s=1013}`: `in` -> `px` -> `rfg` -> **`A`**
    //:
    //: Ultimately, three parts are accepted. Adding up the x, m, a, and s rating for each of the accepted parts gives 7540 for the part with x=787, 4623 for the part with x=2036, and 6951 for the part with x=2127. Adding all of the ratings for **all** of the accepted parts gives the sum total of 19114.
    //:
    //: Sort through all of the parts you've been given; **what do you get if you add together all of the rating numbers for all of the parts that ultimately get accepted?**

    static func solveDay19Puzzle1() -> Int {
        let input = getDay19Input()
            .components(separatedBy: .newlines)
        
        let splitIndex = input.firstIndex(where: \.isEmpty)!
        
        let stateMachine = StateMachine(
            rawWorkflows: input
                .prefix(upTo: splitIndex)
                .filter { !$0.isEmpty }
        )
        
        let parts = input
            .suffix(from: splitIndex)
            .filter { !$0.isEmpty }
            .map { Part(raw: $0) }
        
        return parts
            .filter { stateMachine.resolve(part: $0, startWorkflowName: "in") == .accepted }
            .map { $0.rating.values.sum }
            .sum
    }
    
    //: # --- Part Two ---
    //: Even with your help, the sorting process **still** isn't fast enough.
    
    //: One of the Elves comes up with a new plan: rather than sort parts individually through all of these workflows, maybe you can figure out in advance which combinations of ratings will be accepted or rejected.
    
    //: Each of the four ratings (x, m, a, s) can have an integer value ranging from a minimum of 1 to a maximum of 4000. Of **all possible distinct combinations** of ratings, your job is to figure out which ones will be **accepted**.
    
    static func solveDay19Puzzle2() -> Int {
        let input = getDay19Input()
            .components(separatedBy: .newlines)
        
        let splitIndex = input.firstIndex(where: \.isEmpty)!
        
        let stateMachine = StateMachine(
            rawWorkflows: input
                .prefix(upTo: splitIndex)
                .filter { !$0.isEmpty }
        )
        
        let range = 1 ... 4000
        let cube = Cube(
            ranges: [.x : range, .m: range, .a: range, .s: range]
        )
        
        return stateMachine.volume(cube: cube, redirect: .target("in"))
    }
}

private enum Category {
    case x,m,a,s
    
    init(raw: String) {
        switch raw {
        case "x": self = .x
        case "m": self = .m
        case "a": self = .a
        case "s": self = .s
        default: fatalError()
        }
    }
}

private struct FilterRule {
    let category: Category
    let minValue: Int
    let maxValue: Int
    let redirect: Redirect
    
    init(raw: String) {
        let parts = raw.components(separatedBy: ":")
        redirect = Redirect(raw: parts[1])
        let filter = parts[0]
        if filter.contains(">") {
            let filterParts = filter.components(separatedBy: ">")
            category = Category(raw: filterParts[0])
            minValue = Int(filterParts[1])!
            maxValue = .max
        } else {
            let filterParts = filter.components(separatedBy: "<")
            category = Category(raw: filterParts[0])
            minValue = .min
            maxValue = Int(filterParts[1])!
        }
    }
    
    func redirect(part: Part) -> Redirect? {
        let partRating = part.rating[category]!
        if minValue < partRating, partRating < maxValue {
            return redirect
        }
        return nil
    }
}

private enum Redirect: Equatable {
    case accepted
    case rejected
    case target(String)
    
    init(raw: String) {
        switch raw {
        case "A": self = .accepted
        case "R": self = .rejected
        default: self = .target(raw)
        }
    }
}

private struct Part {
    let rating: [Category: Int]
    
    init(raw: String) {
        //{x=787,m=2655,a=1222,s=2876}
        //{x=2127,m=1623,a=2188,s=1013}
        let categories = raw
            .trimmingCharacters(in: ["{", "}"])
            .components(separatedBy: ",")
        var rating: [Category: Int] = [:]
        for category in categories {
            let parts = category.components(separatedBy: "=")
            rating[Category(raw: parts[0])] = Int(parts[1])!
        }
        
        self.rating = rating
    }
}

private enum Rule {
    case filter(FilterRule)
    case redirect(Redirect)
    
    init(raw: String) {
        if raw.contains(":") {
            self = .filter(FilterRule(raw: raw))
        } else {
            self = .redirect(Redirect(raw: raw))
        }
    }
    
    func redirect(part: Part) -> Redirect? {
        switch self {
        case let .filter(filter):
            return filter.redirect(part: part)
        case let .redirect(redirect):
            return redirect
        }
    }
}

private struct Workflow {
    let name: String
    let rules: [Rule]
    
    init(raw: String) {
        let parts = raw.components(separatedBy: "{")
        name = parts[0]
        var rules = parts[1]
        rules.removeLast()
        self.rules = rules
            .components(separatedBy: ",")
            .map { Rule(raw: $0) }
    }
    
    func redirect(part: Part) -> Redirect {
        for rule in rules {
            if let redirect = rule.redirect(part: part) {
                return redirect
            }
        }
        fatalError("No matching rule found")
    }
}

private struct StateMachine {
    let workflows: [String: Workflow]
    
    init(rawWorkflows: [String]) {
        let workflows = rawWorkflows.map { Workflow(raw: $0) }
        var workflowsDict: [String: Workflow] = [:]
        for workflow in workflows {
            workflowsDict[workflow.name] = workflow
        }
        self.workflows = workflowsDict
    }
    
    func resolve(part: Part, startWorkflowName: String) -> Redirect {
        var workflow = workflows[startWorkflowName]!
        while true {
            let redirect = workflow.redirect(part: part)
            switch redirect {
            case .accepted, .rejected:
                return redirect
            case let .target(workflowName):
                workflow = workflows[workflowName]!
            }
        }
    }
}

private struct Cube: CustomStringConvertible {
    var description: String {
        "\(ranges[.x]!) \(ranges[.m]!) \(ranges[.a]!) \(ranges[.s]!)"
    }
    
    let ranges: [Category: ClosedRange<Int>]
    
    init(ranges: [Category : ClosedRange<Int>]) {
        assert(ranges.count == 4)
        self.ranges = ranges
    }
    
    var isEmpty: Bool {
        ranges.values.contains(where: \.isEmpty)
    }
    
    var volume: Int {
        ranges
            .values
            .reduce(1) { $0 * ($1.upperBound - $1.lowerBound + 1) }
    }
    
    func split(filter: FilterRule) -> (pass: Cube?, fail: Cube?) {
        let range = ranges[filter.category]!
        
        var passRange: ClosedRange<Int>?
        var failRange: ClosedRange<Int>?
        let lowerBound = max(filter.minValue + 1, range.lowerBound)
        let upperBound = min(filter.maxValue - 1, range.upperBound)
        if lowerBound <= upperBound {
            passRange = lowerBound ... upperBound
        }
        
        if filter.maxValue == .max {
            let lowerBound = range.lowerBound
            let upperBound = min(filter.minValue, range.upperBound)
            if lowerBound <= upperBound {
                failRange = lowerBound ... upperBound
            }
        } else {
            let lowerBound = max(filter.maxValue, range.lowerBound)
            let upperBound = range.upperBound
            if lowerBound <= upperBound {
                failRange = lowerBound ... upperBound
            }
        }
        
        return (
            pass: passRange.map { passRange in
                var ranges = ranges
                ranges[filter.category] = passRange
                return Cube(ranges: ranges)
            },
            fail: failRange.map { failRange in
                var ranges = ranges
                ranges[filter.category] = failRange
                return Cube(ranges: ranges)
            }
        )
    }
}

private extension StateMachine {
    func volume(cube: Cube, redirect: Redirect) -> Int {
        var cube = cube
        if cube.isEmpty {
            return 0
        }
        switch redirect {
        case .accepted:
            return cube.volume
        case .rejected:
            return 0
        case let .target(workflowName):
            var result = 0
            let workflow = workflows[workflowName]!
            for rule in workflow.rules {
                switch rule {
                case let .filter(filter):
                    let (pass, fail) = cube.split(filter: filter)
                    if let pass {
                        result += volume(cube: pass, redirect: filter.redirect)
                    }
                    if let fail {
                        cube = fail
                    } else {
                        break
                    }
                case let .redirect(redirect):
                    result += volume(cube: cube, redirect: redirect)
                    break
                }
            }
            
            return result
        }
    }
}
