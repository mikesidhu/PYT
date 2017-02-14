//
//  SettingApiClass.swift
//  PYT
//
//  Created by Niteesh on 21/12/16.
//  Copyright © 2016 appsMaven. All rights reserved.
//

import UIKit
import MBProgressHUD




///create a delegate for intract with server
protocol settingClassDelegate
{
    func serverResponseArrivedSetting(Response:AnyObject)
}


class SettingApiClass: NSObject
{

    
  
    
    var delegate:settingClassDelegate! = nil
    
    static var instance: SettingApiClass!
    
    // SHARED INSTANCE
    class func sharedInstance() -> SettingApiClass
    {
        self.instance = (self.instance ?? SettingApiClass())
        return self.instance
    }
    
    
    
    ////////////////----MARK: Get api to connect facebook and instagram
    
    
    func Connectfacebook_Instagram(parameterString : String , viewController : UIViewController)
    {
        
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
            
            
            
            let urlString = NSString(string:"\(appUrl)\(parameterString)")
            
            
            //urlString = urlString .stringByReplacingOccurrencesOfString(" ", withString: "%20")
            
            
            let needsLove = urlString
            let safeURL = needsLove.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
            
            let url:NSURL = NSURL(string: safeURL as String)!
            print("Final Url-----> " + (safeURL as String))
            
            //let url:NSURL = NSURL(string: urlString as String)!
            let session = NSURLSession.sharedSession()
            session.configuration.timeoutIntervalForRequest=20
            
            //session.configuration.timeoutIntervalForResource=60
            
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "GET"
            request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
            
            //NSOperationQueue.mainQueue().cancelAllOperations() //clear all the queues
            
            let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
                
                
                
                NSOperationQueue.mainQueue().addOperationWithBlock
                    {
                        
                        
                        if data == nil
                        {
                            CommonFunctionsClass.sharedInstance().alertViewOpen("Server is not responding", viewController: viewController)
                            MBProgressHUD.hideAllHUDsForView(viewController.view, animated: true)
                            indicatorClass.sharedInstance().hideIndicator()
                        }
                        else
                        {
                            
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                
                                do {
                                    
                                    
                                    //    let anyObj = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! [String:AnyObject]
                                    
                                    // let result = NSString(data: data!, encoding:NSASCIIStringEncoding)!
                                    // print("Body: \(result)")
                                    
                                    let anyObj: AnyObject = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                                    
                                    
                                    
                                    
                                    self.delegate.serverResponseArrivedSetting(anyObj)
                                    
                                    
                                    
                                } catch {
                                    print("json error: \(error)")
                                    CommonFunctionsClass.sharedInstance().alertViewOpen("Sorry there is some issue in backend, Please try again", viewController: viewController)
                                    indicatorClass.sharedInstance().hideIndicator()
                                    MBProgressHUD.hideAllHUDsForView(viewController.view, animated: true)
                                }
                                
                                
                                
                                
                            })
                            
                            
                            
                            
                        }
                        
                        //indicatorClass.sharedInstance().hideIndicator()
                }
                
            })
            
            task.resume()
        }
        else
        {
            CommonFunctionsClass.sharedInstance().alertViewOpen("Please Check Internet Connection", viewController: viewController)
            indicatorClass.sharedInstance().hideIndicator()
            MBProgressHUD.hideHUDForView(viewController.view, animated: true)
        }
    }
    
    
    
    
    
    //MARK: API to get the user profile
    
    
    func getUSerProfile(parameterString:NSString, viewController: UIViewController) {
        
        //userId
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
            
            
            
            let urlString = NSString(string:"\(appUrl)userprofile")
            
            
            let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
            
            if isConnectedInternet
            {
                // CommonFunctionsClass.sharedInstance().startIndicator(viewController.view)
                
                var urlString = NSString(string:"\(urlString)")
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
                                print("server not responding")
                                //CommonFunctionsClass.sharedInstance().alertViewOpen("Server is not responding", viewController: viewController)
                                MBProgressHUD.hideAllHUDsForView(viewController.view, animated: true)
                            }
                            else
                            {
                                
                                
                                do {
                                    
                                    let result = NSString(data: data!, encoding:NSASCIIStringEncoding)!
                                    print("Body: \(result)")
                                    
                                    let anyObj: AnyObject = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                                    
                                    print(anyObj)
                                    
                                    basicInfo=NSMutableDictionary()
                                    basicInfo=anyObj as! NSMutableDictionary
                                    
                                    
                                    profileUserData = basicInfo

                                    print(profileUserData)
                                    self.delegate.serverResponseArrivedSetting(anyObj)
                                    
                                    
                                } catch
                                {
                                    print("json error: \(error)")
                                    print("Sorry there is some issue in backend, Please try again")
                                    
                                    //CommonFunctionsClass.sharedInstance().alertViewOpen("Sorry there is some issue in backend, Please try again", viewController: viewController)
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
    
    
    
    
    //MARK:
    //MARK: Change the password of the user
    
    func changePasswordApi(parameterString:NSString, viewController: UIViewController) {
        
        //userId
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
            
            
            
            let urlString = NSString(string:"\(appUrl)changePassword")
            
            
            let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
            
            if isConnectedInternet
            {
                // CommonFunctionsClass.sharedInstance().startIndicator(viewController.view)
                
                var urlString = NSString(string:"\(urlString)")
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
                                print("server not responding")
                                //CommonFunctionsClass.sharedInstance().alertViewOpen("Server is not responding", viewController: viewController)
                                MBProgressHUD.hideAllHUDsForView(viewController.view, animated: true)
                            }
                            else
                            {
                                
                                
                                do {
                                    
                                    let result = NSString(data: data!, encoding:NSASCIIStringEncoding)!
                                    print("Body: \(result)")
                                    
                                    let anyObj: AnyObject = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                                    
                                    print(anyObj)
                                    
                                    basicInfo=NSMutableDictionary()
                                    basicInfo=anyObj as! NSMutableDictionary
                                    
                                    
                                    profileUserData = basicInfo
                                    
                                    print(profileUserData)
                                    self.delegate.serverResponseArrivedSetting(anyObj)
                                    
                                    
                                } catch
                                {
                                    print("json error: \(error)")
                                    print("Sorry there is some issue in backend, Please try again")
                                    
                                    //CommonFunctionsClass.sharedInstance().alertViewOpen("Sorry there is some issue in backend, Please try again", viewController: viewController)
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
    
    
    
    
    
    

    
    
    
}
