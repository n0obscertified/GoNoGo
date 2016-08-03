//
//  MyCollectionViewCell.swift
//  GoNoGo
//
//  Created by Jeel on 7/28/16.
//  Copyright © 2016 Ismael. All rights reserved.
//

import UIKit
import FirebaseDatabase
import SwiftyJSON
class MyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var poopImage: UIImageView!
    @IBOutlet weak var fireImage: UIImageView!
    @IBOutlet weak var neutralImage: UIImageView!
    
    let db = FIRDatabase.database().reference()
    var cellKey:String
    
    @IBOutlet weak var myImageView: UIImageView!
    
    required override init(frame: CGRect) {
        cellKey = ""
      super.init(frame: frame)

    }
    
    required init?(coder aDecoder: NSCoder) {
        cellKey = ""
        super.init(coder: aDecoder)
    }
    
    internal func setVisibility(){
        self.neutralImage.hidden = true
        self.poopImage.hidden = true
        self.fireImage.hidden = true
    }
    
    internal func getScores(){
        self.db.child("Opinions").child(cellKey).observeEventType(.Value, withBlock: { (snapshot) in
            var json = JSON(snapshot.value!)
            
            let value = json.dictionaryObject!["Mean"]
            
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
    }
    
}
