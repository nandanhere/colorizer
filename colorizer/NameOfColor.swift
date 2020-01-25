//
//  NameOfColor.swift
//  RandomColorSwift
//
//  Created by WANG WEI on 2015/01/23.
//  Copyright (c) 2016年 OneV's Den. All rights reserved.
//

import UIKit
import JavaScriptCore

private var context: JSContext = {
    let jsPath = Bundle.main.path(forResource: "ntc", ofType: "js")!
    var error: NSError?
    let jsString = try! String(contentsOfFile:jsPath, encoding: String.Encoding.utf8)
    
    let context = JSContext()
    context!.evaluateScript(jsString)
    return context!
}()

extension UIColor {
    var hexString: String {
        var red: CGFloat = 0
        var green: CGFloat  = 0
        var blue: CGFloat = 0
        
        self.getRed(&red, green: &green, blue: &blue, alpha: nil)
        
        let r = Int(255.0 * red);
        let g = Int(255.0 * green);
        let b = Int(255.0 * blue);
        
        return String(format: "#%02x%02x%02x", r,g,b)
    }
var hsba: (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
    var hue: CGFloat = 0, saturation: CGFloat = 0, brightness: CGFloat = 0, alpha: CGFloat = 0
    if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
        return (hue, saturation, brightness, alpha)
    }
    return (0,0,0,0)
}
}


extension UIColor {
    var name: String {
        get {
            if let colorInfo = context.evaluateScript("ntc.name('\(self.hexString)')").toArray() {
                return colorInfo[1] as! String
            } else {
                return "not found"
            }
        }
    }
}
