// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PDFGenerator",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Quotation",
            targets: ["Quotation"]),
    ],
    dependencies: [
        .package(url: "https://github.com/SwiftPackageIndex/Plot.git", from: "0.14.0"),
        .package(url: "https://github.com/pvieito/PythonKit.git", from: "0.5.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Quotation",
            dependencies: [
                .product(name: "Plot", package: "plot")
            ], resources: [
                .copy("Resources/quotation-footer.png"),
                .copy("Resources/quotation-header.png")
              ]),
        .testTarget(
            name: "PDFGeneratorTests",
            dependencies: ["Quotation"]
        ),
        .target(
            name: "PDFGenerator",
            dependencies: [
                .product(name: "Plot", package: "plot"),
                .product(name: "PythonKit", package: "pythonkit")
            ]),
        .executableTarget(name: "Main",
                          dependencies: [
                            "Quotation",
                            "PDFGenerator"
                          ])
    ]
)
