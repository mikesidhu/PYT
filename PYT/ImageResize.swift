//
//  ImageResize.swift
//  PYT
//
//  Created by Niteesh on 20/10/16.
//  Copyright © 2016 appsMaven. All rights reserved.
//

import UIKit

class ImageResize: NSObject {

    
    var newImage = UIImage()
    
    
    
    static var instance: ImageResize!
    
    private override init() {
        
    }
    
    // SHARED INSTANCE
    class func sharedInstance() -> ImageResize
    {
        
        self.instance = (self.instance ?? ImageResize())
        return self.instance
    }
    
    
    func resizeImage(senderImage: UIImage, currentView: UIView) -> UIImage {
        
        
        
        let scale = currentView.frame.size.width / senderImage.size.width
        let newHeight = senderImage.size.height * scale
        UIGraphicsBeginImageContext(CGSizeMake(currentView.frame.size.width, newHeight))
        senderImage.drawInRect(CGRectMake(0, 0, currentView.frame.size.width, newHeight))
        let nm = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        newImage = nm
        
       return newImage
        
    }
    
    
    
    
    
}
