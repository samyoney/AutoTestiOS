//
//  LoginScreen.swift
//

import UIKit
import XCTest

var LoginView : LoginViewTemp { get { return LoginViewTemp() } }
class LoginViewTemp: BaseView {
    
    let btnBack = app.staticTexts["閉じる"]

    func backToPreview() {
        btnBack.click()
    }
}

