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
    
    var user: FIRUser?
    
    @IBAction func Go(sender: UIButton) {
  
       
        var post: [String:AnyObject]
        
        let image = self.MostRecentuploads.removeAtIndex(self.MostRecentuploads.indexOf({ (goImage) -> Bool in
                     return goImage.Image == self.Image.image!
                    })!)

    
        
        self.Image.image = self.MostRecentuploads.first?.Image
        
        let likeRef = self.database.child("Opinions").child(image.ImageKey).ref
        
        likeRef.runTransactionBlock({ (data:FIRMutableData) -> FIRTransactionResult in
        
            if var post =  data.value as? [String:AnyObject], let user = FIRAuth.auth()?.currentUser?.uid{
                
                
                var nogoscore = post["NoGo"]! as! Int
                var goscore = post["Go"]! as! Int + 1
                var meanscore = (goscore + nogoscore)/2
                var judges = post["judges"] as? [String:Bool] ?? [user:true]
                
                var newPost =
                    [
                        "Go": goscore,
                        "Mean": meanscore,
                        "NoGo": nogoscore,
                        "Judges": judges
                ]
                
//                post["Go"] = post["Go"]! + 1
//                post["opinions"] = user
                print(data)
                data.value = post
            }
            
            return FIRTransactionResult.successWithValue(data)
        })
        {
            (error, committed, snapshot) in
            print(error)
        }
        

        
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        FIRAuth.auth()?.addAuthStateDidChangeListener(
            {
                (auth, user) in
                
                self.user = user
                
                self.database.child("Users").observeEventType(.ChildAdded, withBlock: {
                    (snapshot) in
                    
                    if snapshot.key != user?.uid
                    {
                        
                        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND,0))
                        {
                            
                            if let value = snapshot.value
                            {
                               
                                let temp = value["Images"] as! [String:[String]]
                           
                            
                              
                                var tempImages:[GoImage] = self.MostRecentuploads
                                
                                for (_,dictionaryItem) in temp.enumerate()
                                {
                                   
                                    if tempImages.contains({image in return image.ImageKey == dictionaryItem.0})
                                    {
                                        continue
                                    }
                                    
                                    tempImages.append(GoImage(lines: dictionaryItem.1, key: dictionaryItem.0, owner: snapshot.key ))
                                }

                                dispatch_async(dispatch_get_main_queue())
                                {
                                    self.MostRecentuploads = tempImages
                                    self.Image.image = self.MostRecentuploads.first?.Image
                                }
                            }
                        }
                        
                        
                    }
                    
                })
                
                
        })
        
        
    }
    
    
}
