//
//  commentsViewController.swift
//  PYT
//
//  Created by Niteesh on 02/11/16.
//  Copyright © 2016 appsMaven. All rights reserved.
//

import UIKit
import SDWebImage


class commentsViewController: UIViewController {
    
    
    
    @IBOutlet var commentsTable: UITableView!
    
    var commentsArray = NSArray()
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = true
    }
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentsTable.estimatedRowHeight = 80.0
        commentsTable.rowHeight = UITableViewAutomaticDimension
        
        
        // Do any additional setup after loading the view.
        self.tabBarController?.tabBar.hidden = true
    }
    
    
    //MARK:- BACk button action
    
    @IBAction func backBtnAction(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
        self.dismissViewControllerAnimated(true, completion: {})
        NSURLCache.sharedURLCache().removeAllCachedResponses()
        
    }
    
    
    
    
    //MARk:-
    //MARK:- Data source and delegates of the tableView
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return commentsArray.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("comments")!
        
        
        
        
        let imageName2 = commentsArray.objectAtIndex(indexPath.row).valueForKey("userPhoto") as! String
        
        let url2 = NSURL(string: imageName2 )
        
        
        
        
        let pImage : UIImage = UIImage(named:"backgroundImage")!
        
        
        
        
        
        
        
        let userProfilePicture = cell.contentView .viewWithTag(1234) as! UIImageView
        userProfilePicture.layer.cornerRadius = userProfilePicture.frame.size.width/2
        userProfilePicture.clipsToBounds = true
        
        
        let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in
            
        }
        
        //completion block of the sdwebimageview
        userProfilePicture.sd_setImageWithURL(url2, placeholderImage: pImage, completed: block)
        
        
        
        let userNameLabel = cell.contentView .viewWithTag(1235) as! UILabel
        userNameLabel.text = self.commentsArray.objectAtIndex(indexPath.row).valueForKey("userName") as? String
        
        let userCommentLabel = cell.contentView .viewWithTag(1236) as! UITextView
        userCommentLabel.text = self.commentsArray.objectAtIndex(indexPath.row).valueForKey("comment") as! String
        
        let commentTimeLabel = cell.contentView .viewWithTag(1237) as! UILabel
        commentTimeLabel.text = ""
        
        return cell
        
    }
    
   
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
            NSURLCache.sharedURLCache().removeAllCachedResponses()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
