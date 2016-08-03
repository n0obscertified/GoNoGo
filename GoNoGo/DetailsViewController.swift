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

    @IBOutlet weak var neutralImage: UIImageView!
    let db = FIRDatabase.database().reference()
    var goImage:GoImage?
    @IBOutlet weak var detailedImage: UIImageView!
    @IBOutlet weak var poopImage: UIImageView!
    @IBOutlet weak var fireImage: UIImageView!
    override func viewDidLoad() {
        self.poopImage.hidden = true;
        self.fireImage.hidden = true;
        self.neutralImage.hidden = true;
        super.viewDidLoad()

        self.navigationController?.navigationBarHidden = false;
        if let image = self.goImage{
            self.detailedImage.image = image.Image
            
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), { 
                self.db.child("Opinions").child(image.ImageKey).observeEventType(.Value, withBlock: { (snapshot) in
                    var json = JSON(snapshot.value!)
                    
                    let value = json.dictionaryObject!["Mean"]
                    
                    dispatch_async(dispatch_get_main_queue(), { 
                        if (value! as! Double == 0.0){
                            self.neutralImage.hidden = false;
                            self.poopImage.hidden = true;
                            self.fireImage.hidden = true;
                        }
                        else if(value! as! Double > 0.0){
                            self.neutralImage.hidden = true;
                            self.poopImage.hidden = true;
                            self.fireImage.hidden = false;
                        }
                            
                        else{
                            self.neutralImage.hidden = true;
                            self.poopImage.hidden = false;
                            self.fireImage.hidden = true;
                        }
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
