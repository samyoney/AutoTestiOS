//
//  SC_002_Login.swift
//
//  Copyright © 2022 Click. All rights reserved.
//

import XCTest

class SCLogin: BaseTest {
    func test_sc_001_Login() {
        HomeView {
            $0.changeToHome()
            $0.goLoginIfNeed()
        }
        LoginView {
            $0.captureScreen("Vertical")
            $0.backToPreview()
        }
    }
    
}

