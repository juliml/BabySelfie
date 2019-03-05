//
//  CheckBoxButton.swift
//  BabySelfie
//
//  Created by Juliana Lacerda on 2019-02-26.
//  Copyright © 2019 Juliana Lacerda. All rights reserved.
//

import UIKit

class CheckBoxButton: UIButton {
    
    // Images
    let checkedImage = UIImage(named: "checkSelected")! as UIImage
    let uncheckedImage = UIImage(named: "check")! as UIImage
    
    // Bool property
    var isChecked: Bool = false {
        didSet{
            if isChecked == true {
                self.setImage(checkedImage, for: .normal)
            } else {
                self.setImage(uncheckedImage, for: .normal)
            }
        }
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        self.isChecked = false
    }
    
    @objc public func buttonClicked(sender: UIButton) {
        if sender == self {
            if isChecked == true {
                isChecked = false
            } else {
                isChecked = true
            }
        }
    }
    
}

