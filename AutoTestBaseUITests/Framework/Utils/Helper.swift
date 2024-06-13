//
//  Helper.swift
//

import Foundation
import XCTest

class Helper {
    private static let rootView = app.windows.firstMatch

    static func pushLogDebug(_ message: String) {
        print("FXNeo \(message)")
    }
    
    static func randomBool() -> Bool {
        return Bool.random()

    }
    
    static func randomInt(_ from: Int, _ until: Int) -> Int {
        return Int.random(in: from...until)
    }
    
    static func randomDouble(_ from: Double, _ until: Double) -> Double {
        return Double(String(format: "%.1f", Double.random(in: from...until))) ?? 0.1
    }
    
    static func randomElementInArray<T>(_ arr: [T]) -> T? {
        guard !arr.isEmpty else {
            return nil
        }
        let randomIndex = Int.random(in: 0..<arr.count)
        return arr[randomIndex]
    }
    
    static func handleSwipeUntilCommon(_ untilVisible: () -> Bool, _ element: XCUIElement, _ action:@escaping () throws -> (), _ timeout: Int64) {
        var isSuccess: Bool = false
        let endTime = (Int64(DispatchTime.now().uptimeNanoseconds) / 1000000) + timeout
        while((Int64(DispatchTime.now().uptimeNanoseconds) / 1000000) < endTime && !isSuccess) {
            do {
                isSuccess = untilVisible()
                if !isSuccess {
                    try action()
                }
            }
            catch {
                isSuccess = !untilVisible()
                print(error)
            }
            if isSuccess {
                InterruptedUtils.waitForViewRedrawed()
            }
        }
    }
    
    @discardableResult
    static func waitForPredicate(_ block: @escaping () -> Bool, _ timeout: TimeInterval = 15) -> Bool {
        let predicate = NSPredicate(value: block())
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: self)
        let waiter = XCTWaiter()
        switch waiter.wait(for: [expectation], timeout: timeout) {
        case .completed:
            return true
        default:
            return false
        }
    }
    
    static func swipeUpScreen(_ speed: XCUIGestureVelocity = XCUIGestureVelocity.fast) {
        let startPoint = rootView.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.7))
        let endPoint = rootView.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
        startPoint.press(forDuration: 0, thenDragTo: endPoint, withVelocity: speed, thenHoldForDuration: 0)

    }
        
    static func swipeDownScreen(_ speed: XCUIGestureVelocity = XCUIGestureVelocity.fast) {
        let startPoint = rootView.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
        let endPoint = rootView.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.7))
        startPoint.press(forDuration: 0, thenDragTo: endPoint, withVelocity: speed, thenHoldForDuration: 0)
    }
    
    static func swipeLeftScreen(_ speed: XCUIGestureVelocity = XCUIGestureVelocity.fast) {
        let startPoint = rootView.coordinate(withNormalizedOffset: CGVector(dx: 0.9, dy: 0.5))
        let endPoint = rootView.coordinate(withNormalizedOffset: CGVector(dx: 0.1, dy: 0.5))
        startPoint.press(forDuration: 0, thenDragTo: endPoint, withVelocity: speed, thenHoldForDuration: 0)
    }
    
    static func swipeRightScreen(_ speed: XCUIGestureVelocity = XCUIGestureVelocity.fast) {
        let startPoint = rootView.coordinate(withNormalizedOffset: CGVector(dx: 0.1, dy: 0.5))
        let endPoint = rootView.coordinate(withNormalizedOffset: CGVector(dx: 0.9, dy: 0.5))
        startPoint.press(forDuration: 0, thenDragTo: endPoint, withVelocity: speed, thenHoldForDuration: 0)
    }
}
