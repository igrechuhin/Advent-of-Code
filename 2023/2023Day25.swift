import Foundation

private let testInput = false

extension AoC2023 {
    private static func getDay25Input() -> String {
        if testInput {
"""
jqt: rhn xhk nvd
rsh: frs pzl lsr
xhk: hfx
cmg: qnr nvd lhk bvb
rhn: xhk bvb hfx
bvb: xhk hfx
pzl: lsr hfx nvd
qnr: nvd
ntq: jqt hfx bvb xhk
nvd: lhk
lsr: lhk
rzs: qnr cmg lsr rsh
frs: qnr lhk lsr
"""
        } else {
            getInput(fileName: "Day25Input")
        }
    }
    
    //: # --- Day 25: Snowverload ---
    //: **Still** somehow without snow, you go to the last place you haven't checked: the center of Snow Island, directly below the waterfall.
    //:
    //: Here, someone has clearly been trying to fix the problem. Scattered everywhere are hundreds of weather machines, almanacs, communication modules, hoof prints, machine parts, mirrors, lenses, and so on.
    //:
    //: Somehow, everything has been **wired together** into a massive snow-producing apparatus, but nothing seems to be running. You check a tiny screen on one of the communication modules: `Error 2023`. It doesn't say what `Error 2023` means, but it **does** have the phone number for a support line printed on it.
    //:
    //: "Hi, you've reached Weather Machines And So On, Inc. How can I help you?" You explain the situation.
    //:
    //: "Error 2023, you say? Why, that's a power overload error, of course! It means you have too many components plugged in. Try unplugging some components and--" You explain that there are hundreds of components here and you're in a bit of a hurry.
    //:
    //: "Well, let's see how bad it is; do you see a **big red reset button** somewhere? It should be on its own module. If you push it, it probably won't fix anything, but it'll report how overloaded things are." After a minute or two, you find the reset button; it's so big that it takes two hands just to get enough leverage to push it. Its screen then displays:
    //:
    //: ```
    //: SYSTEM OVERLOAD!
    //:
    //: Connected components would require
    //: power equal to at least 100 stars!
    //: ```
    //:
    //: "Wait, **how** many components did you say are plugged in? With that much equipment, you could produce snow for an **entire**--" You disconnect the call.
    //:
    //: You have nowhere near that many stars - you need to find a way to disconnect at least half of the equipment here, but it's already Christmas! You only have time to disconnect **three wires**.
    //:
    //: Fortunately, someone left a wiring diagram (your puzzle input) that shows **how the components are connected**. For example:
    //:
    //: ```
    //: jqt: rhn xhk nvd
    //: rsh: frs pzl lsr
    //: xhk: hfx
    //: cmg: qnr nvd lhk bvb
    //: rhn: xhk bvb hfx
    //: bvb: xhk hfx
    //: pzl: lsr hfx nvd
    //: qnr: nvd
    //: ntq: jqt hfx bvb xhk
    //: nvd: lhk
    //: lsr: lhk
    //: rzs: qnr cmg lsr rsh
    //: frs: qnr lhk lsr
    //: ```
    //:
    //: Each line shows the **name of a component**, a colon, and then **a list of other components** to which that component is connected. Connections aren't directional; `abc: xyz` and `xyz: abc` both represent the same configuration. Each connection between two components is represented only once, so some components might only ever appear on the left or right side of a colon.
    //:
    //: In this example, if you disconnect the wire between `hfx/pzl`, the wire between `bvb/cmg`, and the wire between `nvd/jqt`, you will **divide the components into two separate, disconnected groups**:
    //:
    //: - 9 components: `cmg`, `frs`, `lhk`, `lsr`, `nvd`, `pzl`, `qnr`, `rsh`, and `rzs`.
    //: - 6 components: `bvb`, `hfx`, `jqt`, `ntq`, `rhn`, and `xhk`.
    //: Multiplying the sizes of these groups together produces **`54`**.
    //:
    //: Find the three wires you need to disconnect in order to divide the components into two separate groups. **What do you get if you multiply the sizes of these two groups together?**
    
    fileprivate typealias Edge = Set<String>
    fileprivate typealias Graph = [String: Edge]
    fileprivate typealias EdgesFrequency = [Edge: Int]
    
    private static func buildGraph() -> Graph {
        let input = getDay25Input()
            .components(separatedBy: .newlines)
            .filter { !$0.isEmpty }
        
        var nodes: Graph = [:]
        for raw in input {
            let parts = raw.components(separatedBy: ":")
            
            let lhsName = parts[0]
            let lhs = nodes[lhsName] ?? Set<String>()
            nodes[lhsName] = lhs
            
            let rhsNames = parts[1]
                .trimmingCharacters(in: .whitespaces)
                .components(separatedBy: .whitespaces)
            for rhsName in rhsNames {
                nodes[lhsName]!.insert(rhsName)
                nodes[rhsName, default: []].insert(lhsName)
            }
        }
        return nodes
    }
    
    fileprivate struct Step {
        let name: String
        var edges: [Edge] = []
    }
    
    static func solveDay25Puzzle1() -> Int {
        let graph = buildGraph()
        
        let edgeFrequency = graph.edgesFrequency()
        let edgesSortedByFrequency: [Set<String>] = edgeFrequency.keys.sorted {
            edgeFrequency[$0]! < edgeFrequency[$1]!
        }
        let edgesToRemove = Array(edgesSortedByFrequency.suffix(3))
        
        let reducedGraph = graph.removingEdges(edgesToRemove)
        
        let reducedGraphSize1 = reducedGraph.size(start: reducedGraph.keys.first!)
        let reducedGraphSize2 = reducedGraph.count - reducedGraphSize1
        
        return reducedGraphSize1 * reducedGraphSize2
    }
    
    //: # --- Part Two ---
    //: You climb over weather machines, under giant springs, and narrowly avoid a pile of pipes as you find and disconnect the three wires.
    //:
    //: A moment after you disconnect the last wire, the big red reset button module makes a small ding noise:
    //:
    //: System overload resolved!
    //: Power required is now 50 stars.
    //: Out of the corner of your eye, you notice goggles and a loose-fitting hard hat peeking at you from behind an ultra crucible. You think you see a faint glow, but before you can investigate, you hear another small ding:
    //:
    //: Power required is now 49 stars.
    //:
    //: Please supply the necessary stars and
    //: push the button to restart the system.
    //: If you like, you can **Push The Big Red Button Again**.
}

private extension AoC2023.Graph {
    func edgesFrequency() -> AoC2023.EdgesFrequency {
        
        var edgeFrequency: AoC2023.EdgesFrequency = [:]
        
        let nodes = Array(keys)
        
        let lock = NSLock()
        let group = DispatchGroup()
        
        for startIndex in 0 ..< nodes.count {
            group.enter()
            DispatchQueue.global(qos: .utility).async {
                let start: String = nodes[startIndex]
                for endIndex in startIndex + 1 ..< nodes.count {
                    let end: String = nodes[endIndex]
                    //                    logger.debug("\(startIndex) : \(endIndex)")
                    
                    var queue = [AoC2023.Step(name: start)]
                    var visited = Set([start])
                    while !queue.isEmpty {
                        let current = queue.removeFirst()
                        
                        if current.name == end {
                            lock.lock()
                            for edge in current.edges {
                                edgeFrequency[edge, default: 0] += 1
                            }
                            lock.unlock()
                            break
                        }
                        
                        self[current.name, default: []]
                            .filter { !visited.contains($0) }
                            .forEach { node in
                                visited.insert(current.name)
                                queue.append(
                                    AoC2023.Step(name: node, edges: current.edges + [[current.name, node]])
                                )
                            }
                    }
                }
                group.leave()
            }
        }
        
        group.wait()
        
        return edgeFrequency
    }
    
    func size(start: String) -> Int {
        var queue = [start]
        var visited = Set(queue)
        while !queue.isEmpty {
            let current = queue.removeFirst()
            self[current, default: []]
                .filter { !visited.contains($0) }
                .forEach { node in
                    visited.insert(node)
                    queue.append(node)
                }
        }
        return visited.count
    }
    
    func removingEdges(_ edges: [AoC2023.Edge]) -> AoC2023.Graph {
        var graph = self
        for edge in edges {
            let pair = Array(edge)
            graph[pair.first!]!.remove(pair.last!)
            graph[pair.last!]!.remove(pair.first!)
        }
        return graph
    }
}
