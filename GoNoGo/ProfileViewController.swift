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

class ProfileViewController: UIViewController, FBSDKLoginButtonDelegate, UICollectionViewDataSource{

    @IBOutlet weak var FBLogIn: FBSDKLoginButton!
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    var myArray = [AnyObject]()
    let reuseIdentifier = "cell"
    
    let database = FIRDatabase.database().reference()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.FBLogIn.delegate = self

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
            FIRAuth.auth()?.addAuthStateDidChangeListener(
                {
                    (auth, user) in
                    if let currentUsr  = user
                    {
                        
                        self.database.child("Users").child(currentUsr.uid).child("Images").observeEventType(.Value, withBlock: { snapshot in
                            self.myArray = []
                         
                            
                                for (x, imageKey) in  snapshot.children.enumerate()
                                {

                                   self.myArray.append(imageKey)
                                    
                                }
                            self.myCollectionView.reloadData()
                        })
                    }
            })
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!)
    {
        let accessToken = FBSDKAccessToken.currentAccessToken()
        
        let facebookRequest: FBSDKGraphRequest! = FBSDKGraphRequest(graphPath: "/me/permissions ", parameters: ["fields": "id, email"], HTTPMethod: "DELETE")
        
        facebookRequest.startWithCompletionHandler { (connection: FBSDKGraphRequestConnection!, result: AnyObject!, error: NSError!) -> Void in
            
            if(error == nil && result != nil){
                print("Permission successfully revoked. This app will no longer post to Facebook on your behalf.")
                print("result = \(result)")
            } else {
                print(error.localizedDescription)
                if let error: NSError = error {
                    if let errorString = error.userInfo["error"] as? String {
                        print("errorString variable equals: \(errorString)")
                    }
                } else {
                    print("No value for error key")
                }
            }
        }

        let mainViewController = self.storyboard!.instantiateViewControllerWithIdentifier("MainViewController")
        
        self.navigationController!.pushViewController(mainViewController, animated: true)
        
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!)
    {
        print("nothing here...")
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


            var lines = ""
            for i in images.children
            {
                lines.appendContentsOf(i.value!!)
                
            }
   
            do
            {
                
                let imageData = try NSData(base64EncodedString: lines ,
                                             options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)?.decompress()
                
                let decodedImage = UIImage(data:imageData!)

                cell.myImageView.image = decodedImage

            }
            
            catch{}
        
        return cell
        
        
    }

}
