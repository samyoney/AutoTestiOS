//
//  HomeScreen.swift
//
//  Copyright © 2022 Click. All rights reserved.
//

import Foundation
import XCTest

var HomeView : _HomeView { get { return _HomeView() } }
class _HomeView: BaseView {
    
    let tabHome = app.buttons["tabHome"]
    let btnLogin  = app.buttons["ログイン"]

    let imgLogo = app.images["homeLogo"]   
    
    func changeToHome() {
        changeMainTab(tabHome)
    }
    
    func goLoginIfNeed(_ isDemoLogined: Bool = false) {
        imgLogo.swipeDownUntilDisplayed()
        btnLogin.click()
    }
}
