import Testing
@testable import TextAnalyzer

@Test
func higherCountsRankBeforeAlphabeticallyEarlierWords() {
    let result = topWords(from: ["apple": 1, "mango": 2, "zebra": 3], limit: 3)

    #expect(result.map(\.key) == ["zebra", "mango", "apple"])
    #expect(result.map(\.value) == [3, 2, 1])
}

@Test
func equalCountsRankAlphabetically() {
    let result = topWords(from: ["zebra": 2, "apple": 2, "mango": 2], limit: 3)

    #expect(result.map(\.key) == ["apple", "mango", "zebra"])
    #expect(result.map(\.value) == [2, 2, 2])
}

@Test
func limitIsAppliedAfterRankingIncludingTies() {
    let result = topWords(
        from: ["cherry": 1, "banana": 2, "zebra": 3, "apple": 2],
        limit: 2
    )

    #expect(result.map(\.key) == ["zebra", "apple"])
    #expect(result.map(\.value) == [3, 2])
}

@Test
func emptyCountsProduceNoRankedWords() {
    let result = topWords(from: [:], limit: 3)

    #expect(result.isEmpty)
}

@Test
func limitLargerThanWordCountReturnsAllWords() {
    let result = topWords(from: ["apple": 1, "zebra": 2], limit: 10)

    #expect(result.map(\.key) == ["zebra", "apple"])
    #expect(result.map(\.value) == [2, 1])
}

@Test
func zeroLimitReturnsNoWords() {
    let result = topWords(from: ["swift": 3], limit: 0)

    #expect(result.isEmpty)
}

@Test
func negativeLimitReturnsNoWords() {
    let result = topWords(from: ["swift": 3], limit: -2)

    #expect(result.isEmpty)
}
