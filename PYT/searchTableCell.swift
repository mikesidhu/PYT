//
//  searchTableCell.swift
//  PYT
//
//  Created by Niteesh on 17/11/16.
//  Copyright © 2016 appsMaven. All rights reserved.
//

import UIKit

class searchTableCell: UITableViewCell {

    
    @IBOutlet var locationImage: UIImageView!
    
    
    @IBOutlet var profileImage: UIImageView!
    
    @IBOutlet weak var profileBorder: UIImageView!
    @IBOutlet var bloggerName: UILabel!
    
    @IBOutlet weak var whiteView: UIView!
   
    @IBOutlet weak var blogsBtnLbl: UIButton!
    
    @IBOutlet weak var likesBtnLbl: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
