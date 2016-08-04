//
//  Util.swift
//  GoNoGo
//
//  Created by Miwand Najafe on 2016-08-04.
//  Copyright © 2016 Ismael. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func hideKeyBoardWhenTapped() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

}

