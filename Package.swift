// swift-tools-version: 5.4

import PackageDescription

let package = Package(
    name: "SPFirebase",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v12), .macOS(.v10_12), .tvOS(.v12), .watchOS(.v7)
    ],
    products: [
        .library(
            name: "SPFirebaseAuth", 
            targets: ["SPFirebaseAuth"]
        ),
        .library(
            name: "SPFirebaseFirestore",
            targets: ["SPFirebaseFirestore"]
        ),
        .library(
            name: "SPFirebaseMessaging",
            targets: ["SPFirebaseMessaging"]
        )
    ],
    dependencies: [
        .package(name: "Firebase", url: "https://github.com/firebase/firebase-ios-sdk.git", .upToNextMajor(from: "8.11.0"))
    ],
    targets: [
        .target(
            name: "SPFirebase"
        ),
        .target(
            name: "SPFirebaseAuth",
            dependencies: [
                .product(name: "FirebaseAuth", package: "Firebase"),
                .target(name: "SPFirebase")
            ]
        ),
        .target(
            name: "SPFirebaseFirestore",
            dependencies: [
                .product(name: "FirebaseFirestore", package: "Firebase"),
                .target(name: "SPFirebase")
            ]
        ),
        .target(
            name: "SPFirebaseMessaging",
            dependencies: [
                .product(name: "FirebaseMessaging", package: "Firebase"),
                .target(name: "SPFirebase")
            ]
        )
    ]
)
