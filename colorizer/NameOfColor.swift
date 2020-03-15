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
    var coreImageColor: CIColor {
        return CIColor(color: self)
    }
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        let color = coreImageColor
        return (color.red, color.green, color.blue, color.alpha)
    }
}
extension UIColor
{
    var isDarkColor: Bool {
        var r, g, b, a: CGFloat
        (r, g, b, a) = (0, 0, 0, 0)
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        let lum = 0.2126 * r + 0.7152 * g + 0.0722 * b
        return  lum < 0.50 ? true : false
    }
}

extension UIColor{
func lighter(by percentage: CGFloat = 30.0) -> UIColor? {
    return self.adjust(by: abs(percentage) )
}

func darker(by percentage: CGFloat = 30.0) -> UIColor? {
    return self.adjust(by: -1 * abs(percentage) )
}

func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
    var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
    if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
        return UIColor(red: min(red + percentage/100, 1.0),
                       green: min(green + percentage/100, 1.0),
                       blue: min(blue + percentage/100, 1.0),
                       alpha: alpha)
    } else {
        return nil
    }
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
 extension UIColor {
     public convenience init(hex: String) {
         var r: CGFloat = 0
         var g: CGFloat = 0
         var b: CGFloat = 0
         var a: CGFloat = 1

         let hexColor = hex.replacingOccurrences(of: "#", with: "")
         let scanner = Scanner(string: hexColor)
         var hexNumber: UInt64 = 0
         var valid = false

         if scanner.scanHexInt64(&hexNumber) {
             if hexColor.count == 8 {
                 r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                 g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                 b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                 a = CGFloat(hexNumber & 0x000000ff) / 255
                 valid = true
             }
             else if hexColor.count == 6 {
                 r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                 g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                 b = CGFloat(hexNumber & 0x0000ff) / 255
                 valid = true
             }
         }

         #if DEBUG
             assert(valid, "UIColor initialized with invalid hex string")
         #endif

         self.init(red: r, green: g, blue: b, alpha: a)
     }
 }
