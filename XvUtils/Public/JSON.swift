//
//  JSON.swift
//  XvUtils
//
//  Created by Jason Snell on 6/18/20.
//  Copyright © 2020 Jason J. Snell. All rights reserved.
//

import Foundation

public class JSON {
    
    public class func getJSON(fromData:Data) -> [String:Any]? {
        
        print("fromData", fromData)
        
        if let convertedString = String(data: fromData, encoding: String.Encoding.utf8) {
            print(convertedString)
        }
        
        do {
            // make sure this JSON is in the format we expect
            if let json:[String:Any] = try JSONSerialization.jsonObject(
                with: fromData,
                options:[]) as? [String: Any] {
                
                print("json", json)
                return json
            }
            
        } catch let error as NSError {
            print("XvUtils: JSON: Error:", fromData)
            print("XvUtils: JSON: Error:", (error.localizedDescription))
        }
        
        return nil
    }
    
    public class func getJSON(fromStr:String) -> [String:Any]? {
        
        //turn the string into a data object
        let data:Data = Data(fromStr.utf8)
        
        //send to other method
        return getJSON(fromData: data)
    }

    public class func getString(fromJSON:[String:Any]) -> String? {
        
        do {
            
            let data:Data = try JSONSerialization.data(withJSONObject: fromJSON, options: JSONSerialization.WritingOptions.prettyPrinted)
            if let convertedString:String = String(data: data, encoding: String.Encoding.utf8) {
                return convertedString
            }
            return nil
            
        } catch let error {
            print("JSON: Error:", error)
            return nil
        }
    }
    
}

