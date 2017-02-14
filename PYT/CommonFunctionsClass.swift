//
//  CommonFunctionsClass.swift
//  NightLife
//
//  Created by Gurie on 02/06/16.
//  Copyright © 2016 OSX. All rights reserved.
//

import UIKit
import SystemConfiguration
//import SwiftLoader
//import SwiftSpinner



var jsonResult = NSDictionary()
var basicInfo = NSMutableDictionary()
var deviceTokenString = String()
var flag = Int()
var flag1  = Int()
var indexNumber = NSInteger()
var userType : String!
var userID : String!
var UserName : String!
var UserLocation: String!
var UserImage: NSURL!
var jsonArray = NSArray()
var jsonMutableArray = NSMutableArray()


class CommonFunctionsClass: NSObject
    
{
    
    static var instance: CommonFunctionsClass!
    
    
    // SHARED INSTANCE
    class func sharedInstance() -> CommonFunctionsClass
    {
        
        self.instance = (self.instance ?? CommonFunctionsClass())
        return self.instance
    }
    
 
     //MARK:-  ********** alertview **********
     //MARK:-
    
    func alertViewOpen(title:String,  viewController : UIViewController)
    {
        let alertController = UIAlertController(title: "PYT!", message: title, preferredStyle: .Alert)
        
        let button = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:{(alert: UIAlertAction!) in
            
        })
        
        alertController.addAction(button)
        viewController.presentViewController(alertController, animated: true, completion:{})
    }
    
    
    
    //MARK:- Activity Indicator
    //MARK:-
    
//    func progressBarDisplayer(msg:String, _ indicator:Bool ) {
//        print(msg)
//        
//         var activityIndicator = UIActivityIndicatorView()
//        
//       let strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 200, height: 50))
//        strLabel.text = msg
//        strLabel.textColor = UIColor.whiteColor()
//       let messageFrame = UIView(frame: CGRect(x: self.view.frame.midX - 90, y: self.view.frame.midY - 25 , width: 180, height: 50))
//        messageFrame.layer.cornerRadius = 15
//        messageFrame.backgroundColor = UIColor(white: 0, alpha: 0.7)
//        if indicator {
//            activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
//            activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
//            activityIndicator.startAnimating()
//            messageFrame.addSubview(activityIndicator)
//        }
//        messageFrame.addSubview(strLabel)
//        self.view.addSubview(messageFrame)
//    }
//    
    
    
    
    
    
    
    
    
    
    
     //MARK:-  ********** email validation **********
     //MARK:-
    
    func isValidEmail(testStr:String) -> Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluateWithObject(testStr)
        
        return result
    }
    
    
    //MARK:-  ********** Activity Indicator **********
    //MARK:-
    
//    func startIndicator(view:UIView)
//    {
//       // SwiftLoader.show(title: "Loading...", animated: true)
//        SwiftSpinner.show("Loading...")
//
//    }
//    
//    
//    func stopIndicator(view:UIView)
//    {
//         //SwiftLoader.hide()
//        SwiftSpinner.hide()
//        
//    }
//    
    
    //MARK:-  ********** Reachability (Internet Connection check) **********
    //MARK:-
    
    func isConnectedToNetwork() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress)
            {
                SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags)
        {
            return false
        }
        
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
}


//MARK:-  ********** Extension Method For round , gradient color **********
//MARK:-

extension UIView
{
    
    func setPoperties(radiusValue:CGFloat ,borderWidth:CGFloat , borderColor:UIColor ,bgColor:UIColor , alpha:CGFloat)
    {

        self.clipsToBounds = true
        self.layer.masksToBounds = true
        self.layer.cornerRadius = radiusValue
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.CGColor
        self.backgroundColor = bgColor
        self.alpha = alpha
        
    }
    
    func setGradientColor(upperColor:UIColor , lowerColor:UIColor)
    {
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [upperColor.CGColor, lowerColor.CGColor]
        gradient.frame = self.bounds
        self.layer.insertSublayer(gradient, atIndex: 0)
    }
    
    
    func roundCorners(corners:UIRectCorner, radius: CGFloat)
    {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.bounds = self.frame
        mask.position = self.center
        mask.path = path.CGPath
        self.layer.mask = mask
        
    }
    
}


