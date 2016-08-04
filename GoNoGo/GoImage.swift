//
//  GoImage.swift
//  GoNoGo
//
//  Created by Ismael on 7/31/16.
//  Copyright © 2016 Ismael. All rights reserved.
//

extension Array {
    var  ToString:String
    {
        var tempString = ""
        self.forEach({ (element) in
            tempString += String(element)
        })
        return tempString
        
    }
}

extension NSData{
    var ToUIImage:UIImage
    {
    
        if self.length == 0
        {
            return UIImage()
        }
        else
        {
            return UIImage(data:self)!
        }
    }
}

import Foundation
import UIKit
import SwiftCompressor
class GoImage {
    
    let ImageKey:String
    
    var Image:UIImage = UIImage()
    
    var string:String = ""
    
    var data:NSData = NSData()
    
    var Owner:String

    
    init(lines:[String], key:String,owner:String)
    {
        self.ImageKey = key
        self.Owner = owner
        self.string = lines.ToString
        do
        {
            let uncompressed =  NSData(base64EncodedString: self.string,
                                    options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!
              
            self.data = try uncompressed.decompress()!
               
            self.Image = self.data.ToUIImage
                
        }catch
        {
                
        }
       
    }
    
}