//
//  BSPhotoCollectionViewCell.swift
//  BabySelfie
//
//  Created by Juliana Lima on 4/8/16.
//  Copyright © 2016 Juliana Lacerda. All rights reserved.
//

import UIKit

class BSPhotoCollectionViewCell: UICollectionViewCell {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        imageView.clipsToBounds = true
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        
        contentView.addSubview(imageView)
    }
    
    override var selected: Bool {
        get {
            return super.selected
        }
        set {
            if newValue {
                super.selected = true
                self.imageView.alpha = 1.0
            } else if newValue == false {
                super.selected = false
                self.imageView.alpha = 0.5
            }
        }
    }
    
}
