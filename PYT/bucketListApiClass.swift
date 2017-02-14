//
//  bucketListApiClass.swift
//  PYT
//
//  Created by Niteesh on 19/01/17.
//  Copyright © 2017 appsMaven. All rights reserved.
//

import UIKit
import SwiftyJSON
import SystemConfiguration
import MBProgressHUD


///create a delegate for intract with server
protocol apiClassBucketDelegate
{
    func serverResponseArrivedBucket(Response:AnyObject)
}



class bucketListApiClass: NSObject {

     var delegate:apiClassBucketDelegate! = nil
    
    static var instance: bucketListApiClass!
    
    // SHARED INSTANCE
    class func sharedInstance() -> bucketListApiClass
    {
        self.instance = (self.instance ?? bucketListApiClass())
        return self.instance
    }
    
    
    
    
    
    
    //MARK:- Post api to add to bucket 
    
    //MARK:-
    
    
    func postRequestForAddBucket(parameterString : String , viewController : UIViewController)
    {
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
            // CommonFunctionsClass.sharedInstance().startIndicator(viewController.view)
            
            var urlString = NSString(string: "\(appUrl)addBucket")
            print("WS URL----->>" + (urlString as String))
            
            urlString = urlString .stringByReplacingOccurrencesOfString(" ", withString: "%20")
            
            let url:NSURL = NSURL(string: urlString as String)!
            let session = NSURLSession.sharedSession()
            session.configuration.timeoutIntervalForRequest=20
            // session.configuration.timeoutIntervalForResource=40
            
            
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
            
            
            request.HTTPBody = parameterString.dataUsingEncoding(NSUTF8StringEncoding)
            
            
            
            
            
            let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
                
                NSOperationQueue.mainQueue().addOperationWithBlock
                    {
                        
                        if data == nil
                        {
                            CommonFunctionsClass.sharedInstance().alertViewOpen("Server is not responding", viewController: viewController)
                           // MBProgressHUD.hideAllHUDsForView(viewController.view, animated: true)
                            MBProgressHUD.hideHUDForView(viewController.view, animated: true)
                            
                        }
                        else
                        {
                            
                            
                            do {
                                
                                let result = NSString(data: data!, encoding:NSASCIIStringEncoding)!
                                print("Body: \(result)")
                                
                              //  CommonFunctionsClass.sharedInstance().alertViewOpen(result as String, viewController: viewController)
                                
                                
                                dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {                                    let defaults = NSUserDefaults.standardUserDefaults()
                                    let uId = defaults .stringForKey("userLoginId")
                                    let objt = storyCountClass()
                                    objt.postRequestForcountStory("userId=\(uId!)")
                                    
                                })
                                
                                
                                
                                let anyObj: AnyObject = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                                jsonResult = NSDictionary()
                                jsonResult = anyObj as! NSDictionary
                                if jsonResult.valueForKey("status") as! NSNumber == 1{
                                    
                                    bucketListTotalCount = "\(jsonResult.valueForKey("count")!)"
                                    print(bucketListTotalCount)
                                    
                                    NSNotificationCenter.defaultCenter().postNotificationName("loadCount", object: nil)
                                    NSNotificationCenter.defaultCenter().postNotificationName("loadCount", object: nil)
                                    
                                }
                                
                                MBProgressHUD.hideAllHUDsForView(viewController.view, animated: true)
                                
                                
                                
                                
                               // self.delegate.serverResponseArrivedBucket(anyObj)
                                
                                
                            } catch
                            {
                                print("json error: \(error)")
                                CommonFunctionsClass.sharedInstance().alertViewOpen("Sorry there is some issue in backend, Please try again", viewController: viewController)
                                indicatorClass.sharedInstance().hideIndicator()
                                MBProgressHUD.hideAllHUDsForView(viewController.view, animated: true)
                            }
                            
                            
                            
                            
                            
                            
                        }
                }
            })
            
            task.resume()
        }
        else
        {
            CommonFunctionsClass.sharedInstance().alertViewOpen("Please Check Internet Connection", viewController: viewController)
            MBProgressHUD.hideAllHUDsForView(viewController.view, animated: true)
        }
        
    }
    
    
    
    
    
    
    
    
    
    //MARK:- post Api to get the bucket list 
    
    func postRequestForGetBucketList(parameterString : String , viewController : UIViewController)
    {
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
            // CommonFunctionsClass.sharedInstance().startIndicator(viewController.view)
            
            var urlString = NSString(string: "\(appUrl)getBucket")
            print("WS URL----->>" + (urlString as String))
            
            urlString = urlString .stringByReplacingOccurrencesOfString(" ", withString: "%20")
            
            let url:NSURL = NSURL(string: urlString as String)!
            let session = NSURLSession.sharedSession()
            session.configuration.timeoutIntervalForRequest=20
            // session.configuration.timeoutIntervalForResource=40
            
            
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
            
            
            request.HTTPBody = parameterString.dataUsingEncoding(NSUTF8StringEncoding)
            
            
            
            
            
            let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
                
                NSOperationQueue.mainQueue().addOperationWithBlock
                    {
                        
                        if data == nil
                        {
                            CommonFunctionsClass.sharedInstance().alertViewOpen("Server is not responding", viewController: viewController)
                            MBProgressHUD.hideAllHUDsForView(viewController.view, animated: true)
                        }
                        else
                        {
                            
                            
                            do {
                                
                                let result = NSString(data: data!, encoding:NSASCIIStringEncoding)!
                                print("Body: \(result)")
                                
                               // CommonFunctionsClass.sharedInstance().alertViewOpen(result as String, viewController: viewController)
                                
                                
                                let anyObj: AnyObject = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                                
                                 self.delegate.serverResponseArrivedBucket(anyObj)
                                
                                
                            } catch
                            {
                                print("json error: \(error)")
                                CommonFunctionsClass.sharedInstance().alertViewOpen("Sorry there is some issue in backend, Please try again", viewController: viewController)
                                indicatorClass.sharedInstance().hideIndicator()
                                MBProgressHUD.hideAllHUDsForView(viewController.view, animated: true)
                            }
                            
                            
                            
                            
                            
                            
                        }
                }
            })
            
            task.resume()
        }
        else
        {
            CommonFunctionsClass.sharedInstance().alertViewOpen("Please Check Internet Connection", viewController: viewController)
            MBProgressHUD.hideAllHUDsForView(viewController.view, animated: true)
        }
        
        
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {                                    let defaults = NSUserDefaults.standardUserDefaults()
            let uId = defaults .stringForKey("userLoginId")
            let objt = storyCountClass()
            objt.postRequestForcountStory("userId=\(uId!)")
        })
        
        
    }
    
    
    
    //MARK: delete location from bucket list
    
    func postRequestForDeletBucketList(parameterString : String , viewController : UIViewController)
    {
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
            // CommonFunctionsClass.sharedInstance().startIndicator(viewController.view)
            
            var urlString = NSString(string: "\(appUrl)deleteBucket")
            print("WS URL----->>" + (urlString as String))
            
            urlString = urlString .stringByReplacingOccurrencesOfString(" ", withString: "%20")
            
            let url:NSURL = NSURL(string: urlString as String)!
            let session = NSURLSession.sharedSession()
            session.configuration.timeoutIntervalForRequest=20
            // session.configuration.timeoutIntervalForResource=40
            
            
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
            
            
            request.HTTPBody = parameterString.dataUsingEncoding(NSUTF8StringEncoding)
            
            
            
            
            
            let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
                
                NSOperationQueue.mainQueue().addOperationWithBlock
                    {
                        
                        if data == nil
                        {
                            CommonFunctionsClass.sharedInstance().alertViewOpen("Server is not responding", viewController: viewController)
                            MBProgressHUD.hideAllHUDsForView(viewController.view, animated: true)
                        }
                        else
                        {
                            
                            
                            do {
                                 MBProgressHUD.hideAllHUDsForView(viewController.view, animated: true)
                                
                                let result = NSString(data: data!, encoding:NSASCIIStringEncoding)!
                                print("Body: \(result)")
                                
                                // CommonFunctionsClass.sharedInstance().alertViewOpen(result as String, viewController: viewController)
                                
                                
                                let anyObj: AnyObject = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                                
                                self.delegate.serverResponseArrivedBucket(anyObj)
                                
                                
                            } catch
                            {
                                print("json error: \(error)")
                                CommonFunctionsClass.sharedInstance().alertViewOpen("Sorry there is some issue in backend, Please try again", viewController: viewController)
                                indicatorClass.sharedInstance().hideIndicator()
                                MBProgressHUD.hideAllHUDsForView(viewController.view, animated: true)
                            }
                            
                            
                            
                            
                            
                            
                        }
                }
            })
            
            task.resume()
        }
        else
        {
            CommonFunctionsClass.sharedInstance().alertViewOpen("Please Check Internet Connection", viewController: viewController)
            MBProgressHUD.hideAllHUDsForView(viewController.view, animated: true)
        }
        
    }

    
    
    
    
    
    
    
}
