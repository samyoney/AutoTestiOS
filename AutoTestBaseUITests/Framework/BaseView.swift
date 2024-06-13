//
//  BaseScreen.swift
//
//  Copyright © 2022 Click. All rights reserved.
//

import Foundation
import XCTest

class BaseView: BV {
    private let btnBackPairList = app.buttons["戻る"]
    
    internal func changeMainTab(_ tabMenu: XCUIElement) {
        if tabMenu.isDisplayed() {
            tabMenu.click()
        } else {
            if btnBackPairList.isDisplayed() {
                btnBackPairList.click()
            }
            tabMenu.click()
        }
        waitForIdleState()
    }
    
    internal func clickCellWith(_ conditions: String...) {
        let cells = app.tables.firstMatch.cells
        var query: XCUIElementQuery? = nil
        conditions.forEach { it in
            query = cells.containing(.staticText, identifier: it)
        }
        guard let result = query else {
            XCTAssert(false, "Tried but not found cell in table")
            return
        }
        let cell = result.firstMatch
        cell.swipeUpUntilDisplayed()
        result.firstMatch.click()
    }
    
    internal func captureScreen(_ screenName: String = "")  {
        waitForIdleState()
        CaptureImage.captureScreen(false, screenName)
    }
    
    internal func scrollToBottom() {
        app.images["scrollDown"].firstMatch.swipeUpUntilHidden()
    }


    internal func scrollToTop() {
        app.images["scrollUp"].firstMatch.swipeUpUntilHidden()
    }
    
    internal func forceScrollToBottom() {
        guard let element = app.images.matching(identifier: "scrollDown").getArrayElements().filter({$0.isDisplayed()}).first else { return }
        while element.isDisplayed() {
            element.swipeUpUntilHidden()
        }
    }


    internal func forceScrollToTop() {
        guard let element = app.images.matching(identifier: "scrollUp").getArrayElements().filter({$0.isDisplayed()}).first else { return }
        while element.isDisplayed() {
            element.swipeDownUntilHidden()
        }
    }
}

@dynamicCallable
protocol BV {
}

extension BV {
    internal func waitForIdleState() {
        InterruptedUtils.waitForIdleState()
    }

    func dynamicallyCall(withArguments args: [(Self) -> ()]) {
        apply(block: args[0])
    }
        
    func closeWebViewIfExisting() {
        waitForIdleState()
        app.activate()
        waitForIdleState()
    }

    @discardableResult
    @inline(__always) func apply(block: (Self) -> ()) -> Self {
        waitForIdleState()
        block(self)
        return self
    }
}
