//
//  BSCheckBox.swift
//  BabySelfie
//
//  Created by Juliana Lima on 3/31/16.
//  Copyright © 2016 Juliana Lacerda. All rights reserved.
//

import UIKit

class BSCheckBox: UIButton {

    // Images
    let checkedImage = UIImage(named: "checkSelected")! as UIImage
    let uncheckedImage = UIImage(named: "check")! as UIImage
    
    // Bool property
    var isChecked: Bool = false {
        didSet{
            if isChecked == true {
                self.setImage(checkedImage, forState: .Normal)
            } else {
                self.setImage(uncheckedImage, forState: .Normal)
            }
        }
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action: #selector(BSCheckBox.buttonClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.isChecked = false
    }
    
    func buttonClicked(sender: UIButton) {
        if sender == self {
            if isChecked == true {
                isChecked = false
            } else {
                isChecked = true
            }
        }
    }

}
