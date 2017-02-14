//
//  cellClassTableViewCell.swift
//  PYT
//
//  Created by Niteesh on 06/07/16.
//  Copyright © 2016 appsMaven. All rights reserved.
//

import UIKit

class cellClassTableViewCell: UITableViewCell {

    
    @IBOutlet var ChatButton: UIButton!
    @IBOutlet var userProfilePic: UIImageView!
    
    //@IBOutlet var imagesCollectionView: UICollectionView!
    
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    
    
    
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var useraddressLabel: UILabel!
    
   
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
              
        ChatButton.layer.cornerRadius = 10.0
        ChatButton.clipsToBounds = true
        
        userProfilePic.layer.cornerRadius = userProfilePic.frame.size.width/2
        userProfilePic.clipsToBounds=true
        imagesCollectionView.clipsToBounds=true
      
        
        
        
        
    }
    
    

    
    
    

//    override func setSelected(selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

    
    // MARK: UICollectionViewDataSource
    

    
    var collectionViewOffset: CGFloat {
        get {
            return imagesCollectionView.contentOffset.x
        }
        
        set {
            imagesCollectionView.contentOffset.x = newValue
        }
    }
    
    
    
    
    
    func setCollectionViewDataSourceDelegate<D: protocol<UICollectionViewDataSource, UICollectionViewDelegate>>
        (dataSourceDelegate: D, forRow row: Int , andForSection section : Int) {
        
        
        let queue = NSOperationQueue()
        
        let op1 = NSBlockOperation { () -> Void in
            
            // dispatch_async(dispatch_get_main_queue(), {
            
            self.imagesCollectionView.delegate = dataSourceDelegate
            self.imagesCollectionView.dataSource = dataSourceDelegate
            self.imagesCollectionView.tag = row // tableView indexpathrow equals cell tag
            
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in

        
      
        
       
        
       // imagesCollectionView.pagingEnabled=true
      // self.imagesCollectionView.setContentOffset(CGPointZero, animated: true)
        
       // dispatch_async(dispatch_get_main_queue(), {
          self.imagesCollectionView.reloadData()
       // })
       
            
        })
        
           
        }
        
         queue.addOperation(op1)
        
    }
    
   
   
    
//    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
//        for cell in imagesCollectionView.visibleCells()  as [UICollectionViewCell]    {
//            let indexPath = imagesCollectionView.indexPathForCell(cell as UICollectionViewCell)
//            
//           print(indexPath)
//        }
//    }
   
    
    
    
    

    
    
    
    
}


class collectionViewCellClass: UICollectionViewCell {
    
    
    
    
    
    
    
}



