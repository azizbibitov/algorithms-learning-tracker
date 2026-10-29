import Testing
@testable import TextAnalyzer

@Test
func keepingBestSelectsAndOrdersCountsWithTiesAtCutoff() {
    let result = topWordsKeepingBest(
        from: ["apple": 4, "zebra": 4, "cat": 7, "dog": 1, "bird": 4],
        limit: 3
    )

    #expect(result.map(\.key) == ["cat", "apple", "bird"])
    #expect(result.map(\.value) == [7, 4, 4])
}

@Test
func keepingBestSelectsAlphabeticallyWhenAllCountsMatch() {
    let result = topWordsKeepingBest(
        from: ["zebra": 2, "cat": 2, "bird": 2, "apple": 2],
        limit: 2
    )

    #expect(result.map(\.key) == ["apple", "bird"])
    #expect(result.map(\.value) == [2, 2])
}

@Test
func keepingBestHandlesEmptyInputAndNonpositiveLimits() {
    #expect(topWordsKeepingBest(from: [:], limit: 3).isEmpty)
    for limit in [-2, 0] {
        #expect(topWordsKeepingBest(from: ["swift": 3], limit: limit).isEmpty)
    }
}

@Test
func keepingBestReturnsAllWordsWhenLimitReachesInputSize() {
    for limit in [3, 10] {
        let result = topWordsKeepingBest(
            from: ["zebra": 2, "apple": 2, "cat": 7], limit: limit
        )
        #expect(result.map(\.key) == ["cat", "apple", "zebra"])
        #expect(result.map(\.value) == [7, 2, 2])
    }
}

@Test
func bothRankingAlgorithmsMatchIndependentSortAcrossSmallInputs() {
    let words = ["apple", "bird", "cat", "zebra"]

    // All 3^4 assignments of counts 1...3, including ties at every cutoff.
    for scenario in 0..<81 {
        var number = scenario
        var counts: [String: Int] = [:]
        for word in words {
            counts[word] = number % 3 + 1
            number /= 3
        }

        // Deliberately do not use isBetter or mergeSort for the expectation:
        // agreement between two algorithms sharing a bug would not be enough.
        let expectedOrder = counts.sorted {
            if $0.value != $1.value { return $0.value > $1.value }
            return $0.key < $1.key
        }

        for limit in [-1, 0, 1, 2, 3, 4, 5] {
            let expected = Array(expectedOrder.prefix(max(0, limit)))
            let fullSort = topWords(from: counts, limit: limit)
            let selection = topWordsKeepingBest(from: counts, limit: limit)

            #expect(fullSort.map(\.key) == expected.map(\.key))
            #expect(fullSort.map(\.value) == expected.map(\.value))
            #expect(selection.map(\.key) == expected.map(\.key))
            #expect(selection.map(\.value) == expected.map(\.value))
        }
    }
}
