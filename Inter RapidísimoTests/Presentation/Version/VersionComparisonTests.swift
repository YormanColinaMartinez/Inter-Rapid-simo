//
//  VersionComparisonTests.swift
//  Inter RapidísimoTests
//
//  Created by mac on 27/12/25.
//

import Foundation

import XCTest
@testable import Inter_Rapidísimo

final class VersionComparisonTests: XCTestCase {

    func testLowerVersion() {
        XCTAssertEqual("1.0".compareVersion(to: "2.0"), .lower)
    }

    func testHigherVersion() {
        XCTAssertEqual("2.0".compareVersion(to: "1.0"), .higher)
    }

    func testEqualVersion() {
        XCTAssertEqual("1.0".compareVersion(to: "1.0"), .equal)
    }

    func testServerBigNumber() {
        XCTAssertEqual("1.0".compareVersion(to: "100"), .lower)
    }

    func testDirtyVersionString() {
        XCTAssertEqual("v1.0".compareVersion(to: "1.0"), .equal)
    }
}
