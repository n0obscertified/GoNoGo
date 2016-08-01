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
    
    @IBAction func Go(sender: UIButton) {
  
        self.MostRecentuploads.removeAtIndex(self.MostRecentuploads.indexOf({ (goImage) -> Bool in
           return goImage.Image == self.Image.image!
          })!)
        
        self.Image.image = self.MostRecentuploads.first?.Image
     
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        FIRAuth.auth()?.addAuthStateDidChangeListener(
            {
                (auth, user) in
                
                
                self.database.child("Users").queryOrderedByKey().observeEventType(.ChildAdded, withBlock: {
                    (snapshot) in
                    
                    if snapshot.key != user?.uid
                    {
                        
                        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND,0))
                        {
                            
                            let temp = snapshot.children.allObjects
                            var tempLines = [String]()
                            
                            for (_,value) in temp.enumerate()
                            {
                               
                                
                                for (_,item) in value.children.enumerate(){
                                    
                                  
                                    tempLines.append(item.value!!)
                                
                                }
                                let image = GoImage(lines:tempLines, key: value.key!!)
                                tempLines = [String]()
                                self.MostRecentuploads.append(image)

                            }
                            
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                self.Image.image = self.MostRecentuploads.first?.Image
                            })
                        }
                        
                        
                    }
                    
                })
                
                
        })
        
        
    }
    
    
}
