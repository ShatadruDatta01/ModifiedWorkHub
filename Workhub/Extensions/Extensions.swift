//
//  Extensions.swift
//  GetMoreSports
//
//  Created by redapple043 on 12/04/17.
//  Copyright © 2017 redapple043. All rights reserved.
//

import Foundation
import UIKit
import GoogleSignIn

extension String
{
    // MARK:- Trimming the whitespace from a string and check empty of string
    public var isBlank: Bool {
        get {
            //			let trimmed = stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            let trimmed = trimmingCharacters(in: NSCharacterSet.whitespaces)
            return trimmed.isEmpty
        }
    }
    
    //To check String is not null/NULL/nil.
    //    static func isSafeString(strOpt: AnyObject?) -> Bool {
    //        var returnVar = true
    //        if let tempStr = strOpt as? String {
    //            if tempStr.lowercased == "null" || tempStr.lowercased == "<null>" {
    //                returnVar = false
    //            }
    //        }
    //        else {
    //            returnVar = false
    //        }
    //        return returnVar
    //    }
    
    
    
    // MARK:- Verify email address is correct format or not.
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: self)
        return result
        
    }
    // MARK:- Show Error Message
    func showErrorMessage(messge: String, textField: UITextField)
    {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: textField.center.x - 10, y: textField.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: textField.center.x + 10, y: textField.center.y))
        textField.layer.add(animation, forKey: "position")
        let attributes = [
            NSForegroundColorAttributeName: UIColor.red,
            NSFontAttributeName: UIFont(name: FONT_NAME, size: 12)! // Note the !
        ]
        textField.attributedPlaceholder = NSAttributedString(string: messge, attributes: attributes)
        textField.text = ""
    }
    
    func requiredHeight(forWidth width: CGFloat, andFont font: UIFont) -> CGFloat {
        
        let label: UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = self
        label.sizeToFit()
        return label.frame.height
    }
    
    func requiredWidth(forHeight height: CGFloat, andFont font: UIFont) -> CGFloat {
        
        let label: UILabel = UILabel(frame: CGRectMake(0, 0, CGFloat.greatestFiniteMagnitude, height))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = self
        label.sizeToFit()
        return label.frame.width
    }
    
    // MARK: Label Justified
    func labelJustified(labelText: UILabel)
    {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .justified
        paragraphStyle.firstLineHeadIndent = 0.001
        
        let mutableAttrStr = NSMutableAttributedString(attributedString: labelText.attributedText!)
        mutableAttrStr.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, mutableAttrStr.length))
        labelText.attributedText = mutableAttrStr
    }
    
    //MARK: Random String
    static func randomString(length: Int) -> String {
        let charactersString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let charactersArray : [Character] = Array(charactersString.characters)
        
        var string = ""
        for _ in 0..<length {
            string.append(charactersArray[Int(arc4random()) % charactersArray.count])
        }
        return string
    }
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
}


extension UILabel {
    
    //	public override func layoutSubviews() {
    //		super.layoutSubviews()
    //		if self.superview != nil {
    //			if self.superview!.isKindOfClass(UIButton) {
    //				if self.superview!.isKindOfClass(NSClassFromString("UINavigationButton")!) {
    //					self.font = UIFont(name: FONT_NAME, size: self.font.pointSize)
    //				}
    //             else {
    //					self.font = UIFont(name: FONT_NAME, size: self.font.pointSize)
    //				}
    //            }else if self.superview!.isKindOfClass(NSClassFromString("UIDatePickerContentView")!) {
    //              return
    //            }else {
    //				self.font = UIFont(name: FONT_NAME, size: self.font.pointSize)
    //			}
    //		}
    //	}
    
    func requiredHeight() -> CGFloat{
        
        //        let label:UILabel = UILabel(frame: CGRectMake(0, 0, self.frame.width, CGFloat.greatestFiniteMagnitude))
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = self.font
        label.text = self.text
        label.sizeToFit()
        return label.frame.height
    }
}




//MARK: Array
extension Array where Element: Comparable {
    
    mutating func removeObject(object: Element) {
        if let index = self.index(of: object) {
            self.remove(at: index)
        }
    }
    
    mutating func removeObjects(objectArray: [Element])
    {
        for object in objectArray {
            self.removeObject(object: object)
        }
    }
}

extension Array {
    
    //	func containsObject(type: AnyClass) -> (isPresent: Bool, index: Int?) {
    //		for (index, item) in self.enumerated() {
    //			if (item as AnyObject) is type {
    //				return (true, index)
    //			}
    //		}
    //		return (false, nil)
    //	}
}




extension UIButton {
    // MARK Button and image alignment Like tabbar,
    func alignImageAndTitleVertically(padding: CGFloat) {
        let imageSize = self.imageView!.frame.size
        let titleSize = self.titleLabel!.frame.size
        let totalHeight = imageSize.height + titleSize.height + padding
        
        self.imageEdgeInsets = UIEdgeInsets(
            top: -(totalHeight - imageSize.height),
            left: 0,
            bottom: 0,
            right: -titleSize.width
        )
        
        self.titleEdgeInsets = UIEdgeInsets(
            top: 0,
            left: -imageSize.width,
            bottom: -(totalHeight - titleSize.height),
            right: 0
        )
    }
    
}



//MARK:- CALayer

extension CALayer {
    
    var borderUIColor: UIColor {
        set {
            self.borderColor = newValue.cgColor
        }
        
        get {
            return UIColor(cgColor: self.borderColor!)
        }
    }
}

//MARK: -  NSDate
extension NSDate {
    
    func dateToStringWithCustomFormat(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = NSTimeZone.local
        return dateFormatter.string(from: self as Date)
    }
    
    class func dateFromTimeInterval(timeInterval: Double) -> NSDate {
        // Convert to Date
        return NSDate(timeIntervalSince1970: timeInterval)
    }
    
    func getFormattedStringWithFormat() -> String? {
        return "\(getDay())\(getDateSuffixForDate()!) \(getThreeCharacterMonth()) '\(getTwoDigitYear())"
    }
    
    func getDateSuffixForDate() -> (String?) {
        let ones = getDay() % 10
        let tens = (getDay() / 10) % 10
        if (tens == 1) {
            return "th"
        } else if (ones == 1) {
            return "st"
        } else if (ones == 2) {
            return "nd"
        } else if (ones == 3) {
            return "rd"
        } else {
            return "th"
        }
    }
    
    func getDay() -> (Int) {
        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        let components = calendar?.components(.day, from: self as Date)
        return components!.day!
    }
    
    func getMonth() -> (String) {
        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        let components = calendar?.components(.month, from: self as Date)
        let dateFormatter = DateFormatter()
        return dateFormatter.monthSymbols[(components?.month)! - 1]
    }
    
    func getThreeCharacterMonth() -> (String) {
        //        return getMonth().substring(to: getMonth().startIndex.advancedBy(3))
        let secondCharIndex = getMonth().index(after: getMonth().startIndex)
        return getMonth().substring(from: secondCharIndex)
        
        
    }
    
    func getYear() -> (Int) {
        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        let components = calendar?.components(.year, from: self as Date)
        return components!.year!
    }
    
    func getTwoDigitYear() -> (Int) {
        return getYear() % 100
    }
    
    class func convertTimeStampToDate(timeInterval: Double)->String{
        let date = NSDate(timeIntervalSince1970: timeInterval)
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "dd MMM, YYYY"
        let dateString = dayTimePeriodFormatter.string(from: date as Date)
        return dateString
    }
    
    class func convertDateFormatterFromTimestamp(date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"//this your string date format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        let date = dateFormatter.date(from: date)
        
        dateFormatter.dateFormat = "yyyy MMM EEEE HH:mm"///this is what you want to convert format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        let timeStamp = dateFormatter.string(from: date!)
        return timeStamp
    }
    
    
    
    class func getTimeStamp() -> String{
        return "\(NSDate().timeIntervalSince1970 * 1000)"
        
    }
    
}


extension DateFormatter {
    
    convenience init (format: String) {
        self.init()
        dateFormat = format
        locale = Locale.current
    }
}

extension String {
    
    func toDate (format: String) -> Date? {
        return DateFormatter(format: format).date(from: self)
    }
    
    func toDateString (outputFormat:String) -> String? {
        if let date = toDate(format: "yyyy.MM.dd'T'HH:mm:ss") {
            return DateFormatter(format: outputFormat).string(from: date)
        }
        return nil
    }
}

extension Date {
    
    func toString (format:String) -> String? {
        return DateFormatter(format: format).string(from: self)
    }
}




extension Array {
    mutating func removeObject<U: Equatable>(object: U) {
        var index: Int?
        for (idx, objectToCompare) in enumerated() {
            if let to = objectToCompare as? U {
                if object == to {
                    index = idx
                }
            }
        }
        
        if(index != nil) {
            self.remove(at: index!)
        }
    }
}


//MARK:- UIImageExtension
extension UIImage {
    
    func maskWithColor(color: UIColor) -> UIImage? {
        let maskImage = cgImage!
        
        let width = size.width
        let height = size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!
        
        context.clip(to: bounds, mask: maskImage)
        context.setFillColor(color.cgColor)
        context.fill(bounds)
        
        if let cgImage = context.makeImage() {
            let coloredImage = UIImage(cgImage: cgImage)
            return coloredImage
        } else {
            return nil
        }
    }
}


//MARK:- UIColor
extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}


// MARK: - Alert Controller
extension UIViewController {
    
    func presentAlertWithTitle(title: String, message : String)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) {
            (action: UIAlertAction) in
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func presentAlertActionWithTimer(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        
        // change to desired number of seconds (in this case 3 seconds)
        let when = DispatchTime.now() + 3
        DispatchQueue.main.asyncAfter(deadline: when){
            // your code with delay
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    func presentAlertActionWithTitle(title: String, message : String, text: String)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) {
            (action: UIAlertAction) in
            SET_OBJ_FOR_KEY(obj: "0" as AnyObject, key: "isLogin")
            REMOVE_OBJ_FOR_KEY(key: "AccessToken")
            REMOVE_OBJ_FOR_KEY(key: "Resume")
            REMOVE_OBJ_FOR_KEY(key: "UserId")
            REMOVE_OBJ_FOR_KEY(key: "UserPic")
            REMOVE_OBJ_FOR_KEY(key: "Email")
            REMOVE_OBJ_FOR_KEY(key: "Name")
            REMOVE_OBJ_FOR_KEY(key: "Network")
            GIDSignIn.sharedInstance().signOut()
            FacebookLoginAPI.logOutFromFacebook()
            NavigationHelper.helper.openSidePanel(open: false)
        }
        alertController.addAction(OKAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {
            (action: UIAlertAction) in
        }
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)
    }
}
