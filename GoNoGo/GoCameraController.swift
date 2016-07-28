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
import FirebaseStorage
import SwiftCompressor
class GoCameraController: CameraViewController {
    
    let storage = FIRStorage.storage()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true;
        SaveAndUploadImage()
        
    }
    
    
    func SaveAndUploadImage()
    {
        let base = storage.referenceForURL("gs://gonogo-5d73d.appspot.com")
        self.changeOnComplete()
            {
                image, asset in
                FIRAuth.auth()?.addAuthStateDidChangeListener(
                    {
                        (auth, user) in
                        if let currentUsr  = user
                        {
                            let  bucket = base.child("\(currentUsr.uid)/\(asset!.creationDate!.description)")
                            
                            dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND,0))
                            {
                                
                                if let rawImage = image
                                {
                                                                       
                                    var data:NSData?
                                    do
                                    {
                                        if let compression = try UIImageJPEGRepresentation(rawImage,1)?.compress(algorithm:.LZMA)
                                        {
                                            data = compression
                                        }
                                    }
                                    catch
                                    {
                                        data = UIImagePNGRepresentation(rawImage)
                                    }
                                    if let data  = data
                                    {
                                        bucket.putData(data)
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
