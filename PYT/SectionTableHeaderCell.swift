//
//  SectionTableHeaderCell.swift
//  PYT
//
//  Created by Niteesh on 01/09/16.
//  Copyright © 2016 appsMaven. All rights reserved.
//

import UIKit

class SectionTableHeaderCell: UITableViewCell {

    
    @IBOutlet var locationImage: UIImageView!
    @IBOutlet var locationLabelName: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
