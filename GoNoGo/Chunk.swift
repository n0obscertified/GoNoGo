//
//  Chunk.swift
//  GoNoGo
//
//  Created by Ismael on 7/28/16.
//  Copyright © 2016 Ismael. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Chunk
{
    var chunks = [String]()
    var chunkThis:String
    var userId:String
    var key:String
    let FBdbLongestString:Int = 432000
    var childUpdates = [String:AnyObject]()
    var db:FIRDatabaseReference
    
    init(id:String,key:String ,chunkThis:String, ref:FIRDatabaseReference)
    {
        self.userId = id
        self.chunkThis = chunkThis
        self.key = key
        self.db = ref
    }
    
    
    
    func buildChildUpdates(){
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND,0))
        {
            
            
            
            var index = 0
            
            var dictionary :[Int:String] = [0:""]
            var lineCount:Int = 1
            self.chunkThis.enumerateLines({ (line, stop) in
                
                
                if self.FBdbLongestString == lineCount
                {
                    lineCount = 1
                    
                    index += 1
                    dictionary[index] = ""
                    dictionary[index] = dictionary[index]?.stringByAppendingString(line)
                    
                }else{
                    
                    lineCount += 1
                    
                    dictionary[index] = dictionary[index]?.stringByAppendingString(line)
                }
                
                
                
            })
            
            
            for item in  dictionary.enumerate(){
                
                self.childUpdates["Users/\(self.userId)/Images/\(self.key)/\(item.index)"] = item.element.1
            }
            
            let post = ["Go": 0,
                        "NoGo":0,
                        "Mean": 0]
            
            
            self.childUpdates["Opinions/\(self.key)"] = post
            
            self.db.updateChildValues(self.childUpdates)
            
            self.chunkThis = ""
            self.childUpdates = [:]
        }
    }
    
}