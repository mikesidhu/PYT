//
//  PrivacyPolicyViewController.swift
//  PYT
//
//  Created by Niteesh on 09/01/17.
//  Copyright © 2017 appsMaven. All rights reserved.
//

import UIKit

class PrivacyPolicyViewController: UIViewController {

    
    @IBOutlet weak var privacyTextView: UITextView!
    
    @IBOutlet weak var termsTextView: UITextView!
    
    @IBOutlet weak var heightOfContentView: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.privacyTextView.editable=true
        self.privacyTextView.scrollEnabled=false
        
        //self.privacyTextView.text=hotelname
        self.privacyTextView.font=UIFont(name: "Roboto-Regular", size: 15)!
       // self.privacyTextView.textColor = UIColor .lightGrayColor()
        self.privacyTextView.textAlignment=NSTextAlignment .Left
        print("privacy old frame\(self.privacyTextView.frame)")
         let fixedWidth = self.privacyTextView.frame.size.width
        
        let newSize = self.privacyTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
         var newFrame = self.privacyTextView.frame
         newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        self.privacyTextView.frame = newFrame
        
        
        // self.privacyTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
        self.privacyTextView.editable=false
        
        print("privacyTextView new fram \(privacyTextView.frame)")
        
        
        
        
        
        //Terms text view
        
        self.termsTextView.editable=true
        self.termsTextView.scrollEnabled=false
        
        //self.privacyTextView.text=hotelname
        self.termsTextView.font=UIFont(name: "Roboto-Regular", size: 15)!
        // self.privacyTextView.textColor = UIColor .lightGrayColor()
        self.termsTextView.textAlignment=NSTextAlignment .Left
        print("terms old frame\(self.termsTextView.frame)")
        let fixedWidth2 = self.termsTextView.frame.size.width
        
        let newSize2 = self.termsTextView.sizeThatFits(CGSize(width: fixedWidth2, height: CGFloat.max))
        var newFrame2 = self.termsTextView.frame
        newFrame2.size = CGSize(width: max(newSize.width, fixedWidth2), height: newSize2.height)
        self.termsTextView.frame = newFrame2
        
        
       // self.termsTextView.sizeThatFits(CGSize(width: fixedWidth2, height: CGFloat.max))
        self.termsTextView.editable=false
        
        print("termsTextView new fram \(termsTextView.frame)")
        
        
        self.view .layoutIfNeeded()
        self.view .setNeedsLayout()
        
        
        
        
       
    }

    override func viewWillAppear(animated: Bool) {
        
        
        
        self.heightOfContentView.constant=privacyTextView.frame.size.height + termsTextView.frame.size.height + 155
        
    }
    
    
    //MARK:- Back action
    
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
