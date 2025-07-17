// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PDFGenerator",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "PDFGenerator",
            targets: ["PDFGenerator", "QuotationHTML", "PDFToImage"]),
    ],
    dependencies: [
        .package(url: "https://github.com/SwiftPackageIndex/Plot.git", from: "0.14.0"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.6.2")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "QuotationHTML",
            dependencies: [
                .product(name: "Plot", package: "plot")
            ], resources: [
                .copy("Resources/header/quotation-header-01020314.png"),
                .copy("Resources/footer/quotation-footer-01020314.png"),
                .copy("Resources/header/quotation-header-41171816.png"),
                .copy("Resources/footer/quotation-footer-41171816.png"),
                .copy("Resources/header/quotation-header-47575385.png"),
                .copy("Resources/footer/quotation-footer-47575385.png"),
                .copy("Resources/header/quotation-header-47779732.png"),
                .copy("Resources/footer/quotation-footer-47779732.png"),
                .copy("Resources/header/quotation-header-82576039.png"),
                .copy("Resources/footer/quotation-footer-82576039.png"),
                .copy("Resources/header/quotation-header-88183980.png"),
                .copy("Resources/footer/quotation-footer-88183980.png"),
                .copy("Resources/header/quotation-header-34873876.png"),
                .copy("Resources/footer/quotation-footer-34873876.png")
              ]),
        .testTarget(
            name: "PDFGeneratorTests",
            dependencies: ["QuotationHTML"]
        ),
        .target(
            name: "PDFGenerator",
            dependencies: [
                .product(name: "Plot", package: "plot"),
                .product(name: "Logging", package: "swift-log")
            ],
            resources: [
                .copy("Python/pdf_generator.py")
            ]),
        .target(
            name: "PDFToImage",
            dependencies: [
                .product(name: "Logging", package: "swift-log")
            ],
            resources: [
                .copy("Python/pdf_to_image.py")
            ]),
        .executableTarget(name: "Main",
                          dependencies: [
                            "QuotationHTML",
                            "PDFGenerator",
                            "PDFToImage"
                          ])
    ]
)
