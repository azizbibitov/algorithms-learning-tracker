// swift-tools-version: 6.4
import PackageDescription

let package = Package(
    name: "TextAnalyzer",
    targets: [
        .executableTarget(name: "TextAnalyzer"),
        .testTarget(
            name: "TextAnalyzerTests",
            dependencies: ["TextAnalyzer"]
        ),
    ]
)
