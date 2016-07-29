//
//  ProfileViewController.swift
//  GoNoGo
//
//  Created by Jeel on 7/28/16.
//  Copyright © 2016 Ismael. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
class ProfileViewController: UIViewController, UICollectionViewDataSource {

    var myArray = [""]
    let reuseIdentifier = "cell"
    
    let storage = FIRStorage.storage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FIRAuth.auth()?.addAuthStateDidChangeListener({ (auth, user) in
            if let user = user{
              let base = self.storage.referenceForURL("gs://gonogo-5d73d.appspot.com/\(user.uid)")
                print(base.description)
            }
            
        })
        // Do any additional setup after loading the view.
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
