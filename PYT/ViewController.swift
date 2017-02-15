//
//  ViewController.swift
//  PYT
//
//  Created by Niteesh on 04/07/16.
//  Copyright © 2016 appsMaven. All rights reserved.
//

import UIKit
//import Lock
 import Crashlytics
import MBProgressHUD


class ViewController: UIViewController, UIWebViewDelegate, apiClassDelegate {

    
   // @IBOutlet var animationView: JBKenBurnsView!
    
  
    
    var accessToken = ""
    var myActivityIndicator: UIActivityIndicatorView!
    var frontVC = UIViewController()
    // var randomNumber=Int()
    
    
    var string = NSString() // will used to separate the login type either facebook or instagram
    
    
    /////Instagram crediantials///
    
    let KAUTHURL = "https://api.instagram.com/oauth/authorize/"
    let kAPIURl = "https://api.instagram.com/v1/users/"
    let KCLIENTID = "a8565a67537e480ea2982f51ef8ee44f"
    let KCLIENTSERCRET = "b73b046cac894fdc8ecf321d0de001d1"
    let kREDIRECTURI = "http://www.appsmaventech.com"
    var fullURL = NSString()
    
     var tabledata = NSUserDefaults.standardUserDefaults().arrayForKey("arrayOfIntrest")
    
    var instagramWebView = UIWebView()
    
  
   
    
    @IBOutlet var signUpButton: UIButton!
    
    
    
    
    @IBOutlet var facebookLoginBtn: UIButton!
   
    
    
    
    
    
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
        
        tabledata = NSUserDefaults.standardUserDefaults().arrayForKey("arrayOfIntrest")
        
        
        
        //////////-------  Add Gradient color to background  --------///////////
        
//        let layer = CAGradientLayer()
//        layer.frame = CGRect(x: 0, y: 0, width: animationView.frame.size.width, height: self.animationView.frame.size.height)
//        let blueColor = UIColor(red: 0/255, green: 146/255, blue: 198/255, alpha: 1.0).CGColor as CGColorRef
//        let purpleColor = UIColor(red: 117/255, green: 42/255, blue: 211/255, alpha: 1.0).CGColor as CGColorRef
//        layer.colors = [purpleColor, blueColor]
//        layer.startPoint = CGPoint(x: 0.0, y: 0.4)
//        layer.endPoint = CGPoint(x: 0.0, y: 0.8)
//        layer.locations = [0.30,1.0]
//        self.animationView.layer.addSublayer(layer)
        
        /////////------ End of gradient color -------/////////
        
        
        apiClass.sharedInstance().delegate=self //delegate of api class
        
        
       // self.view .setNeedsLayout()
       // self.view.layoutIfNeeded() //update needed constaraints

//        signUpButton.layer.cornerRadius=(signUpButton!.frame.size.height)/2
//        signUpButton.layer.borderColor=UIColor (colorLiteralRed: 157.0/255.0, green: 194.0/255.0, blue: 134.0/255.0, alpha: 1).CGColor
//        signUpButton.layer.borderWidth=1.3
//        signUpButton.clipsToBounds=true
        
        
         NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.moveInside(_:)),name:"MoveInside", object: nil)
        
    }
    
    

    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
        
    }
    
    
    
    //MARK:- Main Method
    //MARK:-
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
             
        
       // randomNumber=Int(arc4random_uniform(5)+1)//random number to change the background image on every startup
       
       
       
        //check the access tokens for auto login into the app
        let defaults = NSUserDefaults.standardUserDefaults()
        if let name = defaults.stringForKey("userLoginId") // check fb access token
        {
            print(name)
            
            if name == ""  //if fbaccesstoken is empty check instagram token
            {
                if let name2 = defaults.stringForKey("instagramAccessToken"){
                     self.accessToken = name2
                    string = "instagram"
                }
            }
                
            else
            {
            string = "facebook"
            self.accessToken = name
        }
        }
        
       
        
       // self .checkAccess() //call api on the basis of pre saved access tokens
        
        
//        facebookLoginBtn.layer.cornerRadius=facebookLoginBtn.frame.size.height/2
//        facebookLoginBtn.clipsToBounds=true

        
        
        
        
        
    }

    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    
    //MARK-: Check the access token 
    /*
 //check that access token is saved and then hit the api to validate the access token and login to pyt
 
    
    ///////------- check saved access token--------///////
    
    
    func checkAccess() -> Void
    {
        
        if (self.accessToken == "")
        {
            indicatorClass.sharedInstance().hideIndicator()
        }
        else
        {
            
            if tabledata?.count<1 {
                
                
                
                //                // hit the another api to get data in backend team
                //                let parameterString = NSString(string:"check_fb/\(self.accessToken)") as String
                //             //   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), {() -> Void in
                //
                //                    self .checkFb2(parameterString)
                //               // })
                //
                
                
                // if not select any intrest show intrest screen
                let nxtObj = self.storyboard?.instantiateViewControllerWithIdentifier("firstMainScreenViewController") as! firstMainScreenViewController
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), {() -> Void in
                    
                    self.navigationController! .pushViewController(nxtObj, animated: true)
                })
                
                
                
            }
            else
            {
               // self.performSegueWithIdentifier("MainHomeScreen", sender: self) //if selected intrests then go to home screen
                
            }
            
            
            
            
            
            
            
            
            
//            let alertText = NSString .localizedStringWithFormat("Connecting To %@, Please wait...", string)
//            indicatorClass.sharedInstance().showIndicator(alertText as String)
//            
//            let parameterString = NSString(string:"check_fb/\(self.accessToken)") as String
//            apiClass.sharedInstance().getRequest(parameterString, viewController: self)
            
        }
        
    }
    
 */
   
    
    
    
    
    
    
    
    
    
    
    ////////////////////////////////////////////////////////////////////////////////
    
    //MARK:- facebook Action to get the detail and accessToken
    //MARK:-
    
    
    /*
     function for get the access token from the facebook and get into the app
     also will be able to hit the graph api
     */
    
    @IBAction func facebookAction(sender: AnyObject)
    {
       
        
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.label.text = "Logging in"
        
        
        
        apiClass.sharedInstance().postRequestCategories("", viewController: self)//hit the api to get the categories from the web
        
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        
        //-- set permissions to facebook----/////
        fbLoginManager.logInWithReadPermissions(["email","user_photos"," user_about_me", "public_profile", "user_location", "user_birthday"], fromViewController: self) { (result, error) -> Void in
        
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result
                    if(fbloginresult.isCancelled) {
                   
                        CommonFunctionsClass.sharedInstance().alertViewOpen("You have cancelled the action", viewController: self)
                        MBProgressHUD.hideHUDForView(self.view, animated: true)
                    }
                        
                else if(fbloginresult.grantedPermissions.contains("email"))
                    {
                    let token =   FBSDKAccessToken.currentAccessToken().tokenString // access token
                    let token2 = FBSDKAccessToken.currentAccessToken().userID
                    print(token2)
                    print(token)
                    
                    self.accessToken = token // set access token to global for use
                    print(self.accessToken)
                    
                    let defaults = NSUserDefaults.standardUserDefaults()
                    defaults.setObject(self.accessToken, forKey: "faceBookAccessToken")
                    defaults.setObject("", forKey: "instagramAccessToken")
                    
                    self.getFBUserData(token2, token: token) // call  api for testing
                        
                        
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), {() -> Void in
                            
                            //self.graphApi()
                              fbLoginManager.logOut() // logout the facebook
                             MBProgressHUD.hideHUDForView(self.view, animated: true)
                        })
                        
                }
            }
            
            else
            {
                print(error)
                MBProgressHUD.hideHUDForView(self.view, animated: true)
            }
        }
       
    }
    
    
    
////////////--------- function to get the user data from facebook /or graph api  call the api -------------//////
    /// hit the api to backend for save the access token and get user data from facebook
    func getFBUserData(id:NSString,token:NSString)
    {
        
        //device token
        let defaults = NSUserDefaults.standardUserDefaults()
        let tokendevice = defaults.stringForKey("deviceToken")!
        print(tokendevice)
        
        if((FBSDKAccessToken.currentAccessToken()) != nil)
        {

            indicatorClass.sharedInstance().showIndicator("Connecting To Facebook, Please wait...")
            
            
                    if (self.accessToken == "")
                    {
                        CommonFunctionsClass.sharedInstance().alertViewOpen("You are not Logged in!", viewController: self)
                    }
                    else
                    {
                           // let parameterString = NSString(string:"check_fb/\(self.accessToken)") as String
                        
                        let parameterString = NSString(string:"user_login_facebook/\(id)/\(token)/\(tokendevice)") as String
                        
                      
                        
                        
                            apiClass.sharedInstance().getRequest(parameterString, viewController: self) // call api with parameters
                    }
            
            
        }
        
        
        
    }
    
    
    ///---- to get the details of user in front end---////
    func graphApi()
    {
       //email
        FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large)"]).startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if (error == nil){
                
                 print(result)
                print(result .valueForKey("picture")?.valueForKey("data")?.valueForKey("url"))
                
                let profilePic=result .valueForKey("picture")?.valueForKey("data")?.valueForKey("url") as! String
                let userName = result .valueForKey("name") as? String ?? ""
                
                
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setObject(profilePic, forKey: "userProfilePic")
                defaults.setObject(userName, forKey: "userName")
                
                
            
            }
            else
            {
                
                print(error)
                
            }
            
            
            
        })
        
        
            
            
    }
    
    /////////////////////------------- Facebook login ends Here------------////////////////////
    
    
    
    

    
    
    
    
    
    
    
    ////////////////////////////////////////////////////////////////////////////////

    //MARK:- get data from instagram Login of user
    //MARK:-
    
    
    @IBAction func instaGramActionBtn(sender: AnyObject) {
  
      
        
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.label.text = "Logging in"
        
        
         fullURL = NSString .localizedStringWithFormat("%@?client_id=%@&redirect_uri=%@&response_type=token", KAUTHURL, KCLIENTID, kREDIRECTURI)
        print(fullURL)
        
      instagramWebView = UIWebView(frame: CGRectMake(0, 20, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height))
        instagramWebView.loadRequest(NSURLRequest(URL: NSURL(string: fullURL as String)!))
        
        instagramWebView.delegate=self
        self.view.addSubview(instagramWebView) //open webview
       
        let cancelBtn = UIButton()
       cancelBtn.frame=CGRectMake(8, 8, 36, 36)
        cancelBtn.setImage(UIImage (named: "close"), forState: .Normal)
        cancelBtn.layer.cornerRadius=cancelBtn.frame.size.width/2
        cancelBtn.clipsToBounds=true
        self.instagramWebView .addSubview(cancelBtn)
        cancelBtn.addTarget(self, action: #selector(ViewController.cancleInstagram(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        cancelBtn.backgroundColor=UIColor .blackColor()
        cancelBtn.titleLabel?.textColor=UIColor .whiteColor()
    
    }
    
   
    /////---- Manage the webView
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        var urlString: String = request.URL!.absoluteString
        
        print(urlString)
        var UrlParts = urlString .componentsSeparatedByString(NSString .localizedStringWithFormat("%@/", kREDIRECTURI) as String )

        
        print(UrlParts[0])
        print(UrlParts)
         MBProgressHUD.hideHUDForView(self.view, animated: true)
        if UrlParts.count > 1 {
            
            urlString = UrlParts[1] 
          
            let accessToken = NSRange()
            
            if accessToken.location != NSNotFound {
                let strAccessToken: String = urlString.substringFromIndex(urlString.startIndex.advancedBy(NSMaxRange(accessToken)))
                // Save access token to user defaults for later use.
               
                // Add constant key #define KACCESS_TOKEN @”access_token” in constant class
              
                print(strAccessToken)
                
                var myStringArr = strAccessToken.componentsSeparatedByString("=")
                let accessInsta: String = myStringArr [1]
                print(accessInsta)
                
                //////- separate access token and userId
                
                
                var instaUserId = NSString()
               
                
                
                let totalAraay = accessInsta.componentsSeparatedByString(".")
                if totalAraay.count>1 {
                    //print("UserId=\(totalAraay[0])")
                    instaUserId=totalAraay[0] as? String ?? ""
                }
                    print(accessInsta)
                
                instagramWebView .removeFromSuperview()
                indicatorClass.sharedInstance().showIndicator("Connecting To Instagram, Please wait...")
                
                let parameterString = NSString(string:"user_login_instagram/\(instaUserId)/\(accessInsta)") as String
                
                
                
                
                apiClass.sharedInstance().getRequest(parameterString, viewController: self) // call api with parameters

                
                
                
            }
            return false
        }
        return true
    }
    
    
    func cancleInstagram(sender:UIButton) -> Void {
        
            self.instagramWebView .removeFromSuperview()
            CommonFunctionsClass.sharedInstance().alertViewOpen("You canceled the action!", viewController: self)
        
    }
    
    
    /////////////////--------- Instagram handel end --------///////////////
    
    
    
    
    
    
    
    
    ////////////////////////////////////////////////////////////////////////////////
    
    
    //MARK:- Server Communication Delagte
    //MARK:-
  /*
 it will get the result of the api from server
     if access token is valid then go to next screen else show alert for login again
     
 */
    
    func serverResponseArrived(Response:AnyObject){
        
        ///// if not login from facebook or instagram
        

        
            
            
            ////////if login from facebook or instagram
       
            
            jsonResult = NSDictionary()
            jsonResult = Response as! NSDictionary
            let success = jsonResult.objectForKey("status") as! NSNumber
            
            if success == 1
            {
                print(jsonResult)
                
                let pytUserId = jsonResult.valueForKey("userId") as? String ?? ""
                print(pytUserId)
                
                print(jsonResult.valueForKey("profilePic"))
                print(jsonResult.valueForKey("name"))
                let pytUserName = jsonResult.valueForKey("name") as? String ?? ""
                let pytUserProfilePic = jsonResult.valueForKey("profilePic") as? String ?? ""
                
                
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setObject(pytUserId, forKey: "userLoginId")
                defaults.setObject(pytUserName, forKey: "userLoginName")
                defaults.setObject(pytUserProfilePic, forKey: "userProfilePic")
                
                
                            
                
                
                let runtimeLocations = jsonResult.valueForKey("runtimeLocation") as! NSMutableArray
                
                if runtimeLocations.count > 0 {
                    
                    let arrayOfLoc = NSMutableArray()
                    for l in 0..<runtimeLocations.count {
                        
                        let arrRunTime = runtimeLocations.objectAtIndex(l) as? String ?? ""
                        
                        let arrayComb = arrRunTime.componentsSeparatedByString("-PYT-")
                        
                        var loc = ""
                        var type = ""
                        
                        if arrayComb.count>1 {
                            loc = "\(arrayComb[0])"
                            type = "\(arrayComb[1])"
                        }
                        else{
                            loc = "\(arrayComb[0])"
                            type = "Country"
                        }
                        
                        
                        
                        
                        
                        
                        var dic = NSMutableDictionary()
                        dic = ["location":loc,"lat": "0.0", "long": "0.0", "type": type, "country": runtimeLocations.objectAtIndex(l), "delete":false]
                        print(dic)
                        arrayOfLoc .addObject(dic)
                        
                    }
                    
                    NSUserDefaults.standardUserDefaults().setObject(arrayOfLoc, forKey: "arrayOfIntrest")
                    tabledata = NSUserDefaults.standardUserDefaults().arrayForKey("arrayOfIntrest")
                    
                }

                
                
                
                dispatch_async(dispatch_get_main_queue(),
                               {
                                
                                self .moveinsideApp()
                })
                
              
               
                
               
                
                
            }
                
            else
            {
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setObject("", forKey: "userLoginId")
               
                
                CommonFunctionsClass.sharedInstance().alertViewOpen("Your session is expired, Please login again", viewController: self)
                indicatorClass.sharedInstance().hideIndicator()
                
            }

        
        
    }
    
    
    
    
    func moveInside(notification: NSNotification) {
        
         tabledata = NSUserDefaults.standardUserDefaults().arrayForKey("arrayOfIntrest")
        
       // self .moveinsideApp()
        
     
        
        
    }
    
    
    
    
    
    /*
 
   //  not using right now
     
 
    //MARK:- hit api to get the data from the facebook for backend team
    //MARK:-
    
    func checkFb2(token : NSString) -> Void {
        
        let baseUrlfb = "\(appUrl)"
            
            let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
            
            if isConnectedInternet
            {
                
                var urlString = NSString(string:"\(baseUrlfb)\(token)")
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
                          
                            if data == nil
                            {
                                print("not getting data from server")
                               // CommonFunctionsClass.sharedInstance().alertViewOpen("Server is not responding", viewController: self)
                            }
                            else
                            {
                                
                                let result = NSString(data: data!, encoding:NSASCIIStringEncoding)!
                                
                                print("Body: \(result)")
                                
                                let jsonResult: AnyObject = try! NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.MutableContainers)
                                print(jsonResult)
                                
                            }
                    }
                    
                })
                
                task.resume()
            }
            else
            {
               // CommonFunctionsClass.sharedInstance().alertViewOpen("Please Check Internet Connection", viewController: self)
            }
        
        
    }
    
    */
    
    
    

    
    
    ///////////////////////////////////////////////////////////////////////////////////
    
    //MARK:- Login to app SIGNIN
    //MARK:-
    
    
    @IBAction func SignInButtonAction(sender: AnyObject) {
    
        // if not select any location show search screen
        let nxtObj = self.storyboard?.instantiateViewControllerWithIdentifier("loginViewController") as! loginViewController
        
        
        
        self.navigationController! .pushViewController(nxtObj, animated: true)
         apiClass.sharedInstance().postRequestCategories("", viewController: self)//hit the api to get the categories from the web
    
    }
    
    
    
    
    
    
    
    
    
    /////////////////////////////////////////////////////////////
    
    //MARK:- Function to move to next Screen After Login from facebook/ instagram/ signin/ or go througn app
    //MARK:-
    
    func moveinsideApp() -> Void {
        
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let uId = defaults .stringForKey("userLoginId")
        
        
        
        
       

        
        
        
        
        if tabledata?.count<1 {
            
            
            // if not select any location show search screen
            let nxtObj = self.storyboard?.instantiateViewControllerWithIdentifier("firstMainScreenViewController") as! firstMainScreenViewController
            
           dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {
            
            
                            let objt = storyCountClass()
                            objt.postRequestForcountStory("userId=\(uId!)")
            
            ///For get the user's all data
            
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {
                let objt2 = UserProfileDetailClass()
                objt2.postRequestForGetTheUserProfileData("userId=\(uId!)")
                
                
            })
          
            
            
            })

            indicatorClass.sharedInstance().hideIndicator()
            self.navigationController! .pushViewController(nxtObj, animated: true)
            
    
            
            
        }
        else
        {
            
             dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {
                
                
                            let objt = storyCountClass()
                            objt.postRequestForcountStory("userId=\(uId!)")//PYT1979030")
                            
                
                
                ///For get the user's all data
                
                dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {
                    let objt2 = UserProfileDetailClass()
                    objt2.postRequestForGetTheUserProfileData("userId=\(uId)")
                    
                    
                    dispatch_async(dispatch_get_main_queue(),
                        {
                        indicatorClass.sharedInstance().hideIndicator()
                        self.performSegueWithIdentifier("MainHomeView", sender: self) //if already selected locations then go to home screen
                    })
                    
                })
                
                
                            
//                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), {() -> Void in
//                                
//                                  indicatorClass.sharedInstance().hideIndicator()
//                                 self.performSegueWithIdentifier("MainHomeView", sender: self) //if already selected locations then go to home screen
                           // })
                           
                        
                            
            })

            
            
            
            
        }
        
        
        
        
        
        
        
        
        
    }
    
    
    
    
    
    

}





