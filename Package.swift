// swift-tools-version:5.0
//
//  Package.swift
//  M13Checkbox
//
//  Created by McQuilkin, Brandon on 4/13/16.
//  Copyright © 2016 Brandon McQuilkin. All rights reserved.
//

import PackageDescription

let package = Package(
    name: "M13Checkbox",
    platforms: [
        .iOS(.v8)
    ],
    products: [
        .library(name: "M13Checkbox", targets: ["M13Checkbox"]),
    ],
    targets: [
        .target(name: "M13Checkbox", path: "Sources"),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
