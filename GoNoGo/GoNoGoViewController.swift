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
    
    override func viewDidLoad()
    {
//        FIRAuth.auth()?.addAuthStateDidChangeListener(
//            {
//                (auth, user) in
//                
//                
//                if let currentUsr  = user
//                {
//                
//                    self.database.child("Users").observeEventType(.Value, withBlock: { (snapshot) in
//                        
//                       var get = snapshot.value![currentUsr.uid] as! [String]
//                        
//                    })
//                    
//                    self.database.observeEventType(FIRDataEventType.ChildChanged,withBlock: {
//                        snapshot in
//                        //print(snapshot.c)
//                    })
//                }
//                
//                
//        })

        
        super.viewDidLoad()
    }
}
