//
//  Global.swift
//  Refraktions
//
//  Created by Jason Snell on 11/7/15.
//  Copyright © 2015 Jason J. Snell. All rights reserved.
//

import Foundation
import UIKit

public class Screen  {
    
    //MARK:VARS
    public static let ORIENTATION_LANDSCAPE:String = "orientationLandscape"
    public static let ORIENTATION_PORTRAIT:String = "orientationPortrait"
    
    //accessed by root VC when placing settings button
    public static let SETTINGS_BUTTON_SIZE:CGFloat = 50
    
    //MARK: DIMENSIONS
    public static func width() -> CGFloat{
        return UIScreen.main.bounds.width
    }
    
    public static func height() -> CGFloat {
        return UIScreen.main.bounds.height
    }
    
    public static func max() -> CGFloat {
        if (height() > width()){
            return height()
        } else {
            return width()
        }
    }
    
    public static func min() -> CGFloat {
        if (width() < height()){
            return width()
        } else {
            return height()
        }
    }
    
    //MARK:IMAGE SCALE
    public static func scale() -> CGFloat {
        
        return CGFloat(Number.getPercentage(
            value1: Float(max()),
            ofValue2: Float(Device.SCREEN_MAX))) / 100
        
    }
    
    //MARK: ORIENTATION
    public static func orientation() -> String {
        if (height() > width()){
            return ORIENTATION_PORTRAIT
        } else {
            return ORIENTATION_LANDSCAPE
        }
    }
    
    //MARK: ROWS, COLUMNS
    public static func getRowHeight(fromDivider: Int) -> CGFloat {
        return height() / CGFloat(fromDivider)
    }
    
    public static func getColumnWidth(fromDivider:Int) -> CGFloat {
        return width() / CGFloat(fromDivider)
    }
    
    //MARK: PCT OFFSETS
    //this is the percentage of screen real estate that is hidden on the shorter dimension of the layout
    public static func widthPercentageOffset() -> Float {
        if (height() > width()){
            return getPercentageOffset()
        } else {
            return 0
        }
    }
    
    public static func heightPercentageOffset() -> Float {
        if (width() > height()){
            return getPercentageOffset()
        } else {
            return 0
        }
    }
    
    //private helper
    fileprivate static func getPercentageOffset() -> Float {
        return Number.getPercentage(value1: Float((max()-min()) / 2), ofValue2: Float(max()))
    }
    
}
