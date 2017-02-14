//
//  CategoriesCell.swift
//  ImagePost
//
//  Created by OSX on 13/10/16.
//  Copyright © 2016 AppsMaven. All rights reserved.
//

import UIKit

class CategoriesCell: UITableViewCell {

    @IBOutlet var name: UILabel!
    @IBOutlet var checkMark: UIImageView!
    
    @IBOutlet var iconImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
