//
//  BSItemMenuTableViewCell.swift
//  BabySelfie
//
//  Created by Juliana Lima on 4/11/16.
//  Copyright © 2016 Juliana Lacerda. All rights reserved.
//

import UIKit

class BSItemMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
