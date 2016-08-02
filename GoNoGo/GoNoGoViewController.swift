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
        
        
        let image = self.MostRecentuploads.removeAtIndex(self.MostRecentuploads.indexOf({ (goImage) -> Bool in
            return goImage.Image == self.Image.image!
        })!)
        
        
        
        self.Image.image = self.MostRecentuploads.first?.Image
        
        let likeRef = self.database.child("Opinions").child(image.ImageKey).ref
        
        likeRef.runTransactionBlock({ (data:FIRMutableData) -> FIRTransactionResult in
            
            if var post =  data.value as? [String:AnyObject], let user = FIRAuth.auth()?.currentUser?.uid{
                
                
                let nogoscore = post["NoGo"]! as! Int
                let goscore = post["Go"]! as! Int + 1
                let meanscore = Double(goscore +  nogoscore)/2
                var judges = post["judges"] as? [String:Bool] ?? [:]
                
                if !judges.keys.contains(user){
                    judges[user] = true
                }
                
                let newPost =
                    [
                        "Go": goscore,
                        "Mean": meanscore,
                        "NoGo": nogoscore,
                        "Judges": judges
                ]
                
                data.value = newPost
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
                
                
                self.database.child("Users").observeEventType(.Value, withBlock: {
                    (snapshot) in
                    
                   
                        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND,0))
                        {
                            var tempImages:[GoImage] = self.MostRecentuploads
                            
                            for (_, item) in  snapshot.children.enumerate() where item.key!! != user?.uid
                            {
                                
                                
                                if let images = item.value["Images"] as? [String:[String]]
                                {
                                    
                                    for (_,dictionaryItem) in images.enumerate()
                                    {
                                        
                                        if tempImages.contains({image in return item.key == dictionaryItem.0})
                                        {
                                            continue
                                        }
                                        
                                        tempImages.append(GoImage(lines: dictionaryItem.1, key: dictionaryItem.0, owner: snapshot.key ))
                                    }
                                }
                            }
                            
                            dispatch_async(dispatch_get_main_queue())
                            {
                                self.MostRecentuploads = tempImages
                                self.Image.image = self.MostRecentuploads.first?.Image
                            }

                    }
                    
                })
                
                
        })
        
        
    }
    
    
}
