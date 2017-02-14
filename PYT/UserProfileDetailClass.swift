//
//  UserProfileDetailClass.swift
//  PYT
//
//  Created by Niteesh on 22/12/16.
//  Copyright © 2016 appsMaven. All rights reserved.
//

import UIKit
import SwiftyJSON
import SystemConfiguration




class UserProfileDetailClass: NSObject {

    
    
    ////////MARK:-- post for get the all detail of the user
    
    func postRequestForGetTheUserProfileData(parameterString : String)
    {
        
        
        
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
            //CommonFunctionsClass.sharedInstance().startIndicator(viewController.view)
            
            var urlString = NSString(string:"\(appUrl)userprofile") //Live Url
            
            
           // var urlString = NSString(string:"http://35.163.56.71/userprofile") //Test Url
            
            
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
                                print("Body:   ENTERS HERE for user profile result-->  \(result)")
                                
                                let anyObj: AnyObject = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                                
                             jsonResult = NSDictionary()
                              jsonResult = anyObj as! NSDictionary
                                
                                let sucess = jsonResult.valueForKey("status") as! NSNumber
                                
                                if sucess == 1{
                                    
                                    print("Getting inside")
                                    
                                    let detailArr = jsonResult .objectForKey("user") as! NSMutableArray
                                    
                                    print(detailArr)
                                    if detailArr.count<1{
                                    
                                        print("Not signed up So no profile pic found ")
                                        
                                        
                                    }
                                    else
                                    {
                                        let profilePic = detailArr[0].valueForKey("profilePic") as? String ?? ""
                                        
                                        
                                        NSUserDefaults.standardUserDefaults().setObject(profilePic, forKey: "userProfilePic")
                                        
                                        
                                        
                                        
                                        
                                    }
                                    
                                   
                                    
                                    
                                    
                                    
                                   // let runtimeLocations = jsonResult.valueForKey("user")?.objectAtIndex(0).valueForKey("runtimeLocation") as! NSMutableArray
                                    
                                    //print(runtimeLocations.count)
                                   // print(runtimeLocations)
                                    
                                    
                                    
                                    //if runtimeLocations.count > 0 {
                                        
                                      //  let arrayOfLoc = NSMutableArray()
                                        //for l in 0..<runtimeLocations.count {
                                            
                                         //   var dic = NSMutableDictionary()
                                          //  dic = ["location":runtimeLocations.objectAtIndex(l),"lat": "0.0", "long": "0.0", "type": "country", "country": runtimeLocations.objectAtIndex(l), "delete":false]
                                          //  arrayOfLoc .addObject(dic)
                                            
                                      //  }
                                    
                                       // 
                                    
                                    
                                    
                                  //  }
                                    
                                    
                                }
                                
                                
                                
                                
                                 //NSNotificationCenter.defaultCenter().postNotificationName("MoveInside", object: nil)
                                
//                                
//                                if jsonArray.count>0{
//                                    countArray=jsonArray.objectAtIndex(0) as! NSMutableDictionary
//                                    NSNotificationCenter.defaultCenter().postNotificationName("loadCount", object: nil)
//                                    print(countArray.valueForKey("storyCount"))
//                                    print(countArray.valueForKey("storyImages"))
//                                }
                                
                                
                                
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
