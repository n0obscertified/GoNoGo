//
//  DetailsViewController.swift
//  GoNoGo
//
//  Created by Jeel on 8/2/16.
//  Copyright © 2016 Ismael. All rights reserved.
//

import UIKit
import FirebaseDatabase
import SwiftyJSON

class DetailsViewController: UIViewController {

    let db = FIRDatabase.database().reference()
    var goImage:GoImage?
    @IBOutlet weak var detailedImage: UIImageView!
    @IBOutlet weak var imageScore: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBarHidden = false;
        if let image = self.goImage{
            self.detailedImage.image = image.Image
            
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), { 
                self.db.child("Opinions").child(image.ImageKey).observeEventType(.Value, withBlock: { (snapshot) in
                    var json = JSON(snapshot.value!)
                    
                    let value = json.dictionaryObject!["Mean"]
                    
                    dispatch_async(dispatch_get_main_queue(), { 
                        self.imageScore.text = "\(value!)"
                    })
                    
                })
            })

        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
