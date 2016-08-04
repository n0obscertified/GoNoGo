//
//  GoCameraController.swift
//  GoNoGo
//
//  Created by Ismael on 7/26/16.
//  Copyright © 2016 Ismael. All rights reserved.
//

import UIKit
import ALCameraViewController
import FirebaseAuth
import FirebaseDatabase
import SwiftCompressor

class GoCameraController: CameraViewController {
    
    let databse = FIRDatabase.database().reference()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true;
        SaveAndUploadImage()
        
    }
    
    
    func SaveAndUploadImage()
    {
        
        self.changeOnComplete()
            {
                image, asset in
                FIRAuth.auth()?.addAuthStateDidChangeListener(
                    {
                        (auth, user) in
                        
                        if let currentUsr  = user
                        {
                            
                            dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND,0))
                            {
                                
                                if let rawImage = image
                                {
                                    let stringImage:String
                                    do{
                                        let compress = try UIImageJPEGRepresentation(rawImage,0.5)?.compress()
                                        
                                        stringImage = compress!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
                                        
                                        
                                        
                                        
                                    }catch{
                                        
                                        stringImage = ""
                                    }
                                    let key = self.databse.child("Users").child(currentUsr.uid).childByAutoId().key
                                    
                                    if !stringImage.isEmpty
                                    {
                                        
                                        let chunk = Chunk(id:currentUsr.uid,key: key, chunkThis: stringImage,ref: self.databse)
                                        
                                        chunk.buildChildUpdates()
                                        
                                    }
                                    
                                    
                                }
                            }
                        }
                        
                        self.Cancel()
                        
                })
                
                
        }
        
    }
    
    
    
    func Cancel ()
    {
        if let confirmController = self.getConfirmController
        {
            
            confirmController.cancel()
            
        }
        
    }
    
    func Complete() {
        
    }
    
    
}
