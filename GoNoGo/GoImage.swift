//
//  GoImage.swift
//  GoNoGo
//
//  Created by Ismael on 7/31/16.
//  Copyright © 2016 Ismael. All rights reserved.
//

import Foundation
import UIKit
import SwiftCompressor
class GoImage {
    
    var Image:UIImage = UIImage()
    
    var string:String = ""
    
    var data:NSData = NSData()
    
    init(lines:[String]){
        
      
            
            lines.forEach({ (line) in
                self.string += line
            })
            
            do {
             self.data =  NSData(base64EncodedString: self.string ,
                           options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!
              
                self.data = try self.data.decompress()!
               
                self.Image = UIImage(data:self.data)!
                
            }catch{
                
            }
            
        
        
    }
    
}