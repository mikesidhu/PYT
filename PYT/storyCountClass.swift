//
//  storyCountClass.swift
//  PYT
//
//  Created by Niteesh on 13/12/16.
//  Copyright © 2016 appsMaven. All rights reserved.
//

import UIKit
import SwiftyJSON
import SystemConfiguration





var countArray = NSDictionary()
var bucketImagesArrayGlobal = NSMutableArray()



class storyCountClass: NSObject
{
    
    ////////- post for get count
    
    func postRequestForcountStory(parameterString : String)
    {
        
        
        
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
            //CommonFunctionsClass.sharedInstance().startIndicator(viewController.view)
            
           var urlString = NSString(string:"\(appUrl)getStorydetails") //Live Url
    
           // var urlString = NSString(string:"http://35.163.56.71/getStorydetails") //Test Url
            
            
            print("WS URL----->>" + (urlString as String))
            
            urlString = urlString .stringByReplacingOccurrencesOfString(" ", withString: "%20")
            
            let url:NSURL = NSURL(string: urlString as String)!
            let session = NSURLSession.sharedSession()
            
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
            
            
            
            request.HTTPBody = parameterString.dataUsingEncoding(NSUTF8StringEncoding)
            
            let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
                
                NSOperationQueue.mainQueue().addOperationWithBlock
                    {
                        
                      
                        if data == nil
                        {
//                            CommonFunctionsClass.sharedInstance().alertViewOpen("Server is not responding", viewController: viewController)
                        }
                        else
                        {
                                                        
                            
                            
                            do {
                               
                                let result = NSString(data: data!, encoding:NSASCIIStringEncoding)!
                                print("Body:   ENTERS HERE  \(result)")
                                
                                let anyObj: AnyObject = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                                
                                jsonArray = NSArray()
                                jsonArray = anyObj as! NSArray
                                
                               
                                if jsonArray.count>0{
                                    countArray=jsonArray.objectAtIndex(0) as! NSMutableDictionary
                                    
                                    print(countArray.valueForKey("storyCount"))
                                    print(countArray.valueForKey("storyImages"))
                                    
                                    bucketListTotalCount = "0"
                                    if countArray.objectForKey("bucketCount") != nil {
                                        if let bktCount = countArray.valueForKey("bucketCount"){
                                            
                                            bucketListTotalCount = "\(bktCount)"
                                        }
                                        
                                    }
                                    
                                    
                                    NSNotificationCenter.defaultCenter().postNotificationName("loadCount", object: nil)
                                    
                                    
                                    
                                    
                                    
                                }
                               
                                
                                
                            } catch {
                                print("json error: in getting count of the storyyyyyy------------------------------------- \(error)")
//                                CommonFunctionsClass.sharedInstance().alertViewOpen("Sorry there is some issue in backend, Please try again", viewController: viewController)
                            }
                            
                            
                            
                            
                            
                        }
                        
                }
        
                
            })
                
            
            task.resume()
        }
        else
        {
//            CommonFunctionsClass.sharedInstance().alertViewOpen("Please Check Internet Connection", viewController: viewController)
        }
            
            
                        
        
    }
    
    
    
    
    
    
    
    
    
    
    

}
