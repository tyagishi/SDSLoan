// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SDSLoan",
    platforms: [
        .macOS(.v13),
        .iOS(.v16)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SDSLoan",
            targets: ["SDSLoan"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/tyagishi/SDSFoundationExtension", from: "1.2.2"),
        .package(url: "https://github.com/tyagishi/SDSSwiftExtension", from: "2.1.2"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SDSLoan",
            dependencies: ["SDSFoundationExtension", "SDSSwiftExtension"]
        ),
        .testTarget(
            name: "SDSLoanTests",
            dependencies: ["SDSLoan"]
        ),
    ]
)
