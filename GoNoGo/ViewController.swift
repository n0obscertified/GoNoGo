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
    
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    
    var userEmail:String=""
    var userPassword:String=""
    
    var ref:FIRDatabaseReference? = FIRDatabase.database().reference()

    
    @IBAction func email(sender: UITextField) {
        self.userEmail = sender.text!
    }
    
    @IBAction func password(sender: UITextField) {
        self.userPassword = sender.text!
    }
    
    
    @IBAction func LogIn(sender: UIButton)
    {
        LogInAndNavigate()
    }
    
    private func LogInAndNavigate()
    {
        if(self.userEmail.isEmpty || self.userPassword.isEmpty){
            let alertController = UIAlertController(title: "Uh oh!", message:"Please enter all the fields to Log In", preferredStyle: .Alert)
            self.presentViewController(alertController, animated: true, completion: nil)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                alertController.dismissViewControllerAnimated(true, completion: nil)
                
            }
            alertController.addAction(okAction)
        }
        else {
            FIRAuth.auth()?.signInWithEmail(self.userEmail, password: self.userPassword, completion: { (user, err) in
                if user != nil{
                    
                    let cameraViewController = self.storyboard!.instantiateViewControllerWithIdentifier("PageView")
                    print("navigating to the next view controller from view did load")
                    
                    self.navigationController!.showViewController(cameraViewController, sender: self)
                }
                else{
                    let alertController = UIAlertController(title: "Uh oh!", message: err?.localizedDescription, preferredStyle: .Alert)
                    self.presentViewController(alertController, animated: true, completion: nil)
                    
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                        UIAlertAction in
                        alertController.dismissViewControllerAnimated(true, completion: nil)
                    }
                    
                    alertController.addAction(okAction)
                    self.logInButton.hidden = true
                    self.signUpButton.hidden = false;
                }
            })
        }

    }
    
    
    @IBAction func SignUpAndLogIn(sender: UIButton)
    {
        FIRAuth.auth()?.createUserWithEmail(self.userEmail, password: self.userPassword)
        { (user, err) in
            if user != nil{
              self.LogInAndNavigate()
            }
            else
            {
                let alertController = UIAlertController(title: "Uh oh!", message: err?.localizedDescription, preferredStyle: .Alert)
                self.presentViewController(alertController, animated: true, completion: nil)
                
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                    UIAlertAction in
                    alertController.dismissViewControllerAnimated(true, completion: nil)
                }
                alertController.addAction(okAction)
            }
        }
    }
    
    
    var croppingEnabled: Bool = false
    
    var libraryEnabled: Bool = true
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
 
        if FBSDKAccessToken.currentAccessToken() != nil
        {
            let facebookAuth = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
        
            
            FIRAuth.auth()?.signInWithCredential(facebookAuth)
            { (user, error) in
            
                if let rcverror = error
                {
                    print(rcverror)
                }
                else
                {
                    print(user)
                }
            }
        }
        
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.signUpButton.hidden = true
        self.FbLogIn.delegate = self;
        self.FbLogIn.readPermissions = ["public_profile", "email"]
        
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
        let deletepermission = FBSDKGraphRequest(graphPath: "me/permissions/", parameters: nil, HTTPMethod: "DELETE")
        deletepermission.startWithCompletionHandler({(connection,result,error)-> Void in
            print("the delete permission is \(result)")
            
        })
        
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        
    }
    
    
}

