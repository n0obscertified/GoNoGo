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
    
    var childUpdates = [String:String]()
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
            self.chunkThis.enumerateLines({ (line, stop) in
                self.childUpdates["Users/\(self.userId)/\(self.key)/\(index)"] = line
                index += 1
            })
        
            self.db.updateChildValues(self.childUpdates)
            
            self.chunkThis = ""
            self.childUpdates = [:]
        }
    }
    
}