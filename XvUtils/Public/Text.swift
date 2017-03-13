//
//  TextFormatter.swift
//  Refraktions
//
//  Created by Jason Snell on 3/10/16.
//  Copyright © 2016 Jason J. Snell. All rights reserved.
//


import UIKit

public class Text{
    
    fileprivate let debug:Bool = false
    
    //MARK: Library of fonts used in apps
    public static let HELV_NEUE_CON_BOLD:String = "HelveticaNeue-CondensedBold"
    public static let HELV_REGULAR:String = "Helvetica"
    public static let HELV_BOLD:String = "Helvetica-Bold"
    
    
    //MARK: - PUBLIC API -
    //MARK: CREATE
    public static func createLabel(
        text:String,
        fontName:String,
        size:CGFloat,
        alignment:NSTextAlignment) -> UILabel?{
        
        //debug
        //let _:Bool = isFontValid(fontName: fontName)
        
        //create font and see if there is an error
        
        if let font:UIFont = UIFont(name: fontName, size: size){
            
            let label:UILabel = UILabel()
            
            //set text
            set(label:label, withText:text)
            
            //font created, format it
            label.font = font
            label.textColor = UIColor.white
            label.textAlignment = alignment
            
            //default position 0, 0
            label.frame = CGRect(
                x: 0, y: 0,
                width: label.intrinsicContentSize.width,
                height: label.intrinsicContentSize.height)
            
            return label
            
        } else {
            
            print("TEXT: Error creating font for label")
            
            
        }

        
        return nil
        
    }
    
    //MARK: POSITION
    public static func position(label:UILabel, x:CGFloat, y:CGFloat, centered:Bool){
        
        label.frame = CGRect(x: x, y: y, width: label.intrinsicContentSize.width, height: label.intrinsicContentSize.height)
        
        if (centered){
            let centerPoint:CGPoint = CGPoint(x: x, y: y)
            label.center = centerPoint
        }
        
    }
    
    //MARK: SET TEXT
    public static func set(label:UILabel, withText:String){
        
        //let attrStr = NSMutableAttributedString(string: withText.uppercased())
        //label.attributedText = attrStr
        label.text = withText
        
    }
    
    //MARK: VALIDITY TEST
    public static func isFontValid(fontName:String) -> Bool {
        
        //check to see if font is in the system
        
        for familyName in UIFont.familyNames {
            
            print("\n-- \(familyName) \n")
            
            for name in UIFont.fontNames(forFamilyName: familyName) {
                
                print(name)
                
                if (fontName == name){
                    print("TEXT:", fontName, "is valid")
                    return true
                }
            }
        }
        
        print("TEXT:", fontName,"is invalid, do not display")
        return false
    }

}
