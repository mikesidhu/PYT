//
//  indicatorClass.swift
//  PYT
//
//  Created by Niteesh on 15/07/16.
//  Copyright © 2016 appsMaven. All rights reserved.
//

import UIKit
import SwiftSpinner


class indicatorClass: NSObject {

    
    static var instance2: indicatorClass!
    
    
    // SHARED INSTANCE
    class func sharedInstance() -> indicatorClass
    {
        
        self.instance2 = (self.instance2 ?? indicatorClass())
        return self.instance2
    }
    

    
    //MARK:- show indicator with text
    
    func showIndicator(title:String)
    {

        SwiftSpinner.show(title)
        
        
    }
    
    
    
    
    func hideIndicator()
    {
        
        SwiftSpinner.hide()
        
        
    }
    
    
    
    
    
}
