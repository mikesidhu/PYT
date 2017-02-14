//
//  attributedTextClass.swift
//  PYT
//
//  Created by Niteesh on 19/12/16.
//  Copyright © 2016 appsMaven. All rights reserved.
//

import UIKit

class attributedTextClass: NSObject {

    
    
    
    
    
    
    
    
    
    ////MARK:- Attributed text to bold and then regular
    //MARK:-
    
    func setAttributeRobotBold(text1: NSString, text1Size: CGFloat, text2: NSString, text2Size:CGFloat) -> NSAttributedString {
        
        ////Attributed string---///
        
        //  mutableAttributedString.addAttribute((kCTForegroundColorAttributeName as! String), value: (UIColor.blueColor().CGColor as! AnyObject), range: boldRange)
        
        let segAttributeslabel: NSDictionary = [
           NSForegroundColorAttributeName: UIColor.init(colorLiteralRed: 32.0/255, green: 47.0/255, blue: 65.0/255, alpha: 1.0).CGColor,
            NSFontAttributeName: UIFont(name:"Roboto-Bold", size: text1Size)!
        ]
        
        let segAttributeslabel2: NSDictionary = [
            NSForegroundColorAttributeName: UIColor.init(colorLiteralRed: 32.0/255, green: 47.0/255, blue: 65.0/255, alpha: 1.0).CGColor,
            NSFontAttributeName: UIFont(name:"Roboto-Regular", size: text2Size)!
        ]
        
        let attributedString1 = NSMutableAttributedString(string:"\(text1)", attributes:segAttributeslabel as? [String : AnyObject])
        
        let attributedString2 = NSMutableAttributedString(string:"\(text2)", attributes:segAttributeslabel2 as? [String : AnyObject])
        
        attributedString1.appendAttributedString(attributedString2)
        
        return attributedString1
        
        
        
    }
    
    
    
    
    
    
    
    
    
    ////MARK:- Attributed text to bold and then Light
    //MARK:-
    
    func setAttributeRobotLight(text1: NSString, text1Size: CGFloat, text2: NSString, text2Size:CGFloat) -> NSAttributedString {
        
        ////Attributed string---///
        
        //  mutableAttributedString.addAttribute((kCTForegroundColorAttributeName as! String), value: (UIColor.blueColor().CGColor as! AnyObject), range: boldRange)
        
        let segAttributeslabel: NSDictionary = [
            NSForegroundColorAttributeName: UIColor.init(colorLiteralRed: 32.0/255, green: 47.0/255, blue: 65.0/255, alpha: 1.0).CGColor,
            NSFontAttributeName: UIFont(name:"Roboto-Bold", size: text1Size)!
        ]
        
        let segAttributeslabel2: NSDictionary = [
            NSForegroundColorAttributeName: UIColor.init(colorLiteralRed: 32.0/255, green: 47.0/255, blue: 65.0/255, alpha: 1.0).CGColor,
            NSFontAttributeName: UIFont(name:"Roboto-Light", size: text2Size)!
        ]
        
        let attributedString1 = NSMutableAttributedString(string:"\(text1)", attributes:segAttributeslabel as? [String : AnyObject])
        
        let attributedString2 = NSMutableAttributedString(string:"\(text2)", attributes:segAttributeslabel2 as? [String : AnyObject])
        
        attributedString1.appendAttributedString(attributedString2)
        
        return attributedString1
        
        
        
    }

    
    
    
    
    
    
    
    
}
