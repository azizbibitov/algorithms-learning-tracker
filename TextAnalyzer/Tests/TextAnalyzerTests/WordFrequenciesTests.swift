import Testing
@testable import TextAnalyzer

@Test
func emptyInputHasNoWords() {
    let counts = wordFrequencies(in: "", ignoring: [])

    #expect(counts.isEmpty)
}

@Test
func repeatedWordsAreCounted() {
    let counts = wordFrequencies(in: "swift swift code", ignoring: [])

    #expect(counts == ["swift": 2, "code": 1])
}

@Test
func countingIgnoresCase() {
    let counts = wordFrequencies(in: "Swift SWIFT swift Code", ignoring: [])

    #expect(counts == ["swift": 3, "code": 1])
}

@Test
func whitespaceSeparatesWords() {
    let counts = wordFrequencies(in: "  swift\tcode\nswift\r\ncode  ", ignoring: [])

    #expect(counts == ["swift": 2, "code": 2])
}

@Test
func punctuationSeparatesWordsWithoutSpaces() {
    let counts = wordFrequencies(in: "swift,code!swift?code...", ignoring: [])

    #expect(counts == ["swift": 2, "code": 2])
}

@Test
func digitsAndSymbolsSeparateWords() {
    let counts = wordFrequencies(in: "swift123code+swift😀code", ignoring: [])

    #expect(counts == ["swift": 2, "code": 2])
}

@Test
func inputWithoutLettersHasNoWords() {
    let counts = wordFrequencies(in: " \t\n123...!?+😀 ", ignoring: [])

    #expect(counts.isEmpty)
}

@Test
func lettersFromOtherLanguagesAreCounted() {
    let counts = wordFrequencies(in: "CAFÉ café Привет привет", ignoring: [])

    #expect(counts == ["café": 2, "привет": 2])
}

@Test
func ignoredWordsAreExcludedRegardlessOfInputCase() {
    let counts = wordFrequencies(
        in: "The cat and THE dog. The cat IS happy.",
        ignoring: ["the", "and", "is"]
    )

    #expect(counts == ["cat": 2, "dog": 1, "happy": 1])
}

@Test
func ignoringEveryWordProducesEmptyCounts() {
    let counts = wordFrequencies(in: "THE and is the", ignoring: ["the", "and", "is"])

    #expect(counts.isEmpty)
}

@Test
func ignoringAWordDoesNotRemovePartsOfOtherWords() {
    let counts = wordFrequencies(in: "the theater other theater", ignoring: ["the"])

    #expect(counts == ["theater": 2, "other": 1])
}
