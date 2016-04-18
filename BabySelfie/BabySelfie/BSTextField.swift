//
//  BSTextField.swift
//  BabySelfie
//
//  Created by Juliana Lima on 3/31/16.
//  Copyright © 2016 Juliana Lacerda. All rights reserved.
//

import UIKit

class BSTextField: UITextField {

    let padding = UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 5);
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return self.newBounds(bounds)
    }
    
    override func placeholderRectForBounds(bounds: CGRect) -> CGRect {
        return self.newBounds(bounds)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return self.newBounds(bounds)
    }
    
    private func newBounds(bounds: CGRect) -> CGRect {
        
        var newBounds = bounds
        newBounds.origin.x += padding.left
        newBounds.origin.y += padding.top
        newBounds.size.height -= padding.top + padding.bottom
        newBounds.size.width -= padding.left + padding.right
        return newBounds
    }

}
