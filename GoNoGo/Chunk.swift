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
            var lines = [String]()
           
            self.chunkThis.enumerateLines({ (line, stop) in
                
               
                 lines.append(line)
                self.childUpdates["Users/\(self.userId)/Images/\(self.key)/\(index)"] = line
                
                index += 1
            })
        
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