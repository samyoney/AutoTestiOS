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
    
    final func handleLoginIfNeed(_ needLoginDemo: Bool = false) {
        HomeView {
            $0.changeToHome()
            let isDemoLogined = $0.isDemoLogined()
            let isRealLogined = $0.isRealLogined()
            let needLogin = needLoginDemo ? !isDemoLogined : !isRealLogined
            if (needLogin) {
                $0.goLoginIfNeed(isDemoLogined)
                LoginView {
                    if needLoginDemo {
                        $0.loginDemo()
                    } else {
                        $0.typeAccountPassword("C15133361", "password")
                        $0.settingLoginStatus(true, true, true, false)
                        $0.loginReal()
                    }
                }
            }
        }
       
    }
}

