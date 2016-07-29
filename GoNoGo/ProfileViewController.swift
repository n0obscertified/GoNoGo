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

    var myArray = [String]()
    let reuseIdentifier = "cell"
    
    let database = FIRDatabase.database().reference()
    
    @IBOutlet weak var image: UIImageView!
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
                                if imageKey.hasChildren(){
                                    var lines = ""
                                    var index = 0
                                    for i in imageKey.children{
                                        lines.appendContentsOf(i.value!!)

                                    }
                                    
                                    
                                    do  { let imageData = try NSData(base64EncodedString: lines ,
                                        options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)?.decompress()
                                        
                                        let decodedImage = UIImage(data:imageData!)
                                        dispatch_async(dispatch_get_main_queue(), {
                                            self.image.image = decodedImage
                                        })
                                        
                                        break;
                                        
                                    }
                                    catch{}
                                    
                                    
                                }
                                
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

        return cell
        
    }

}
