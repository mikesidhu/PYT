//
//  thirdPageTableViewCell.swift
//  PYT
//
//  Created by Niteesh on 02/09/16.
//  Copyright © 2016 appsMaven. All rights reserved.
//

import UIKit

class thirdPageTableViewCell: UITableViewCell {

    @IBOutlet var categoryImage: UIImageView!//Icons of category images
    @IBOutlet var categoryLabel: UILabel!//name of category icons
    
    @IBOutlet var imagesCollectionView: UICollectionView!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCollectionViewDataSourceDelegate<D: protocol<UICollectionViewDataSource, UICollectionViewDelegate>>
        (dataSourceDelegate: D, forRow row: Int , andForSection section : Int) {
        
        imagesCollectionView.delegate = dataSourceDelegate
        imagesCollectionView.dataSource = dataSourceDelegate
        imagesCollectionView.tag = row // tableView indexpathrow equals cell tag
        
         dispatch_async(dispatch_get_main_queue(), {
            
        self.imagesCollectionView.reloadData()
        
         })
        
        
        
    }
    

}
