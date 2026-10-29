import Testing
@testable import TextAnalyzer

@Test
func rankingPrioritizesCountOverAlphabeticalOrder() {
    #expect(isBetter(first: ("zebra", 7), second: ("apple", 4)))
    #expect(!isBetter(first: ("apple", 4), second: ("zebra", 7)))
}

@Test
func rankingBreaksTiesAlphabetically() {
    #expect(isBetter(first: ("apple", 4), second: ("zebra", 4)))
    #expect(!isBetter(first: ("zebra", 4), second: ("apple", 4)))
}

@Test
func identicalEntryIsNotBetterThanItself() {
    #expect(!isBetter(first: ("apple", 4), second: ("apple", 4)))
}
