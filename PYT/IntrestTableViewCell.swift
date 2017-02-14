//
//  IntrestTableViewCell.swift
//  PYT
//
//  Created by Niteesh on 11/11/16.
//  Copyright © 2016 appsMaven. All rights reserved.
//

import UIKit

class IntrestTableViewCell: UITableViewCell {

    @IBOutlet var museumNameLabel: UILabel!
    
    @IBOutlet var contactButton: UIButton!
    
    @IBOutlet var museumImage: UIImageView!
    
    @IBOutlet var locationLabel: UILabel!
    
    @IBOutlet var beenThereLabel: UILabel!
    
    @IBOutlet var outsideView: UIView!
    
    @IBOutlet var clock: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
        museumImage.contentMode = .ScaleAspectFill
        museumImage.layer.cornerRadius=4
        museumImage.clipsToBounds=true
        
        outsideView.layer.cornerRadius=6
        outsideView.clipsToBounds=true
        outsideView.layer.shadowColor = UIColor .lightGrayColor().CGColor
        outsideView.layer.shadowOffset = CGSizeMake(0, 2.5)
        outsideView.layer.shadowOpacity = 0.7
        outsideView.layer.shadowRadius = 1.0
        
       
        
        //            let maskPath = UIBezierPath(roundedRect: cell.bottomView.bounds, byRoundingCorners: ([.BottomLeft, .BottomRight]), cornerRadii: CGSizeMake(8.0, 8.0))
        //            let maskLayer = CAShapeLayer()
        //            maskLayer.frame = self.view!.bounds
        //            maskLayer.path = maskPath.CGPath
        //        cell.bottomView.layer.mask = maskLayer
        
        
        
       
        
        
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
