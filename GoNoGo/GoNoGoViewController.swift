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
import SQLite
import SwiftyJSON
class GoNoGo: UIViewController
{
    @IBOutlet weak var Image: UIImageView!
    
    let database = FIRDatabase.database().reference()
    
    var Likes:FIRDatabaseReference?
    
    var MostRecentuploads:[GoImage] = [GoImage]()
    
    var sqlDb:Connection?
    
    let Images = Table("Images")
    let ImageKey = Expression<String>("ImageKey")
    var ImagesSeen = [String]()
    var user: FIRUser?
    
    @IBAction func NoGo(sender: UIButton) {
    
        
        let image = self.MostRecentuploads.removeAtIndex(self.MostRecentuploads.indexOf({ (goImage) -> Bool in
            return goImage.Image == self.Image.image!
        })!)
        
        
        
        self.Image.image = self.MostRecentuploads.first?.Image
        
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) { 
            self.InsertSeenImageKey(image.ImageKey)
        }
        
      
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
            self.GoNoGoTransaction(image.ImageKey, transaction: .NoGo)
        }
        
    }
    @IBAction func Go(sender: UIButton) {
        
        
        let image = self.MostRecentuploads.removeAtIndex(self.MostRecentuploads.indexOf({ (goImage) -> Bool in
            return goImage.Image == self.Image.image!
        })!)
        
        
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
            self.InsertSeenImageKey(image.ImageKey)
        }
        
        
        self.Image.image = self.MostRecentuploads.first?.Image

       
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
            self.GoNoGoTransaction(image.ImageKey, transaction: .Go)
        }
        
        
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.Likes = self.database.child("Opinions").ref
        
        if let documentdir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory,  NSSearchPathDomainMask.AllDomainsMask, true).first{
        
            let path = NSURL(fileURLWithPath: documentdir).URLByAppendingPathComponent("gonogo.sqlite")
            do
            {
                self.sqlDb = try Connection(path.absoluteString)
                
                do
                {
                    try self.sqlDb!.run(Images.create { t in
                        
                        t.column(ImageKey, primaryKey: true)})
                }catch{
                    
                }
                
                for image in try self.sqlDb!.prepare(Images)
                {
                    self.ImagesSeen.append(image.get(self.ImageKey))
                }
            }
            catch(let error)
            {
                print(error)
            }
        }
        
        FIRAuth.auth()?.addAuthStateDidChangeListener(
            {
                (auth, user) in
                
                self.database.child("Users").observeEventType(.Value, withBlock: {
                    (snapshot) in
                    
                    dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND,0))
                    {
                        var tempImages:[GoImage] = self.MostRecentuploads
                        
                        for child in snapshot.children.enumerate() where child.element.key!! != user?.uid{
                            
                            if let json = JSON(child.element.value!).dictionary
                            {
                                // get all the images for every other user except
                                if let copy = json["Images"]?.dictionary{
                                    
                                    for  (_ ,value) in copy.enumerate()
                                    {
                                        // has the user logged in seen skip it
                                        if self.ImagesSeen.contains(value.0)
                                        {
                                            continue
                                        }
                                        
                                        // does temp image alredy contain greate dont add
                                        if tempImages.contains({ image in return image.ImageKey == value.0})
                                        {
                                            continue;
                                        }
                                        
                                        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND,0))
                                        {
                                            tempImages.append(GoImage(lines: value.1.arrayObject as! [String], key: value.0, owner: child.element.key!! ))
                                            
                                            dispatch_async(dispatch_get_main_queue())
                                            {
                                                self.MostRecentuploads = tempImages
                                                self.Image.image = self.MostRecentuploads.first?.Image
                                            }
                                        }
                                    }
                                    
                                }
                            }
                        }
        
                        
                    }
                    
                })
                
                
        })
        
    }
    
    private enum Post
    {
        case Go, NoGo
    }
    
    
    private func GoNoGoTransaction(key:String, transaction:Post)
    {
        
        self.Likes!.child(key).runTransactionBlock({ (data:FIRMutableData) -> FIRTransactionResult in
            
            
            if var post =  data.value as? [String:AnyObject]{
                
                var newPost:[String:AnyObject]
                let nogoscore:Int
                let goscore:Int
                let meanscore:Double
                
                switch (transaction){
                    
                case .Go:
                  nogoscore = post["NoGo"]! as! Int
                  goscore = post["Go"]! as! Int + 1
                  meanscore = Double(goscore -  nogoscore)/2
               
                
                case .NoGo:
                    nogoscore = post["NoGo"]! as! Int + 1
                    goscore = post["Go"]! as! Int
                    meanscore = Double(goscore -  nogoscore)/2
                   
                    
                    
                }
                
                newPost = [
                    "Go": goscore,
                    "Mean": meanscore,
                    "NoGo": nogoscore]

                
                data.value = newPost
            }
            
            return FIRTransactionResult.successWithValue(data)
            })
        {
            (error, committed, snapshot) in
            print(error)
        }
    }
    
    
    private func InsertSeenImageKey(key:String){
       
        
        let insert = self.Images.insert(ImageKey <- key)
        
        do{
            self.ImagesSeen.append(key)
            try self.sqlDb!.run(insert)
        }catch
        {
            
        }
    }
    
    
}
