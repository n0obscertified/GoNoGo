//
//  GoCameraController.swift
//  GoNoGo
//
//  Created by Ismael on 7/26/16.
//  Copyright © 2016 Ismael. All rights reserved.
//

import UIKit
import ALCameraViewController
import Firebase
import FirebaseStorage
class GoCameraController: CameraViewController {


    let Storage = FIRStorage.storage()

    
    //("gs://gonogo-5d73d.appspot.com")
    override func viewDidLoad() {
        let base = Storage.referenceForURL("gs://gonogo-5d73d.appspot.com")
        let casual = base.child("casual")
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true;
        self.changeOnComplete(){
             image, asset in
            
            casual.putData(UIImagePNGRepresentation(image!)!)
            
            if let confirmController = self.getConfirmController
            {
             confirmController.cancel()
            }
            print(image)
            
            
        }
       
    }
    
    func Complete() {
        
    }
    
    
}
