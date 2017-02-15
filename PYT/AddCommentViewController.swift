//
//  AddCommentViewController.swift
//  PYT
//
//  Created by Niteesh on 14/02/17.
//  Copyright © 2017 appsMaven. All rights reserved.
//

import UIKit
import SDWebImage
import IQKeyboardManager

class AddCommentViewController: UIViewController {

    
    var imgUrl = NSString()
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBOutlet weak var commenttextView: UITextView!
    
    @IBOutlet weak var addCommentButton: UIButton!
    
    
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    IQKeyboardManager.sharedManager().shouldResignOnTouchOutside=true
        
        
        let url2 = NSURL(string: imgUrl as String)
        
        let pImage : UIImage = UIImage(named:"backgroundImage")!
      
        let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in
           
        }
        
        //completion block of the sdwebimageview
        imageView.sd_setImageWithURL(url2, placeholderImage: pImage, completed: block)
        
    
        // Do any additional setup after loading the view.
    }



    @IBAction func addCommentAction(sender: AnyObject) {
    
    
       
        
        
    
    }
    
    @IBAction func backAction(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
