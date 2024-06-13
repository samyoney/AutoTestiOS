//
//  InterruptedUtils.swift
//
//  Created by グエン ホン ソン on 2023/01/13.
//  Copyright © 2023 Click. All rights reserved.
//

import Foundation

class InterruptedUtils {
    static func handleInterruptedException() {
        closeSystemDialogIfExisting()
        closeNoticeDialogIfExisting()
        closeReviewDialogIfExisting()
        closeInAppMessagingViewIfExisting()
        closePriceAlertDialogIfExisting()
    }

    private static func closeSystemDialogIfExisting() {
        let positiveButton = app.alerts.element(boundBy: 1)
        let negativeButton = app.alerts.element(boundBy: 0)
        if positiveButton.isDisplayed() {
            positiveButton.tap()
            waitForIdleState()
        } else if negativeButton.isDisplayed() {
            negativeButton.tap()
        }
    }
    
    private static func closeNoticeDialogIfExisting() {
        let noticeDialogCloseButton = app.buttons["あとで"]
        let noticeDialogConfirmButton = app.buttons["確認する"]
        if noticeDialogCloseButton.isDisplayed() && noticeDialogConfirmButton.isDisplayed() {
            noticeDialogCloseButton.tap()
        }
    }
    
    
    private static func closeReviewDialogIfExisting() {
        let dialogReviewRealButton = app.buttons["Not Now"]
        if dialogReviewRealButton.isDisplayed() {
            dialogReviewRealButton.tap()
        }
    }
        
    private static func closeInAppMessagingViewIfExisting() {
        let inAppCloseButton = app.buttons["close-button"]
        if inAppCloseButton.isDisplayed() {
            inAppCloseButton.tap()
        }
    }
    
    private static func closePriceAlertDialogIfExisting() {
        let priceDialogTitle = app.staticTexts["ご指定のレートに達しました"]
        if priceDialogTitle.isDisplayed() {
            app.buttons["閉じる"].tap()
        }
    }

    static func waitForIdleState() {
        waitForViewRedrawed()
        let loading = app.otherElements["loader"].firstMatch
        Helper.waitForPredicate({
            !loading.exists
        }, 15)
        waitForViewRedrawed()
    }
    
    static func waitForViewRedrawed() {
        Thread.sleep(forTimeInterval: 0.1)
    }
}
