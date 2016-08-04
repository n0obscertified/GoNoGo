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
import FBSDKLoginKit
import SwiftyJSON
class ProfileViewController: UIViewController, UICollectionViewDataSource {

    @IBOutlet weak var FBLogIn: FBSDKLoginButton!
    
    @IBOutlet weak var poopImage: UIImageView!
    @IBOutlet weak var fireImage: UIImageView!
    @IBOutlet weak var myCollectionView: UICollectionView!
    var myArray = [GoImage]()
    var scoreArray = [AnyObject]()
    let reuseIdentifier = "cell"
    
    let database = FIRDatabase.database().reference()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBarHidden = true;
            FIRAuth.auth()?.addAuthStateDidChangeListener(
                {
                    (auth, user) in
                    if let currentUsr  = user
                    {
                        
                        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), { 
                            self.database.child("Users").child(currentUsr.uid).child("Images").observeEventType(.Value, withBlock: { snapshot in
                    
                                var tempMyArray:[GoImage] = self.myArray
                                
                                for (_, imageKey) in  snapshot.children.enumerate()
                                {
                                    
                                    let something = JSON(imageKey.value)
                                    
                                    if tempMyArray.contains({ image in return image.ImageKey == imageKey.key!!})
                                    {
                                        continue
                                    }
                        
                                    
                                    dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0))
                                    {
                                    tempMyArray.append(GoImage(lines: something.arrayObject as! [String], key: imageKey.key!!, owner: currentUsr.uid))
                                    
                                      
                                        dispatch_async(dispatch_get_main_queue(), {
                                            self.myArray = tempMyArray
                                           
                                             self.myCollectionView.reloadData()
                                             
                                        })

                                    }
                                    
                                }
                                
                                
                                
                            })
                        })


                    }
            })
        
    }
    
    @IBAction func LogOut(sender: AnyObject) {
        try! FIRAuth.auth()!.signOut()
     
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        
        let mainViewController = self.storyboard!.instantiateViewControllerWithIdentifier("MainViewController") as UIViewController
        self.navigationController!.pushViewController(mainViewController, animated: true)
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

        cell.layer.borderColor = UIColor.grayColor().CGColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 5
        
        let images = myArray[indexPath.row]
        
        
        cell.cellKey = images.ImageKey
        
        cell.setVisibility()
        cell.getScores()
        
        cell.myImageView.image = images.Image

        return cell
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      
        if(segue.identifier == "ImageDetail"){
            if let index = self.myCollectionView.indexPathsForSelectedItems()?.first{
                 let controller = segue.destinationViewController as! DetailsViewController
                    controller.goImage = self.myArray[index.row]

                
            }

        }
        
    }
    
}
