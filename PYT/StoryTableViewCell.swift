//
//  StoryTableViewCell.swift
//  PYT
//
//  Created by Niteesh on 22/11/16.
//  Copyright © 2016 appsMaven. All rights reserved.
//

import UIKit

class StoryTableViewCell: UITableViewCell {

    @IBOutlet var widthOfloactionName: NSLayoutConstraint!
    
    @IBOutlet var museumName: UILabel!
    @IBOutlet var deleteBtn: UIButton!
   
    @IBOutlet var locationImage: UIImageView!
    @IBOutlet var checkMarkBtn: UIButton!
    @IBOutlet var whiteLabel: UILabel!
    @IBOutlet var mainView: UIView!

    @IBOutlet var detailBtn: UIButton!
    @IBOutlet var locLabel: UILabel!
    
    @IBOutlet var rightHalfView: UIImageView!
    @IBOutlet var leftHalfView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
           // layoutMargins = UIEdgeInsetsMake(8, 0, 8, 0)
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
