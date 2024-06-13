//
//  CaptureImage.swift
//
//  Created by グエン ホン ソン on 2022/12/16.
//  Copyright © 2022 Click. All rights reserved.
//

import Foundation
import XCTest

class CaptureImage {
    static func captureScreen(_ isTestFail: Bool = false, _ screenName: String = "") {
        let attachment = XCTAttachment(image: getMainContentImage(), quality:  .medium)
        attachment.lifetime = .keepAlways
        let pathName =  screenName.isEmpty ? screenName : "_" + screenName
        attachment.name = !isTestFail ? Environment.screenShotName + pathName : "Failure_" + Environment.screenShotName
        Environment.currentTestCase?.add(attachment)
    }
    
    private static func getMainContentImage() -> UIImage {
        let statusBar = XCUIApplication(bundleIdentifier: "com.apple.springboard").statusBars.firstMatch
        var statusBarHeight = 1.0
        if statusBar.exists {
            statusBarHeight = statusBar.screenshot().image.size.height
        }
        
        let screenImage = mainScreen.screenshot().image
        let screenSize = screenImage.size
        let screenScale = screenImage.scale
        let crop = CGRectMake(0, statusBarHeight * screenScale, screenSize.width * screenScale, (screenSize.height - statusBarHeight) * screenScale)
        
        if let cgImage = screenImage.cgImage?.cropping(to: crop), statusBarHeight != 1.0 && statusBarHeight < 100 {
            return UIImage(cgImage: cgImage)
        } else {
            return screenImage
        }
    }
    
}
