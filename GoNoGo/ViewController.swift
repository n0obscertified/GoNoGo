//
//  ViewController.swift
//  GoNoGo
//
//  Created by Ismael on 7/24/16.
//  Copyright © 2016 Ismael. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase
import FirebaseAuth
import ALCameraViewController
class ViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var FbLogIn: FBSDKLoginButton!
    
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    
    var ref:FIRDatabaseReference? = FIRDatabase.database().reference()

    
    var croppingEnabled: Bool = false
    
    var libraryEnabled: Bool = true
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
 
        if FBSDKAccessToken.currentAccessToken() != nil
        {
            let facebookAuth = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
        
            
            FIRAuth.auth()?.signInWithCredential(facebookAuth)
            { (user, error) in
            
                if let rcverror = error{
                    print(rcverror)
                }
                else{
                    print(user)
                }
            }
        }

    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.FbLogIn.delegate = self;
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            
            
            print("User is already loggen in....")
            let cameraViewController = self.storyboard!.instantiateViewControllerWithIdentifier("PageView")
            print("navigating to the next view controller from view did load")
            
            self.navigationController!.showViewController(cameraViewController, sender: self)
            
        }
        else
        {
            self.FbLogIn.readPermissions = ["public_profile", "email"]
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!)
    {
        if ((error) != nil)
        {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email")
            {
            
                
            
                let cameraViewController = storyboard!.instantiateViewControllerWithIdentifier("PageView")
                print("navigating to the next view controller")
                
                self.navigationController!.pushViewController(cameraViewController, animated: true)
                
            }
        }
    }
    

    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!)
    {
        print("Print User logged out")
        
        FBSDKAccessToken.setCurrentAccessToken(nil)
        FBSDKProfile.setCurrentProfile(nil)
        
        let deletepermission = FBSDKGraphRequest(graphPath: "me/permissions/", parameters: nil, HTTPMethod: "DELETE")
        deletepermission.startWithCompletionHandler({(connection,result,error)-> Void in
            print("the delete permission is \(result)")
            
        })
        
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        
    }
    
    
}

