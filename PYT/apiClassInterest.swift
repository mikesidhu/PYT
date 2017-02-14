//
//  apiClassInterest.swift
//  PYT
//
//  Created by Niteesh on 26/11/16.
//  Copyright © 2016 appsMaven. All rights reserved.
//

import UIKit
import SwiftyJSON
import SystemConfiguration
import MBProgressHUD


///create a delegate for intract with server
protocol apiClassInterestDelegate
{
    func serverResponseArrivedInterest(Response:AnyObject)
}



class apiClassInterest: NSObject {

    
    
    let baseUrlInterest = ""
    let baseUrlInterestData = "\(appUrl)" //LIVE URL
    
    //let baseUrlInterestData = "http://35.163.56.71/" //Test Url
   
    
    var delegate:apiClassInterestDelegate! = nil
    
    static var instance: apiClassInterest!
    
    // SHARED INSTANCE
    class func sharedInstance() -> apiClassInterest
    {
        self.instance = (self.instance ?? apiClassInterest())
        return self.instance
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    ////////////////////////////////////////////////////////////////////////////////
    //MARK:- Posr api to save the interests of the user in database
    //MARK:-
    
    func postRequestInterest(parameterString : String , viewController : UIViewController)
    {
        
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
        
            let request = NSMutableURLRequest(URL: NSURL(string: "\(appUrl)setUserInterest")!) //Live Url
            
             //let request = NSMutableURLRequest(URL: NSURL(string: "http://35.163.56.71/setUserInterest")!) //Test url
            
            
            request.HTTPMethod = "POST"
            
            let postString = parameterString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
            print(postString)
            
            let session = NSURLSession.sharedSession()
            session.configuration.timeoutIntervalForRequest=20
          //  session.configuration.timeoutIntervalForResource=30
            
            
            request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
                guard error == nil && data != nil else {                                                          // check for fundamental networking error
                    print("error=\(error)")
                    return
                }
                
                if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                }
                
                let responseString = String(data: data!, encoding: NSUTF8StringEncoding)
                print("responseString = \(responseString)")
                
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    do {
                        
                        let result = NSString(data: data!, encoding:NSASCIIStringEncoding)!
                        print("Body: \(result)")
                        
                        let anyObj: AnyObject = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                        
                        if (viewController .isKindOfClass(chooseInterestsViewController)){
                            
                           MBProgressHUD.hideAllHUDsForView(viewController.view, animated: true)
                            self.delegate.serverResponseArrivedInterest(anyObj)
                            
                        }
                        
                        
                        //  self.delegate.serverResponseArrived(anyObj)
                        
                        
                        
                        
                    } catch {
                        print("json error: \(error)")
                        CommonFunctionsClass.sharedInstance().alertViewOpen("Sorry there is some issue in backend, Please try again", viewController: viewController)
                        indicatorClass.sharedInstance().hideIndicator()
                        
                        
                        
                    }
                    
                    
                  
                    
                    
                    
                })
                
                
                
                
                
                
                
            }
            task.resume()
            
        }
        else
        {
            CommonFunctionsClass.sharedInstance().alertViewOpen("Please Check Internet Connection", viewController: viewController)
            MBProgressHUD.hideAllHUDsForView(viewController.view, animated: true)
        }
        
        
    }
    
    
    
    
    
    
    
    ///////// testing for interest wise data api
    
    
    func postRequestInterestWiseData(parameterString : String , viewController : UIViewController)
    {
        
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
            let request = NSMutableURLRequest(URL: NSURL(string: "\(appUrl)getPicturesInterest")!)//Live url
           
            
           // let request = NSMutableURLRequest(URL: NSURL(string: "http://35.163.56.71/getPicturesInterest")!)//Test url
            
            request.HTTPMethod = "POST"
            
            let postString = parameterString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
            print(postString)
            
            
            
            let session = NSURLSession.sharedSession()
            session.configuration.timeoutIntervalForRequest=20
            //session.configuration.timeoutIntervalForResource=40
            
            
            request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
                guard error == nil && data != nil else {                                                          // check for fundamental networking error
                    print("error=\(error)")
                    return
                }
                
                if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    //print("response = \(response)")
                }
                
                //  let responseString = String(data: data!, encoding: NSUTF8StringEncoding)
                //print("responseString = \(responseString)")
                
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    do {
                        
                        let result = NSString(data: data!, encoding:NSASCIIStringEncoding)!
                        //print("Body: \(result)")
                        
                        let anyObj: AnyObject = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                        
                        self.delegate.serverResponseArrivedInterest(anyObj)
                        
                        
                    } catch
                    {
                        print("json error: \(error)")
                        CommonFunctionsClass.sharedInstance().alertViewOpen("Sorry there is some issue in backend, Please try again", viewController: viewController)
                        indicatorClass.sharedInstance().hideIndicator()
                        
                        
                        
                    }
                    MBProgressHUD.hideAllHUDsForView(viewController.view, animated: true)
                    
                    
                    
                })
                
                
                
                
                
                
                
            }
            task.resume()
            
        }
        else
        {
            CommonFunctionsClass.sharedInstance().alertViewOpen("Please Check Internet Connection", viewController: viewController)
            MBProgressHUD.hideAllHUDsForView(viewController.view, animated: true)
        }
        
        
    }
    
    
    
    
    
    //////////////////////////////--------- Post api to Trending Places------------///////////////
    
    

    
    
    
    ////////////////////////////////////////////////////////////////////////
    //MARK:- Post api to get the trending locations
    //MARK:-
    
    func postApiForTrendingLocations(viewController: UIViewController)
    {
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
            let request = NSMutableURLRequest(URL: NSURL(string: "\(appUrl)trending")!)//Live Url
            
            
            //let request = NSMutableURLRequest(URL: NSURL(string: "http://35.163.56.71/trending")!)//Test Url
            
            request.HTTPMethod = "POST"
            let postString = ""
            
            
            let session = NSURLSession.sharedSession()
            session.configuration.timeoutIntervalForRequest=20
           // session.configuration.timeoutIntervalForResource=30
            
            request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
                guard error == nil && data != nil else {                                                          // check for fundamental networking error
                    print("error=\(error)")
                    return
                }
                
                if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    
                }
                
                
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    do {
                        
                        let result = NSString(data: data!, encoding:NSASCIIStringEncoding)!
                       // print("Body: \(result)")
                        
                        let anyObj: AnyObject = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                        
                        self.delegate.serverResponseArrivedInterest(anyObj)
                        
                    } catch {
                        print("json error: \(error)")
                        CommonFunctionsClass.sharedInstance().alertViewOpen("Sorry there is some issue in backend, Please try again", viewController: viewController)
                        
                        
                        
                        
                    }
                    
                    
                    
                    
                })
                
                
                
                
                
                
                
            }
            task.resume()
            
        }
        else
        {
            CommonFunctionsClass.sharedInstance().alertViewOpen("Please Check Internet Connection", viewController: viewController)
        }
        
    }
    
    
    
    
    
    

    
    
    
    

    
    
    
    
}
