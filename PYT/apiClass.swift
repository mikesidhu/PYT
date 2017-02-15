
//
//  apiClass.swift
//  PYT
//
//  Created by Niteesh on 07/07/16.
//  Copyright © 2016 appsMaven. All rights reserved.
//


//var appUrl = "http://35.164.60.90/" //Live
var appUrl = "http://www.pictureyourtravel.com/"  //Test
//var appUrl = "http://52.25.207.151/"// Live New server


import UIKit
import SwiftyJSON
import SystemConfiguration
import MBProgressHUD


///create a delegate for intract with server
protocol apiClassDelegate
{
    func serverResponseArrived(Response:AnyObject)
}






class apiClass: NSObject {

    
    ////Live Ulr
    
     let baseUrlfb = appUrl
    let baseUrlLogin = "\(appUrl)login"
     let baseUrladdImage = "\(appUrl)create_story"
    let searchStory = "\(appUrl)searchedplaces"
    let likeUnlike = "\(appUrl)like_Picture"
    let deletePytImage = "\(appUrl)deleteimage"
    
 
    
 
 //test Url
 /*
 let baseUrlfb = "http://35.163.56.71/"
 let baseUrlLogin = "http://35.163.56.71/login"
 let baseUrladdImage = "http://35.163.56.71/create_story"
 let searchStory = "http://35.163.56.71/searchedplaces"
 let likeUnlike = "http://35.163.56.71/like_Picture"
 
 */
 
    
    
    
    
    var delegate:apiClassDelegate! = nil
    
    static var instance: apiClass!
    
    // SHARED INSTANCE
    class func sharedInstance() -> apiClass
    {
        self.instance = (self.instance ?? apiClass())
        return self.instance
    }
    
    
    
    
    
    
    
    
    /////////////////////////////////////////////////////////////////////////////////

    //MARK:- api for facebook check access token
    //MARK:-
    
    func getRequest(parameterString : String , viewController : UIViewController)
    {
        
        
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
          
           // indicatorClass.sharedInstance().showIndicator("Connecting To Facebook, Please wait...")
            
            let urlString = NSString(string:"\(baseUrlfb)\(parameterString)")
           
            
            //urlString = urlString .stringByReplacingOccurrencesOfString(" ", withString: "%20")
            
            
            let needsLove = urlString
            let safeURL = needsLove.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
            
            let url:NSURL = NSURL(string: safeURL as String)!
            print("Final Url-----> " + (safeURL as String))
            
            
            
            
            //let url:NSURL = NSURL(string: urlString as String)!
            let session = NSURLSession.sharedSession()
           // session.configuration.timeoutIntervalForRequest=20
           // session.configuration.timeoutIntervalForResource=40
            
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "GET"
            request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
            
            //NSOperationQueue.mainQueue().cancelAllOperations() //clear all the queues
            
            
            //let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {(response, data, error) in
                //print(NSString(data: data!, encoding: NSUTF8StringEncoding))
            //}
                
                
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
                          
                            
                           //  dispatch_async(dispatch_get_main_queue(), {
                            
                                do {
                                    
                                    
                                    //    let anyObj = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! [String:AnyObject]
                                    
                                    let result = NSString(data: data!, encoding:NSASCIIStringEncoding)!
                                             print("Body: \(result)")
                                    
                                    let anyObj: AnyObject = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                                    
                                    
                                    
                                    
                                            self.delegate.serverResponseArrived(anyObj)
                                    
                                    
                                    
                                        } catch {
                                                print("json error: \(error)")
                                            CommonFunctionsClass.sharedInstance().alertViewOpen("Sorry there is some issue in backend, Please try again", viewController: viewController)
                                                indicatorClass.sharedInstance().hideIndicator()
                                            MBProgressHUD.hideAllHUDsForView(viewController.view, animated: true)
                                        }
                                
                                
                            
                           
                          //  })
                            
                            
                     
                            
                        }
                        
                         //indicatorClass.sharedInstance().hideIndicator()
                }
                
            }//)
                
            //task.resume()
       
           
        }
        else
        {
            print(viewController)
            
            CommonFunctionsClass.sharedInstance().alertViewOpen("Please Check Internet Connection", viewController: viewController)
            indicatorClass.sharedInstance().hideIndicator()
            MBProgressHUD.hideAllHUDsForView(viewController.view, animated: true)
        }
 
 
 
 
        
        
        /*
         
         //            ///latest
         //            let request = NSMutableURLRequest(URL: url)
         //            request.HTTPMethod = "GET"
         //            request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
         //
         //            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {response,data,error in
         //
         //                if data == nil
         //                {
         //                    CommonFunctionsClass.sharedInstance().alertViewOpen("Server is not responding", viewController: viewController)
         //                    MBProgressHUD.hideAllHUDsForView(viewController.view, animated: true)
         //                    indicatorClass.sharedInstance().hideIndicator()
         //                }
         //                else
         //                {
         //
         //
         //                    //  dispatch_async(dispatch_get_main_queue(), {
         //
         //                    do {
         //
         //
         //
         //
         //                        let anyObj: AnyObject = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
         //
         //
         //
         //
         //                        self.delegate.serverResponseArrived(anyObj)
         //
         //
         //
         //                    } catch {
         //                        print("json error: \(error)")
         //                        CommonFunctionsClass.sharedInstance().alertViewOpen("Sorry there is some issue in backend, Please try again", viewController: viewController)
         //                        indicatorClass.sharedInstance().hideIndicator()
         //                        MBProgressHUD.hideAllHUDsForView(viewController.view, animated: true)
         //                    }
         //
         //
         //
         //
         //                    //  })
         //
         //
         //
         //
         //
         //
         //                //indicatorClass.sharedInstance().hideIndicator()
         //            }
         //
         //                //if error != nil {
         ////                    let alert = UIAlertView(title:"Oops!",message:error.localizedDescription, delegate:nil, cancelButtonTitle:"OK")
         ////                    alert.show()
         //               // }
         ////                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
         //            }
         //        
         //        
         //        
         //        
         //        }
         //        else
         //        {
         //            CommonFunctionsClass.sharedInstance().alertViewOpen("Please Check Internet Connection", viewController: viewController)
         //            indicatorClass.sharedInstance().hideIndicator()
         //            MBProgressHUD.hideHUDForView(viewController.view, animated: true)
         //    
         //        }
         //    
         //    
         //    
         //    
         //    
         
 
 
 
 */
        
        
        
        
        
        
    }
    
    
    
    
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /*
    func postRequest(parameterString : String , viewController : UIViewController)
    {
        
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
           // CommonFunctionsClass.sharedInstance().startIndicator(viewController.view)
            indicatorClass.sharedInstance().showIndicator("Connecting To Facebook, Please wait...")
            
            
            var urlString = NSString(string:"\(baseUrlfb)\(parameterString)")
            print("WS URL----->>" + (urlString as String))
            
            urlString = urlString .stringByReplacingOccurrencesOfString(" ", withString: "%20")
            
            let url:NSURL = NSURL(string: urlString as String)!
            let session = NSURLSession.sharedSession()
            
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "GET"
            request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
            let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
                
                NSOperationQueue.mainQueue().addOperationWithBlock
                    {
                     //   CommonFunctionsClass.sharedInstance().stopIndicator(viewController.view)
                        
                        indicatorClass.sharedInstance().hideIndicator()
                        
                        if data == nil
                        {
                            CommonFunctionsClass.sharedInstance().alertViewOpen("Server is not responding", viewController: viewController)
                        }
                        else
                        {
                            
                            let result = NSString(data: data!, encoding:NSASCIIStringEncoding)!
                            print("Body: \(result)")
                            
                            let jsonResult: AnyObject = try! NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.MutableContainers)
                            
                            print(jsonResult)
                            self.delegate.serverResponseArrived(jsonResult)
                            
                            
                           
                            
                          
                            CommonFunctionsClass.sharedInstance().alertViewOpen("Thanks for login with PYT, we are collecting the profile info and we will back within 2 months with new updates!", viewController: viewController)
                           
                            
                        }
                }
                
            })
            
            task.resume()
        }
        else
        {
            CommonFunctionsClass.sharedInstance().alertViewOpen("Please Check Internet Connection", viewController: viewController)
        }
        
    }
    
    */
    
    
    
    
    
    
    
    
    
    /////////////////////////////////////////////////////////////////////////////////

    
    //MARK:- api for Signup in the app
    //MARK
    
    func postRequestSearch(parameterString : String , viewController : UIViewController)
    {
        
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
            let request = NSMutableURLRequest(URL: NSURL(string: "\(appUrl)signup/")!)//live url
            
           // let request = NSMutableURLRequest(URL: NSURL(string: "http://35.163.56.71/signup/")!) //test url
            request.HTTPMethod = "POST"
            let postString = parameterString
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
                
                                self.delegate.serverResponseArrived(anyObj)
                
                
                
                            } catch {
                                print("json error: \(error)")
                                CommonFunctionsClass.sharedInstance().alertViewOpen("Sorry there is some issue in backend, Please try again", viewController: viewController)
                                indicatorClass.sharedInstance().hideIndicator()
                                MBProgressHUD.hideAllHUDsForView(viewController.view, animated: true)
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
    
    
    
    
    
    
    
    /////////////////////////////////////////////////////////////////////////////////
    
    //MARK:- Post request for login into screen
    //MARK:-
    
    func postRequestForLogin(parameterString : String, viewController : UIViewController)
    {
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
            //CommonFunctionsClass.sharedInstance().startIndicator(viewController.view)
            
            var urlString = NSString(string:"\(baseUrlLogin)")
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
                            CommonFunctionsClass.sharedInstance().alertViewOpen("Server is not responding", viewController: viewController)
                            MBProgressHUD.hideAllHUDsForView(viewController.view, animated: true)
                        }
                        else
                        {
//                            let result = NSString(data: data!, encoding:NSASCIIStringEncoding)!
//                            print("Body: \(result)")
//                            
//                            let jsonResult: AnyObject = try! NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.MutableContainers)
//                            
//                            self.delegate.serverResponseArrived(jsonResult)

                            
                            
                            do {
                                
                                let result = NSString(data: data!, encoding:NSASCIIStringEncoding)!
                                print("Body: \(result)")
                                
                                let anyObj: AnyObject = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                                
                                self.delegate.serverResponseArrived(anyObj)
                                
                                
                                
                            } catch {
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
        }
        
    }
    
    
    
    
    
    
    
    
    
    /////////////////////////////////////////////////////////////////////////////////

    //MARK:- Post request for get the categories from the database
    //MARK:-
    
    func postRequestCategories(parameterString : String , viewController : UIViewController)
    {
        
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
            let request = NSMutableURLRequest(URL: NSURL(string: "\(appUrl)category_list")!) //Live url
            
            //let request = NSMutableURLRequest(URL: NSURL(string: "http://35.163.56.71/category_list")!) //Test Url
            
        
            request.HTTPMethod = "POST"
            let postString = parameterString
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
                        
                       // self.delegate.serverResponseArrived(anyObj)
                        
                       let tagsArr = anyObj as! NSMutableArray
                        let defaults = NSUserDefaults.standardUserDefaults()
                        defaults .setValue(tagsArr, forKey: "categoriesFromWeb")//
                        
                        
                        
                        
                    } catch {
                        print("json error: \(error)")
                        CommonFunctionsClass.sharedInstance().alertViewOpen("Sorry there is some issue in backend, Please try again", viewController: viewController)
                        indicatorClass.sharedInstance().hideIndicator()
                        
                      //  self .postRequestCategories("", viewController: viewController) //recall
                        
                    }
                    
                    
                    MBProgressHUD.hideAllHUDsForView(viewController.view, animated: true)
                    
                })
                
                
                
                
                
                
                
            }
            task.resume()
            
        }
        else
        {
            CommonFunctionsClass.sharedInstance().alertViewOpen("Please Check Internet Connection", viewController: viewController)
        }
    }
    
    
    
    
    
    
    
    
    
    
    /////////////////////////////////////////////////////////////////////////////////
    
    //MARK:- Post api for add image in story from detail screen
    //MARK:-
    
    func postRequestWithMultipleImage(parameterString : String , parameters: NSDictionary , viewController : UIViewController)
    {
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
           // CommonFunctionsClass.sharedInstance().startIndicator(viewController.view)
            
            var urlString = NSString(string:"\(baseUrladdImage)")
            print("WS URL----->>" + (urlString as String))
            
            urlString = urlString .stringByReplacingOccurrencesOfString(" ", withString: "%20")
            
            let url:NSURL = NSURL(string: urlString as String)!
            let session = NSURLSession.sharedSession()
            

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
                            MBProgressHUD.hideAllHUDsForView(viewController.view, animated: true)
                        }
                        else
                        {
                            
                            
                            do {
                                
                                let result = NSString(data: data!, encoding:NSASCIIStringEncoding)!
                                print("Body: \(result)")
                                
                                let anyObj: AnyObject = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                                
                                
                               dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {                                    let defaults = NSUserDefaults.standardUserDefaults()
                                    let uId = defaults .stringForKey("userLoginId")
                                    let objt = storyCountClass()
                                    objt.postRequestForcountStory("userId=\(uId!)")
                                })
                                
                                
                                
                              //  self.delegate.serverResponseArrived(anyObj)
                                MBProgressHUD.hideAllHUDsForView(viewController.view, animated: true)
                                
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
    
    
    
    
   
    
    
    
    
    
    
    
    
    
    //////////////////////////////////////////////////////////////
    //MARK:- Post api to send the user selected locations
    //MARK:-
    
    func postRequestSearchedLocations(parameterString : String, totalLocations: NSDictionary , viewController : UIViewController)
    {
        
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
            print(parameterString)
            print(totalLocations)
            
            
            // CommonFunctionsClass.sharedInstance().startIndicator(viewController.view)
            
            var urlString = NSString(string:"\(searchStory)")
            print("WS URL----->>" + (urlString as String))
            
            urlString = urlString .stringByReplacingOccurrencesOfString(" ", withString: "%20")
            
            let url:NSURL = NSURL(string: urlString as String)!
            
            let session = NSURLSession.sharedSession()
            //session.configuration.timeoutIntervalForRequest=20
            //session.configuration.timeoutIntervalForResource=30
            
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
            //request.HTTPBody = parameterString.dataUsingEncoding(NSUTF8StringEncoding)
            
            
            
            do {
                let jsonData = try!  NSJSONSerialization.dataWithJSONObject(totalLocations, options: [])
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
                            MBProgressHUD.hideAllHUDsForView(viewController.view, animated: true)
                        }
                        else
                        {
                            
                            
                            do {
                                
                                let result = NSString(data: data!, encoding:NSASCIIStringEncoding)!
                                print("Body: \(result)")
                                
                                let anyObj: AnyObject = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                                
                              //  self.delegate.serverResponseArrived(anyObj)
                                NSNotificationCenter.defaultCenter().postNotificationName("load", object: nil)
                                
                                
                                
                            } catch
                            {
                                print("json error: \(error)")
                                CommonFunctionsClass.sharedInstance().alertViewOpen("Sorry there is some issue in backend, Please try again", viewController: viewController)
                                indicatorClass.sharedInstance().hideIndicator()
                                // MBProgressHUD.hideAllHUDsForView(viewController.view, animated: true)
                            }
                            
                            
                            
                            
                            
                            
                        }
                }
            })
            
            task.resume()
        }
        else
        {
            CommonFunctionsClass.sharedInstance().alertViewOpen("Please Check Internet Connection", viewController: viewController)
        }
        
    }

    
    
    
    
    
    
//    
//    ////////////////////////////////////////////////////////////////////////
//    //MARK:- Post api to get the trending locations
//    //MARK:-
//    
//    func postApiForTrendingLocations(viewController: UIViewController)
//    {
//        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
//        
//        if isConnectedInternet
//        {
//            let request = NSMutableURLRequest(URL: NSURL(string: "\(appUrl)trending")!)
//            request.HTTPMethod = "POST"
//            let postString = ""
//            request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
//            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
//                guard error == nil && data != nil else {                                                          // check for fundamental networking error
//                    print("error=\(error)")
//                    return
//                }
//                
//                if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
//                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
//                    
//                }
//                
//                
//                
//                dispatch_async(dispatch_get_main_queue(), {
//                    
//                    do {
//                        
//                        let result = NSString(data: data!, encoding:NSASCIIStringEncoding)!
//                        print("Body: \(result)")
//                        
//                        let anyObj: AnyObject = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
//                        
//                         self.delegate.serverResponseArrived(anyObj)
//                        
//                    } catch {
//                        print("json error: \(error)")
//                        CommonFunctionsClass.sharedInstance().alertViewOpen("Sorry there is some issue in backend, Please try again", viewController: viewController)
//                        
//                        
//                      
//                        
//                    }
//                    
//                    
//                   
//                    
//                })
//                
//                
//                
//                
//                
//                
//                
//            }
//            task.resume()
//            
//        }
//        else
//        {
//            CommonFunctionsClass.sharedInstance().alertViewOpen("Please Check Internet Connection", viewController: viewController)
//        }
//        
//    }
//    
//    
//    
//    
//    
//    
    
    
    
   // MARK:- //////////////------- POST REQUEST TO LIKE UNLIKE-----///////
    //MARK:-
    
    func postRequestLikeUnlikeImage(parameters: NSDictionary , viewController : UIViewController)
    {
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
            // CommonFunctionsClass.sharedInstance().startIndicator(viewController.view)
            
            var urlString = NSString(string:"\(likeUnlike)")
            print("WS URL----->>" + (urlString as String))
            
            urlString = urlString .stringByReplacingOccurrencesOfString(" ", withString: "%20")
            
            let url:NSURL = NSURL(string: urlString as String)!
            let session = NSURLSession.sharedSession()
           
            
            session.configuration.timeoutIntervalForRequest=20
           // session.configuration.timeoutIntervalForResource=30
            
            
            
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
                            MBProgressHUD.hideAllHUDsForView(viewController.view, animated: true)
                        }
                        else
                        {
                            
                            
                            do {
                                
                                let result = NSString(data: data!, encoding:NSASCIIStringEncoding)!
                                print("Body: \(result)")
                                
                                let anyObj: AnyObject = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                                
                                //  self.delegate.serverResponseArrived(anyObj)
                               // MBProgressHUD.hideAllHUDsForView(viewController.view, animated: true)
                                
                            } catch
                            {
                                print("json error: \(error)")
                                CommonFunctionsClass.sharedInstance().alertViewOpen("Sorry there is some issue in backend, Please try again", viewController: viewController)
                               // indicatorClass.sharedInstance().hideIndicator()
                                //MBProgressHUD.hideAllHUDsForView(viewController.view, animated: true)
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

    
   
    
    
    
    
    
  
    
    //MARK: Post api to delete uploaded images from the pyt app
    //MARK:-
    
    func postRequestDeleteImagePyt(parameters: NSString , viewController : UIViewController)
    {
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
            // CommonFunctionsClass.sharedInstance().startIndicator(viewController.view)
            
            var urlString = NSString(string:"\(deletePytImage)")
            print("WS URL----->>" + (urlString as String))
            
            urlString = urlString .stringByReplacingOccurrencesOfString(" ", withString: "%20")
            
            let url:NSURL = NSURL(string: urlString as String)!
            let session = NSURLSession.sharedSession()
            
            
            //session.configuration.timeoutIntervalForRequest=20
            // session.configuration.timeoutIntervalForResource=30
            
            
            
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            
            request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
            let postString = parameters
            request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
            
            
            let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
                
                NSOperationQueue.mainQueue().addOperationWithBlock
                    {
                        
                        MBProgressHUD.hideAllHUDsForView(viewController.view, animated: true)
                        
                        if data == nil
                        {
                            CommonFunctionsClass.sharedInstance().alertViewOpen("Server is not responding", viewController: viewController)
                            //MBProgressHUD.hideAllHUDsForView(viewController.view, animated: true)
                        }
                        else
                        {
                            
                            
                            do {
                                
                                let result = NSString(data: data!, encoding:NSASCIIStringEncoding)!
                                print("Body: \(result)")
                                
                                let anyObj: AnyObject = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                                
                                
                                NSNotificationCenter.defaultCenter().postNotificationName("loadDelete", object: nil)
                               
                                
                            } catch
                            {
                                print("json error: \(error)")
                                CommonFunctionsClass.sharedInstance().alertViewOpen("Sorry there is some issue in backend, Please try again", viewController: viewController)
                                
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
    

    
    
    
    
    //MARK: Post api to delete uploaded images from the pyt app in interest screen
    //MARK:-
    
    func postRequestDeleteImagePytFromInterest(parameters: NSString , viewController : UIViewController)
    {
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
            // CommonFunctionsClass.sharedInstance().startIndicator(viewController.view)
            
            var urlString = NSString(string:"\(deletePytImage)")
            print("WS URL----->>" + (urlString as String))
            
            urlString = urlString .stringByReplacingOccurrencesOfString(" ", withString: "%20")
            
            let url:NSURL = NSURL(string: urlString as String)!
            let session = NSURLSession.sharedSession()
            
            
            //session.configuration.timeoutIntervalForRequest=20
            // session.configuration.timeoutIntervalForResource=30
            
            
            
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            
            request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
            let postString = parameters
            request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
            
            
            let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
                
                NSOperationQueue.mainQueue().addOperationWithBlock
                    {
                        
                        MBProgressHUD.hideAllHUDsForView(viewController.view, animated: true)
                        
                        if data == nil
                        {
                            CommonFunctionsClass.sharedInstance().alertViewOpen("Server is not responding", viewController: viewController)
                            //MBProgressHUD.hideAllHUDsForView(viewController.view, animated: true)
                        }
                        else
                        {
                            
                            
                            do {
                                
                                let result = NSString(data: data!, encoding:NSASCIIStringEncoding)!
                                print("Body: \(result)")
                                
                                let anyObj: AnyObject = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                                
                                
                                NSNotificationCenter.defaultCenter().postNotificationName("loadDeleteInterest", object: nil)
                                
                                
                            } catch
                            {
                                print("json error: \(error)")
                                CommonFunctionsClass.sharedInstance().alertViewOpen("Sorry there is some issue in backend, Please try again", viewController: viewController)
                                
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
    
    
    
    
    
    
    
    
    
    
    //MARK: Post api to delete uploaded images from the pyt app in Detail screen
    //MARK:-
    
    func postRequestDeleteImagePytFromDetail(parameters: NSString , viewController : UIViewController)
    {
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
            // CommonFunctionsClass.sharedInstance().startIndicator(viewController.view)
            
            var urlString = NSString(string:"\(deletePytImage)")
            print("WS URL----->>" + (urlString as String))
            
            urlString = urlString .stringByReplacingOccurrencesOfString(" ", withString: "%20")
            
            let url:NSURL = NSURL(string: urlString as String)!
            let session = NSURLSession.sharedSession()
            
            
            //session.configuration.timeoutIntervalForRequest=20
            // session.configuration.timeoutIntervalForResource=30
            
            
            
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            
            request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
            let postString = parameters
            request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
            
            
            let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
                
                NSOperationQueue.mainQueue().addOperationWithBlock
                    {
                        
                        MBProgressHUD.hideAllHUDsForView(viewController.view, animated: true)
                        
                        if data == nil
                        {
                            CommonFunctionsClass.sharedInstance().alertViewOpen("Server is not responding", viewController: viewController)
                            //MBProgressHUD.hideAllHUDsForView(viewController.view, animated: true)
                        }
                        else
                        {
                            
                            
                            do {
                                
                                let result = NSString(data: data!, encoding:NSASCIIStringEncoding)!
                                print("Body: \(result)")
                                
                                let anyObj: AnyObject = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                                
                                
                                NSNotificationCenter.defaultCenter().postNotificationName("loadDeleteDetail", object: nil)
                                
                                
                            } catch
                            {
                                print("json error: \(error)")
                                CommonFunctionsClass.sharedInstance().alertViewOpen("Sorry there is some issue in backend, Please try again", viewController: viewController)
                                
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
    

    
    
    
    
    
    
    
      
    
    //TRY CATCH BLOCK
    
    
    //                            do {
    //
    //
    //                                let anyObj = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! [String:AnyObject]
    //                                 self.delegate.serverResponseArrived(anyObj)
    //
    //
    //
    //                            } catch {
    //                                print("json error: \(error)")
    //                                CommonFunctionsClass.sharedInstance().alertViewOpen("Sorry there is some issue in backend, Please try again", viewController: viewController)
    //
    //                            }
    

    
    
    
    
}
