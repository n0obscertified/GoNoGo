//
//  ProfileViewController.swift
//  GoNoGo
//
//  Created by Jeel on 7/28/16.
//  Copyright © 2016 Ismael. All rights reserved.
//

import UIKit
import FirebaseStorage
import Firebase
import FirebaseAuth
import SwiftCompressor
class ProfileViewController: UIViewController, UICollectionViewDataSource {

    var myArray = [AnyObject]()
    let reuseIdentifier = "cell"
    
    let database = FIRDatabase.database().reference()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        FIRAuth.auth()?.addAuthStateDidChangeListener(
            {
                (auth, user) in
                if let currentUsr  = user
                {
                    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), {
                        self.database.child("Users").observeEventType(.ChildAdded, withBlock: { snapshot in
                            let userId = snapshot.key
                            for (x, imageKey) in  snapshot.children.enumerate()
                            {
                                self.myArray.append(imageKey)

                                
                            }
                    })


                        
                    })
                }
        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return myArray.count
    }

    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MyCollectionViewCell

        let images = myArray[indexPath.row]

            var lines = ""
            for i in images.children{
                lines.appendContentsOf(i.value!!)
                
            }
            
            
            do  { let imageData = try NSData(base64EncodedString: lines ,
                                             options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)?.decompress()
                
                let decodedImage = UIImage(data:imageData!)
                dispatch_async(dispatch_get_main_queue(), {
                    cell.myImageView.image = decodedImage
                })
                
                
            }
            catch{}
            
            

        return cell
        
    }

}
