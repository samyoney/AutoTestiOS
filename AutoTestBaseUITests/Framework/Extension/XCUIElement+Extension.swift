//
//  XCTestcase.swift
//

import Foundation
import XCTest

extension XCUIElement {
    
    func click() {
        if !isDisplayed() {
            InterruptedUtils.handleInterruptedException()
        }
        self.tap()
    }
    
    func doubleClick() {
        if !isDisplayed() {
            InterruptedUtils.handleInterruptedException()
        }
        self.doubleTap()
    }
    
    func clickStatusCheckbox(_ needCheck: Bool) {
        if (needCheck != (value as? String == "1")) {
            click()
        }
    }
    
    func longClick() {
        if !isDisplayed() {
            InterruptedUtils.handleInterruptedException()
        }
        self.press(forDuration: 1)
    }

    func clearText() {
        guard let stringValue = self.value as? String else {
            return
        }
        var deleteString = String()
        for _ in stringValue {
            deleteString += XCUIKeyboardKey.delete.rawValue
        }
        if !isDisplayed() {
            InterruptedUtils.handleInterruptedException()
        }
        typeText(deleteString)
    }
    
    func closeSoftKeyboard() {
        if (app.toolbars.buttons["Done"].exists) {
            app.toolbars.buttons["Done"].tap()
        } else if (app.toolbars.buttons["完了"].exists) {
            app.toolbars.buttons["完了"].tap()
        } else {
            app.typeText("\n")
        }
    }

    @discardableResult
    func getText() -> String {
        if !isDisplayed() {
            InterruptedUtils.handleInterruptedException()
        }
        return self.label
    }
    
    @discardableResult
    func isDisplayed() -> Bool {
        return self.exists && self.isHittable
    }
    
    @discardableResult
    func isNotDisplayed() -> Bool {
        return !self.exists || !self.isHittable
    }
    
    @discardableResult
    func isDisabled() -> Bool {
        return !self.isEnabled
    }
    
    @discardableResult
    func isEnabled() -> Bool {
        return self.isEnabled
    }
    
    @discardableResult
    func isSelected() -> Bool {
        return self.isSelected
    }
    
    func finishSeekBarProgress() {
        if !isDisplayed() {
            InterruptedUtils.handleInterruptedException()
        }
        let startPoint = self.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
        let endPoint = self.coordinate(withNormalizedOffset: CGVector(dx: 9, dy: 0.5))
        startPoint.press(forDuration: 0, thenDragTo: endPoint)
    }
    
    func swipeUpUntilDisplayed(_ speed: XCUIGestureVelocity = XCUIGestureVelocity.fast, _ timeOut: Int64 = 20000) {
        Helper.handleSwipeUntilCommon({ isDisplayed() }, self, {
            Helper.swipeUpScreen(speed)
        }, timeOut)
    }
    
    func swipeLeftUntilDisplayed(_ speed: XCUIGestureVelocity = XCUIGestureVelocity.fast,
                                 _ timeOut: Int64 = 20000) {
        Helper.handleSwipeUntilCommon({ isDisplayed() }, self, {
            Helper.swipeLeftScreen(speed)
        }, timeOut)
    }
    
    func swipeLeftUntilDisable(_ speed: XCUIGestureVelocity = XCUIGestureVelocity.slow,
                                 _ timeOut: Int64 = 20000) {
        Helper.handleSwipeUntilCommon({ isDisabled() }, self, {
            Helper.swipeLeftScreen(speed)
        }, timeOut)
    }
    
    func swipeRightUntilDisable(_ speed: XCUIGestureVelocity = XCUIGestureVelocity.slow,
                                 _ timeOut: Int64 = 20000) {
        Helper.handleSwipeUntilCommon({ isDisabled() }, self, {
            Helper.swipeRightScreen(speed)
        }, timeOut)
    }
    
    
    func swipeDownUntilDisplayed(_ speed: XCUIGestureVelocity = XCUIGestureVelocity.fast, _ timeOut: Int64 = 20000) {
        Helper.handleSwipeUntilCommon({ exists }, self, {
            Helper.swipeDownScreen(speed)
        }, timeOut)
    }
    
    func swipeUpUntilHidden(_ speed: XCUIGestureVelocity = XCUIGestureVelocity.fast, _ timeOut: Int64 = 20000) {
        Helper.handleSwipeUntilCommon({ isNotDisplayed() }, self, {
            Helper.swipeUpScreen(speed)
        }, timeOut)
    }
    
    func swipeDownUntilHidden(_ speed: XCUIGestureVelocity = XCUIGestureVelocity.fast, _ timeOut: Int64 = 20000) {
        Helper.handleSwipeUntilCommon({ isNotDisplayed() }, self, {
            Helper.swipeDownScreen(speed)
        }, timeOut)
    }
    
    func getRealCoordinate(normalizedOffset: CGVector, element: XCUIElement) -> XCUICoordinate {
        guard XCUIDevice.shared.orientation.isLandscape else {
            return element.coordinate(withNormalizedOffset: normalizedOffset)
        }
        let app = XCUIApplication()
        _ = app.isHittable

        let screenPoint = element.coordinate(withNormalizedOffset: normalizedOffset).screenPoint

        let portraitScreenPoint = XCUIDevice.shared.orientation == .landscapeLeft
            ? CGVector(dx: app.frame.width - screenPoint.y, dy: screenPoint.x)
            : CGVector(dx: screenPoint.y, dy: app.frame.height - screenPoint.x)

        return app.coordinate(withNormalizedOffset: CGVector.zero).withOffset(portraitScreenPoint)
    }

    
    func assertDisplayed() {
        XCTAssert(self.exists && self.isHittable)
    }
    
    func assertCompletelyDisplayed() {
        XCTAssert(self.exists && self.isHittable)
    }
    
    func assertNotDisplayed() {
        XCTAssert(!self.exists)
    }
    
    func assertText(_ text: String) {
        XCTAssert(self.label ==  text)
    }
    
    func assertEnabled() {
        XCTAssert(self.isEnabled)
    }
    
    func assertDisabled() {
        XCTAssert(!self.isEnabled)
    }
    
    func assertSelected() {
        XCTAssert(self.isSelected)
    }
    
    func assertNotSelected() {
        XCTAssert(!self.isSelected)
    }

}

extension XCUIElement {
    func tap(at index: UInt) {
        guard buttons.count > 0 else { return }
        var segments = (0..<buttons.count).map { buttons.element(boundBy: $0) }
        segments.sort { $0.frame.origin.x < $1.frame.origin.x }
        segments[Int(index)].tap()
    }
}

extension XCUIElementQuery {
    var lastMatch: XCUIElement { return self.element(boundBy: self.count - 1) }
    
    func getArrayElements() -> [XCUIElement] {
        var listElement: [XCUIElement] = []
        var index = 0
        while self.element(boundBy: index).exists {
            listElement.append(self.element(boundBy: index))
            index += 1
        }
        return listElement
    }
}
