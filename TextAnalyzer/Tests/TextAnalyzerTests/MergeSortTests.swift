import Testing
@testable import TextAnalyzer

@Test
func mergeSortAcceptsEmptyInput() {
    #expect(mergeSort(array: []).isEmpty)
}

@Test
func mergeSortPreservesSingleEntry() {
    let result = mergeSort(array: [(key: "cat", value: 3)])

    #expect(result.map(\.key) == ["cat"])
    #expect(result.map(\.value) == [3])
}

@Test
func mergeSortOrdersUnsortedHalves() {
    let input = [(key: "cat", value: 3), (key: "zebra", value: 8),
                 (key: "dog", value: 1), (key: "apple", value: 6)]

    let result = mergeSort(array: input)

    #expect(result.map(\.key) == ["zebra", "apple", "cat", "dog"])
    #expect(result.map(\.value) == [8, 6, 3, 1])
}

@Test
func mergeSortHandlesOddLengthAndTiesAcrossHalves() {
    let input = [(key: "zebra", value: 2), (key: "dog", value: 1),
                 (key: "banana", value: 2), (key: "cat", value: 3),
                 (key: "apple", value: 2)]

    let result = mergeSort(array: input)

    #expect(result.map(\.key) == ["cat", "apple", "banana", "zebra", "dog"])
    #expect(result.map(\.value) == [3, 2, 2, 2, 1])
}

@Test
func mergesTwoSortedWordLists() {
    let left = [(key: "zebra", value: 8), (key: "cat", value: 3)]
    let right = [(key: "apple", value: 6), (key: "dog", value: 1)]

    let result = merge(left, right)

    #expect(result.map(\.key) == ["zebra", "apple", "cat", "dog"])
    #expect(result.map(\.value) == [8, 6, 3, 1])
}

@Test
func mergeKeepsAllRemainingLeftEntries() {
    let left = [(key: "zebra", value: 8), (key: "cat", value: 3), (key: "dog", value: 1)]
    let right = [(key: "apple", value: 6)]

    let result = merge(left, right)

    #expect(result.map(\.key) == ["zebra", "apple", "cat", "dog"])
    #expect(result.map(\.value) == [8, 6, 3, 1])
}

@Test
func mergeKeepsAllRemainingRightEntries() {
    let left = [(key: "zebra", value: 8)]
    let right = [(key: "apple", value: 6), (key: "cat", value: 3), (key: "dog", value: 1)]

    let result = merge(left, right)

    #expect(result.map(\.key) == ["zebra", "apple", "cat", "dog"])
    #expect(result.map(\.value) == [8, 6, 3, 1])
}

@Test
func mergeAcceptsEmptyLeftInput() {
    let result = merge([], [(key: "apple", value: 6), (key: "dog", value: 1)])

    #expect(result.map(\.key) == ["apple", "dog"])
    #expect(result.map(\.value) == [6, 1])
}

@Test
func mergeAcceptsEmptyRightInput() {
    let result = merge([(key: "apple", value: 6), (key: "dog", value: 1)], [])

    #expect(result.map(\.key) == ["apple", "dog"])
    #expect(result.map(\.value) == [6, 1])
}

@Test
func mergeAcceptsTwoEmptyInputs() {
    #expect(merge([], []).isEmpty)
}

@Test
func mergeChoosesLeftWordWhenItComesFirstAlphabetically() {
    let result = merge([(key: "apple", value: 2)], [(key: "zebra", value: 2)])

    #expect(result.map(\.key) == ["apple", "zebra"])
    #expect(result.map(\.value) == [2, 2])
}

@Test
func mergeChoosesRightWordWhenItComesFirstAlphabetically() {
    let result = merge([(key: "zebra", value: 2)], [(key: "apple", value: 2)])

    #expect(result.map(\.key) == ["apple", "zebra"])
    #expect(result.map(\.value) == [2, 2])
}
