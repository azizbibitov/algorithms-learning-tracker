import Foundation

// Benchmark ranking directly: file reading and word counting are not included.
// Each dictionary has fixed-length synthetic keys and counts between 1 and 1,000,
// plus three known winners at 1,001. Repeated counts exercise alphabetical ties.
func makeCounts(size: Int) -> [String: Int] {
    var counts: [String: Int] = [:]
    counts.reserveCapacity(size)
    var state: UInt64 = 42

    for index in 0..<size {
        state = state &* 6_364_136_223_846_793_005 &+ 1
        let word = String(format: "word%06d", index)
        counts[word] = Int((state >> 32) % 1_000) + 1
    }

    for index in 0..<3 {
        counts[String(format: "word%06d", index)] = 1_001
    }
    return counts
}

typealias Entry = (key: String, value: Int)
typealias Ranker = ([String: Int], Int) -> [Entry]

func checkResult(_ result: [Entry], expected: [Entry]) {
    // Validation is outside timing and makes the computed result observable.
    precondition(result.map(\.key) == expected.map(\.key))
    precondition(result.map(\.value) == expected.map(\.value))
}

func milliseconds(_ duration: Duration) -> Double {
    let parts = duration.components
    return Double(parts.seconds) * 1_000
        + Double(parts.attoseconds) / 1_000_000_000_000_000
}

let sizes = [1_000, 10_000, 100_000]
let inputs = sizes.map { makeCounts(size: $0) }
// Independent reference order: no use of the shared isBetter/mergeSort code.
let referenceOrders = inputs.map { counts in
    counts.sorted {
        if $0.value != $1.value { return $0.value > $1.value }
        return $0.key < $1.key
    }
}
var cases: [(inputIndex: Int, limit: Int)] = []
for inputIndex in inputs.indices {
    for limit in [3, 30, 300] {
        cases.append((inputIndex, limit))
    }
}
// Show that keeping half the input and keeping ALL of it are different cases.
cases.append((0, 500))
cases.append((0, 1_000))
let expectedResults = cases.map { Array(referenceOrders[$0.inputIndex].prefix($0.limit)) }
let algorithms: [Ranker] = [
    { topWords(from: $0, limit: $1) },
    { topWordsKeepingBest(from: $0, limit: $1) }
]
let warmupCount = 3
let sampleCount = 11
let clock = ContinuousClock()
var samples = cases.map { _ in [[Double]](repeating: [], count: algorithms.count) }

for caseIndex in cases.indices {
    let scenario = cases[caseIndex]
    for _ in 0..<warmupCount {
        for rank in algorithms {
            checkResult(rank(inputs[scenario.inputIndex], scenario.limit),
                        expected: expectedResults[caseIndex])
        }
    }
}

// Rotate scenario order and alternate algorithm order to reduce order bias.
// Both algorithms receive the SAME dictionary, including its iteration order.
for round in 0..<sampleCount {
    for offset in cases.indices {
        let caseIndex = (offset + round) % cases.count
        let scenario = cases[caseIndex]
        let input = inputs[scenario.inputIndex]
        let algorithmOrder = (round + caseIndex) % 2 == 0 ? [0, 1] : [1, 0]
        for algorithmIndex in algorithmOrder {
            let rank = algorithms[algorithmIndex]
            let start = clock.now
            let result = rank(input, scenario.limit)
            let end = clock.now

            checkResult(result, expected: expectedResults[caseIndex])
            samples[caseIndex][algorithmIndex].append(milliseconds(start.duration(to: end)))
        }
    }
}

print("Ranking comparison — optimized build (swiftc -O)")
print("Full sort = topWords (custom mergeSort of all entries)")
print("Keep best = topWordsKeepingBest (scan candidates, then mergeSort candidates)")
print("\(warmupCount) warm-ups and \(sampleCount) measured calls per algorithm/scenario")
print("Same inputs; alternating algorithm order; rotating scenario order.")
print("Input generation, reference sorting, validation, file I/O, counting, and printing are not timed.")
print("n | limit | Full median ms | Keep median ms | Full/Keep | Full min..max ms | Keep min..max ms")
for caseIndex in cases.indices {
    let scenario = cases[caseIndex]
    let full = samples[caseIndex][0].sorted()
    let keep = samples[caseIndex][1].sorted()
    let fullMedian = full[sampleCount / 2]
    let keepMedian = keep[sampleCount / 2]
    print(String(format: "%d | %d | %.3f | %.3f | %.2fx | %.3f..%.3f | %.3f..%.3f",
                 sizes[scenario.inputIndex], scenario.limit, fullMedian, keepMedian,
                 fullMedian / keepMedian, full.first!, full.last!, keep.first!, keep.last!))
}
print("Full/Keep > 1 means keeping candidates was faster; < 1 means full sorting was faster.")
print("All warm-up and measured results matched the independent reference, including output order.")
print("Fixed synthetic keys/counts; dictionary iteration order can change between processes.")
print("Times describe this machine/run and include allocation and string comparison costs.")
