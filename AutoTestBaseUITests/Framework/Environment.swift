//
//  Environment.swift
//

import Foundation
import XCTest

let app = XCUIApplication()
let mainScreen = XCUIScreen.main
let device = XCUIDevice.shared

class Environment {
    public static var screenShotName = ""
    public static var currentTestCase: BaseTest? = nil
}
