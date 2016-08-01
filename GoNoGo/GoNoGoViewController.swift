//
//  GoNoGoViewController.swift
//  GoNoGo
//
//  Created by Ismael on 7/28/16.
//  Copyright © 2016 Ismael. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
class GoNoGo: UIViewController
{
    @IBOutlet weak var Image: UIImageView!
    
    var database = FIRDatabase.database().reference()
    
    var MostRecentuploads:[GoImage] = [GoImage]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        self.database.child("Users").queryOrderedByKey().observeEventType(.ChildAdded, withBlock: {
            (snapshot) in
        
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND,0))
            {
            
          let temp = snapshot.children.allObjects
            var tempLines = [String]()
            for (_,value) in (temp.last?.children.enumerate())!
            {
                 tempLines.append( value.value!!)
            }
            
            let image = GoImage(lines: tempLines)
             self.MostRecentuploads.append(image)
                
                dispatch_async(dispatch_get_main_queue(), { 
                      self.Image.image = self.MostRecentuploads.first?.Image
                })
            }
            
        })
        
      
        
    }
    

}
