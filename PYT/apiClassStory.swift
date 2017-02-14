//
//  apiClassStory.swift
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
protocol apiClassStoryDelegate
{
    func serverResponseArrivedStory(Response:AnyObject)
}

class apiClassStory: NSObject {

    
    
    //Live Api
   
    let baseUrlStory = "\(appUrl)user_story"
    let baseUrlStoryToBooking = "\(appUrl)booking"
    let baseUrlDelete  = "\(appUrl)delete_story"
    let allDeleteStory = "\(appUrl)delete_country_story"
 
    
    /*
    //Test Api
    let baseUrlStory = "http://35.163.56.71/user_story"
    let baseUrlStoryToBooking = "http://35.163.56.71/booking"
    let baseUrlDelete  = "http://35.163.56.71/delete_story"
    let allDeleteStory = "http://35.163.56.71/delete_country_story"
    */
    
    
    var delegate:apiClassStoryDelegate! = nil
    
    static var instance: apiClassStory!
    
    // SHARED INSTANCE
    class func sharedInstance() -> apiClassStory
    {
        self.instance = (self.instance ?? apiClassStory())
        return self.instance
    }
    
    
    
    
    
    
    //MARK:- Post api for get images from story
    //MARK:-
    
    func postRequestForGetStory(parameterString : String , viewController : UIViewController)
    {
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
            // CommonFunctionsClass.sharedInstance().startIndicator(viewController.view)
            
            var urlString = NSString(string:"\(baseUrlStory)")
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
                                
                                let anyObj: AnyObject = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                                
                                self.delegate.serverResponseArrivedStory(anyObj)
                                
                                
                            } catch
                            {
                                print("json error: \(error)")
                                CommonFunctionsClass.sharedInstance().alertViewOpen("Sorry there is some issue in backend, Please try again", viewController: viewController)
                                indicatorClass.sharedInstance().hideIndicator()
                                 MBProgressHUD.hideAllHUDsForView(viewController.view, animated: true)
                            }
                            
                            
                            
                            
                            
                            
                            //                            let result = NSString(data: data!, encoding:NSASCIIStringEncoding)!
                            //                            print("Body: \(result)")
                            //
                            //                            let jsonResult: AnyObject = try! NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.MutableContainers)
                            //
                            //                            CommonFunctionsClass.sharedInstance().alertViewOpen(jsonResult.description, viewController: viewController)
                            
                            // self.delegate.serverResponseArrived(jsonResult)
                            
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
    
    
    
    
    
    
    
    
    
    ////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////
    //MARK:- API to delete image from the story
    //MARK:-
   
    
    
    func postRequestDeleteStory(parameters: String , viewController : UIViewController)
    {
    
            let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
            
            if isConnectedInternet
            {
                // CommonFunctionsClass.sharedInstance().startIndicator(viewController.view)
                
                var urlString = NSString(string:"\(baseUrlDelete)")
                print("WS URL----->>" + (urlString as String))
                
                urlString = urlString .stringByReplacingOccurrencesOfString(" ", withString: "%20")
                
                let url:NSURL = NSURL(string: urlString as String)!
                let session = NSURLSession.sharedSession()
                
                session.configuration.timeoutIntervalForRequest=20
              //  session.configuration.timeoutIntervalForResource=40
                
                let request = NSMutableURLRequest(URL: url)
                request.HTTPMethod = "POST"
                request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
                
                
                request.HTTPBody = parameters.dataUsingEncoding(NSUTF8StringEncoding)
                
                
                
                
                
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
                                    
//                                    let anyObj: AnyObject = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                                    
                                    
                                    dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {
                                        let defaults = NSUserDefaults.standardUserDefaults()
                                        let uId = defaults .stringForKey("userLoginId")
                                        let objt = storyCountClass()
                                        objt.postRequestForcountStory("userId=\(uId!)")
                                    })
                                    
                                    
                                   // self.delegate.serverResponseArrivedStory(anyObj)
                                    
                                    
                                }
                                catch
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
        
    
    
    
    
    
    
    
    
    
    
    
    ////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////
    //MARK:- API to add bookings from the story
    //MARK:-
    
    
        func postRequestAddBooking(parameterString : String , parameters: NSDictionary , viewController : UIViewController)
        {
            let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
            
            if isConnectedInternet
            {
                // CommonFunctionsClass.sharedInstance().startIndicator(viewController.view)
                
                var urlString = NSString(string:"\(baseUrlStoryToBooking)")
                print("WS URL----->>" + (urlString as String))
                
                urlString = urlString .stringByReplacingOccurrencesOfString(" ", withString: "%20")
                
                let url:NSURL = NSURL(string: urlString as String)!
                let session = NSURLSession.sharedSession()
                
                session.configuration.timeoutIntervalForRequest=30
               // session.configuration.timeoutIntervalForResource=50
                
                let request = NSMutableURLRequest(URL: url)
                request.HTTPMethod = "POST"
                request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
                
                
                do {
                    let jsonData = try!  NSJSONSerialization.dataWithJSONObject(parameters, options: [])
                    request.HTTPBody = jsonData
                    
                    
                    // here "jsonData" is the dictionary encoded in JSON data
                } catch let error as NSError {
                    print(error)
                }
                
                
                
                // request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(prmt, options: [])
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                
                
                
                let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
                    
                    NSOperationQueue.mainQueue().addOperationWithBlock
                        {
                            
                            if data == nil
                            {
                                CommonFunctionsClass.sharedInstance().alertViewOpen("Server is not responding", viewController: viewController)
                            }
                            else
                            {
                                
                                
                                do {
                                    
                                    let result = NSString(data: data!, encoding:NSASCIIStringEncoding)!
                                    print("Body: \(result)")
                                    
                                    //let anyObj: AnyObject = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                                    
                                    
                                    
                                    
                                    //  self.delegate.serverResponseArrived(anyObj)
                                    MBProgressHUD.hideAllHUDsForView(viewController.view, animated: true)
                                    
                                }
                                catch
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
        
    
    
    
    
    
    
    
    
    ////MARK:- Post Api to delete all stories
    func postRequestDeleteAllStory(parameterString : String, arrayId:NSArray, viewController : UIViewController)
    {
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
            var urlString = NSString(string:"\(allDeleteStory)")
            print("WS URL----->>" + (urlString as String))
            
            urlString = urlString .stringByReplacingOccurrencesOfString(" ", withString: "%20")
            
            let url:NSURL = NSURL(string: urlString as String)!
            let session = NSURLSession.sharedSession()
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
            
            
            
            
            //&imageIds=\([idArr])
            
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
                                
                                //                                    let anyObj: AnyObject = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                                
                                
                                dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {
                                    let defaults = NSUserDefaults.standardUserDefaults()
                                    let uId = defaults .stringForKey("userLoginId")
                                    let objt = storyCountClass()
                                    objt.postRequestForcountStory("userId=\(uId!)")
                                })
                                
                                
                                // self.delegate.serverResponseArrivedStory(anyObj)
                                
                                
                            }
                            catch
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
