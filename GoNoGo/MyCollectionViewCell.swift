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
    
    let db = FIRDatabase.database().reference()
    var cellKey:String
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var myImageView: UIImageView!
    
    required override init(frame: CGRect) {
        cellKey = ""
      super.init(frame: frame)

    }
    
    required init?(coder aDecoder: NSCoder) {
        cellKey = ""
        super.init(coder: aDecoder)
    }
    
    public func getScores(){
        self.db.child("Opinions").child(cellKey).observeEventType(.Value, withBlock: { (snapshot) in
            var json = JSON(snapshot.value!)
            
            let value = json.dictionaryObject!["Mean"]
            
            self.score.text = "\(value!)"
        })
    }
    
}
