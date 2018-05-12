//
//  Utils.swift
//  IdeaNotes
//
//  Created by Sang Nam on 21/08/2016.
//  Copyright © 2016 Sang Nam. All rights reserved.
//

import Foundation
import UIKit

//class Utils : NSObject {
//    
//    class func getZeroHourMinuteSecond(date : Date) -> Date? {
//        var comps = cal.dateComponents(calUnits, from: date)
//        comps.setValue(0, for: .hour)
//        comps.setValue(0, for: .minute)
//        comps.setValue(0, for: .second)
//        
//        return cal.date(from: comps)
//    }
//    
//    class func getFirstDayOfMonth(date : Date) -> Date? {
//        
//        var comps = cal.dateComponents(calUnits, from: date)
//        comps.setValue(1, for: .day)
//        comps.setValue(0, for: .hour)
//        comps.setValue(0, for: .minute)
//        comps.setValue(0, for: .second)
//        
//        return cal.date(from: comps)
//    }
//}

extension UIColor {
    
//    static func appleBlue() -> UIColor {
//        return UIColor.init(colorLiteralRed: 14.0/255, green: 122.0/255, blue: 254.0/255, alpha: 1.0)
//    }
    
    convenience init(intColor : UInt32) {
        
        let mask = 0x000000FF
        let a = Int(intColor >> 24) & mask
        let r = Int(intColor >> 16) & mask
        let g = Int(intColor >> 8) & mask
        let b = Int(intColor) & mask
        
        let alpha = CGFloat(a) / 255.0
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        self.init(red:red, green:green, blue:blue, alpha:alpha)
        
    }
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(hex:Int) {
        self.init(red:(hex >> 16) & 0xff, green:(hex >> 8) & 0xff, blue:hex & 0xff)
    }
    
    convenience init(hexString : String) {
        let hexString  = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner    = Scanner(string: hexString)
        
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        
        var color:UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
//        let a = Int(color >> 24) & mask
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
//        let alpha = CGFloat(a) / 255.0
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        self.init(red:red, green:green, blue:blue, alpha:1.0)
    }
    
    class func generateRandomColor() -> UIColor {
        let hue : CGFloat = CGFloat(arc4random() % 256) / 256 // use 256 to get full range from 0.0 to 1.0
        let saturation : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from white
        let brightness : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from black
        
        return self.init(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }
    
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return String(format:"#%06x", rgb)
    }
    
    
    func toInt() -> UInt32 {

        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb:Int = (Int)(a*255)<<24 | (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return UInt32(rgb)
    }

}


extension UIImage {
    func tabBarImageWithCustomTint(tintColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        
        context.translateBy(x: 0, y: self.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.setBlendMode(.normal)
        let rect: CGRect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        
        context.clip(to: rect, mask: self.cgImage!)
        
        tintColor.setFill()
        context.fill(rect)
        
        var newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        newImage = newImage.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        return newImage
    }
    
    func resizedImage(newSize: CGSize) -> UIImage {
        // Guard newSize is different
        guard self.size != newSize else { return self }
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0);
        let ctx = UIGraphicsGetCurrentContext()
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        // white border
//        ctx?.setLineWidth(50.0)
//        ctx?.setStrokeColor(UIColor.white.cgColor)
//        ctx?.stroke(CGRect(origin: .zero, size: newSize))
        
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}


extension String {
    
    func addSpace(no : Int) -> String {
        var lbl = ""
        for (_,ch) in self.enumerated() {
            lbl += String(ch)
            for _ in 0..<no {
                lbl += " "
            }
        }
        return lbl.trimmingCharacters(in: .whitespaces)
    }
    
    func addLetter(no : Int, letter : String) -> String {
        var lbl = ""
        for (_,ch) in self.enumerated() {
            lbl += String(ch)
            for _ in 0..<no {
                lbl += letter
            }
        }
        return lbl.trimmingCharacters(in: .whitespaces)
    }
}

extension String {
    
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, count) ..< count]
    }
    
    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(count, r.lowerBound)),
                                            upper: min(count, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
    
}
