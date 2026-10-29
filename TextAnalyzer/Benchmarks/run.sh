#!/bin/bash
set -euo pipefail

# Run with: bash TextAnalyzer/Benchmarks/run.sh (from the repository root).
# Compile the actual ranking implementation with release optimization.
# Temporary build output is removed when this script exits.
benchmark_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
build_dir="$(mktemp -d "${TMPDIR:-/tmp}/text-analyzer-benchmark.XXXXXX")"
trap 'rm -rf -- "$build_dir"' EXIT

swiftc -O \
    "$benchmark_dir/../Sources/TextAnalyzer/TopWords.swift" \
    "$benchmark_dir/../Sources/TextAnalyzer/TopWordsKeepingBest.swift" \
    "$benchmark_dir/../Sources/TextAnalyzer/MergeSort.swift" \
    "$benchmark_dir/../Sources/TextAnalyzer/WordRanking.swift" \
    "$benchmark_dir/main.swift" \
    -o "$build_dir/top-words-benchmark"

"$build_dir/top-words-benchmark"
