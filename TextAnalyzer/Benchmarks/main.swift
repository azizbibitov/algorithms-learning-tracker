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

func checkResult(_ result: [(key: String, value: Int)]) {
    // Outside the timed section. Also makes the computed result observable,
    // preventing the optimizer from removing an unused ranking operation.
    precondition(result.map(\.key) == ["word000000", "word000001", "word000002"])
    precondition(result.map(\.value) == [1_001, 1_001, 1_001])
}

func milliseconds(_ duration: Duration) -> Double {
    let parts = duration.components
    return Double(parts.seconds) * 1_000
        + Double(parts.attoseconds) / 1_000_000_000_000_000
}

let sizes = [1_000, 10_000, 100_000]
let inputs = sizes.map { makeCounts(size: $0) }
let limit = 3
let warmupCount = 3
let sampleCount = 31
let clock = ContinuousClock()
var samples = sizes.map { _ in [Double]() }

for input in inputs {
    for _ in 0..<warmupCount {
        checkResult(topWords(from: input, limit: limit))
    }
}

// Interleave the sizes to reduce bias from measuring one size only at the start
// or end. Each sample measures one call; validation and recording happen after.
for _ in 0..<sampleCount {
    for index in inputs.indices {
        let input = inputs[index]
        let start = clock.now
        let result = topWords(from: input, limit: limit)
        let end = clock.now

        checkResult(result)
        samples[index].append(milliseconds(start.duration(to: end)))
    }
}

print("topWords benchmark — optimized build (-O), limit = \(limit)")
print("\(warmupCount) warm-ups and \(sampleCount) measured calls per size")
print("Input generation, validation, file I/O, counting, and printing are not timed.")
print("Distinct words | Median ms | Fastest ms | Slowest ms | Growth")

var previousMedian: Double?
for index in sizes.indices {
    let sortedSamples = samples[index].sorted()
    let median = sortedSamples[sampleCount / 2]
    let fastest = sortedSamples[0]
    let slowest = sortedSamples[sampleCount - 1]
    let growth = previousMedian.map { String(format: "%.2fx", median / $0) } ?? "—"
    print(String(format: "%14d | %9.3f | %10.3f | %10.3f | %@",
                 sizes[index], median, fastest, slowest, growth))
    previousMedian = median
}

print("All measured results matched the expected top three words and counts.")
