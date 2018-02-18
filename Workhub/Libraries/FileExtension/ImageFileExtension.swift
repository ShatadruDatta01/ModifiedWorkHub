//
//  ImageFileExtension.swift
//  Workhub
//
//  Created by Administrator on 12/02/18.
//  Copyright © 2018 Sociosquares. All rights reserved.
//

import UIKit
import ImageIO

struct ImageHeaderData {
    static var PNG: [UInt8] = [0x89]
    static var JPEG: [UInt8] = [0xFF]
    static var GIF: [UInt8] = [0x47]
    static var TIFF_01: [UInt8] = [0x49]
    static var TIFF_02: [UInt8] = [0x4D]
}

enum ImageFormat{
    case Unknown, png, jpeg, gif, tiff
}


extension NSData{
    var imageFormat: ImageFormat{
        var buffer = [UInt8](repeating: 0, count: 1)
        self.getBytes(&buffer, range: NSRange(location: 0,length: 1))
        if buffer == ImageHeaderData.PNG
        {
            return .png
        } else if buffer == ImageHeaderData.JPEG
        {
            return .jpeg
        } else if buffer == ImageHeaderData.GIF
        {
            return .gif
        } else if buffer == ImageHeaderData.TIFF_01 || buffer == ImageHeaderData.TIFF_02{
            return .tiff
        } else{
            return .Unknown
        }
    }
}
