//
//  DescriptionViewViewController.swift
//  PYT
//
//  Created by Niteesh on 27/10/16.
//  Copyright © 2016 appsMaven. All rights reserved.
//

import UIKit

class DescriptionViewViewController: UIViewController {
    
    var descriptionString2 = NSString()
    var labelText = NSString()
    
    
    @IBOutlet var descTxtView: UITextView!
    
    @IBOutlet var titleLabel: UILabel!
    
    override func viewWillAppear(animated: Bool) {
         self.tabBarController?.tabBar.hidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(descriptionString2)
        
        var text1 = ""
        var text2 = ""
        var text3 = ""
        
        
        let arr = descriptionString2.componentsSeparatedByString(" ")
        if arr.count>4 {
            text1 = arr[0]
            text2 = arr[1]
            text3 = arr[2]
            
        }
        
        
        let searchQuery = "\(text1) \(text2) \(text3)"
        
        /* Put the search text into the message */
        let message = "\(searchQuery)"
        
        /* Find the position of the search string. Cast to NSString as we want
         range to be of type NSRange, not Swift's Range<Index> */
        let range = (message as NSString).rangeOfString(searchQuery)
        
        /* Make the text at the given range bold. Rather than hard-coding a text size,
         Use the text size configured in Interface Builder. */
        
        var attributedString = NSMutableAttributedString(string: descriptionString2 as String, attributes:  [NSFontAttributeName: UIFont(name:"Roboto-Regular", size: 15.0)!])
        
        
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 9
        
        let boldAttr: NSDictionary = [
            NSForegroundColorAttributeName: UIColor.blackColor(),
            NSFontAttributeName: UIFont(name:"Roboto-Bold", size: 17.0)! ,NSParagraphStyleAttributeName : style
        ]
        
        
        
        
        
        
        
        // Part of string to be bold
        attributedString.addAttributes(boldAttr as! [String : AnyObject], range: range)
        
        
        // 4
        /* Put the text in a label */
        self.descTxtView.attributedText = attributedString
        
        
        
        
        //descTxtView.text=descriptionString2 as String
        titleLabel.text=title
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        NSURLCache.sharedURLCache().removeAllCachedResponses()
    }
    
    
    @IBAction func backAction(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
        self.dismissViewControllerAnimated(true, completion: {})
        NSURLCache.sharedURLCache().removeAllCachedResponses()
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
