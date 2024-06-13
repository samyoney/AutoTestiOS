//
//  BaseUITests.swift
//
//  Copyright © 2022 Click. All rights reserved.
//

import XCTest

class BaseTest: XCTestCase {

    override func setUp() {
        super.setUp()
        Environment.currentTestCase = self
        Environment.screenShotName = self.name.replacingOccurrences(of: "-", with: "").replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "").components(separatedBy: " ").last ?? ""
        continueAfterFailure = false
        if(app.exists) {
            app.terminate()
        }
        app.launchArguments = ["-xcuitest"]
        app.launch()
    }
    
    override func tearDown() {
        if(getTestRunStatus() > 0){
            CaptureImage.captureScreen(true)
        }
        app.terminate()
        super.tearDown()
    }
    
    private func getTestRunStatus() -> Int{
        return Int(self.testRun?.failureCount ?? 0)
    }
}

