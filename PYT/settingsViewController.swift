//
//  settingsViewController.swift
//  PYT
//
//  Created by Niteesh on 14/12/16.
//  Copyright © 2016 appsMaven. All rights reserved.
//

import UIKit
import MBProgressHUD
import SDWebImage


class settingsViewController:
    UIViewController, settingClassDelegate, UIWebViewDelegate {

    
    @IBOutlet var profilePic: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    
    @IBOutlet weak var instaBtn: UIButton!
    
    @IBOutlet weak var facebookBtn: UIButton!
    var boolProfile = Bool()
    
    
    
    
    var instagramWebView = UIWebView()
    let KAUTHURL = "https://api.instagram.com/oauth/authorize/"
    let kAPIURl = "https://api.instagram.com/v1/users/"
    let KCLIENTID = "a8565a67537e480ea2982f51ef8ee44f"
    let KCLIENTSERCRET = "b73b046cac894fdc8ecf321d0de001d1"
    let kREDIRECTURI = "http://www.appsmaventech.com"
    var fullURL = NSString()
    
    
    
    override func viewWillAppear(animated: Bool) {
        
         self.tabBarController?.tabBar.hidden = false
        SettingApiClass.sharedInstance().delegate=self //delegate of api class
    }
    
    
    
    
    ////Add this method in view did appear to get the messages
    
    override func viewDidAppear(animated: Bool) {
        //super.viewDidAppear(animated)
        
        SocketIOManager.sharedInstance.getChatMessageNotify { (messageInfo) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                let count: String = String(messageInfo["count"]!)
                
                self.tabBarController?.tabBar.items?[3].badgeValue = count
                
                
                
                
            })
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        userNameLabel.text=""
        let defaults = NSUserDefaults.standardUserDefaults()
        if let userName = defaults .stringForKey("userLoginName"){
            userNameLabel.text=userName
        }
        
        let userPic = defaults .stringForKey("userProfilePic")
        print(userPic)
        
        let urlProfile = NSURL(string: userPic! as? String ?? "")
        
        
         profilePic .sd_setImageWithURL(urlProfile, placeholderImage: UIImage (named: "backgroundImage"))
        
        
        
        profilePic.layer.cornerRadius = profilePic.frame.size.width/2
        profilePic.clipsToBounds = true
        
        
        facebookBtn.layer.cornerRadius=facebookBtn.frame.size.width/2
        facebookBtn.clipsToBounds=true
      
        instaBtn.layer.cornerRadius=instaBtn.frame.size.width/2
        instaBtn.clipsToBounds=true
        
        
        
        
        
       // let defaults = NSUserDefaults.standardUserDefaults()
        let uId = defaults .stringForKey("userLoginId")
        
        SettingApiClass.sharedInstance().getUSerProfile("userId=\(uId!)", viewController: self)
        boolProfile=true
        
        
        // Do any additional setup after loading the view.
    }

    
    //MARK: ACTIONS oF BUTTONS ARE HERE
    //MARK:-
    
    
    //MARK: EDIT USER PROFILE
    
    @IBAction func editProfileAction(sender: AnyObject) {
        
        
        let nxtObj = self.storyboard?.instantiateViewControllerWithIdentifier("EditProfileViewController") as! EditProfileViewController
        
        
        self.navigationController?.pushViewController(nxtObj, animated: true)
        
         self.tabBarController?.tabBar.hidden = true
        
    }
    
    
    
    
    //MARK: Choose Intrests View
    
    @IBAction func chooseInterest(sender: AnyObject) {
   
    
        let nxtObj = self.storyboard?.instantiateViewControllerWithIdentifier("chooseInterestsViewController") as! chooseInterestsViewController
        
        
        self.navigationController?.pushViewController(nxtObj, animated: true)
        
         self.tabBarController?.tabBar.hidden = true
        
        
        
        
    
    }
    
    
    
    
    //MARK:- Change Password
    
    
    @IBAction func changePasswordButtonAction(sender: AnyObject) {
   
        let nxtObj = self.storyboard?.instantiateViewControllerWithIdentifier("changePasswordViewController") as! changePasswordViewController
        
        
        self.navigationController?.pushViewController(nxtObj, animated: true)
        
        self.tabBarController?.tabBar.hidden = true
    
    
    }
    
    
    
    
    
    //MARK:- Report a Problem Button Action

    @IBAction func reportProblemAction(sender: AnyObject) {
   
        let nxtObj = self.storyboard?.instantiateViewControllerWithIdentifier("ReportProblemViewController") as! ReportProblemViewController
        
        
        self.navigationController?.pushViewController(nxtObj, animated: true)
        
        self.tabBarController?.tabBar.hidden = true
    
    
    }
    
    
    
    //MARK:- Privacy and term action
    
  
    @IBAction func privacyPolicyAction(sender: AnyObject) {
   
        let nxtObj = self.storyboard?.instantiateViewControllerWithIdentifier("PrivacyPolicyViewController") as! PrivacyPolicyViewController
        
        
        self.navigationController?.pushViewController(nxtObj, animated: true)
        
        self.tabBarController?.tabBar.hidden = true
    
    }
    
    
    
    //MARK:- Help button action
    
    @IBAction func helpAction(sender: AnyObject) {
    
        let nxtObj = self.storyboard?.instantiateViewControllerWithIdentifier("HelpViewController") as! HelpViewController
        
        
        self.navigationController?.pushViewController(nxtObj, animated: true)
        
        self.tabBarController?.tabBar.hidden = true
    
    }
    

    
    
    
    
    
    
    //MARK: Logout Button Action
    
    @IBAction func ActionLogout(sender: AnyObject) {
        
        self.tabBarController?.tabBar.hidden = true
        
        let nxtObj = self.storyboard?.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        
        dispatch_async(dispatch_get_main_queue(), {
             self.dismissViewControllerAnimated(true, completion: {})
            
            self.navigationController! .pushViewController(nxtObj, animated: true)
           
            
            
            NSOperationQueue.mainQueue().cancelAllOperations()
            
            
//            var currentTask = NSURLSessionTask()
//           // if currentTask.state==NSURLSessionTaskState.Running {
//                currentTask.cancel()
//            //}
//        
        })
        
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject("", forKey: "userLoginId")
        defaults.setObject("", forKey: "userLoginName")
        defaults.setObject("", forKey: "userProfilePic")
        
        
        
        
        
        let arr = NSMutableArray()
        NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "arrayOfIntrest")
      
        
        
        
    }
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        NSURLCache.sharedURLCache().removeAllCachedResponses()
        // Dispose of any resources that can be recreated.
    }

    
    
    
    
    
    

//    func getTasksWithCompletionHandler(completionHandler: @escaping ([URLSessionDataTask],
//        [URLSessionUploadTask],
//        [URLSessionDownloadTask]) -> Void) {
//        
//        
//        
//    }
    
   
    
    
    /*
     
     
     /connect_to_facebook/:userId/:accessToken
     
     connect_to_instagram/:userId/:accessToken API to connect to instagram; In working mode
     
     */
    
    
   
   //MARK:- BACK BUTTON ACTION
    
    
    @IBAction func backAction(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    
    //MARK:- FacebookConnect button action
    
    
    @IBAction func facebookConnectaction(sender: AnyObject) {
        
        
        
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.label.text = "Logging in"
        
        
        
        
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
                    //let id = FBSDKAccessToken.currentAccessToken().userID
                    
                    
                    
                    let defaults = NSUserDefaults.standardUserDefaults()
                    let uId = defaults .stringForKey("userLoginId")
                    
                    let parameterString = NSString(string:"connect_to_facebook/\(uId!)/\(token)") as String
                    
                    self.boolProfile=false
                    SettingApiClass.sharedInstance().Connectfacebook_Instagram(parameterString, viewController: self) // call api with parameters
                    
                   // apiClass.sharedInstance().Connectfacebook_Instagram(parameterString, viewController: self) // call api with parameters
                    
                    
                    
                    
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
    
    
    
    
    
    func serverResponseArrivedSetting(Response:AnyObject){
        
        ///// the user info will be comes here
        
        if boolProfile==true {
       
            indicatorClass.sharedInstance().hideIndicator()
            
            basicInfo = NSMutableDictionary()
            basicInfo = Response as! NSMutableDictionary
            let success = basicInfo.objectForKey("status") as! NSNumber
            
            if success==1 {
                //goto function for short and display in screen
                self.shortUserProfile(basicInfo)
                
            }else{
                
            }
            
            
            
            
        }
            
            
            
            
        ///if login from facebook and instagram it will comes here
        else
        {
            ////////if login from facebook or instagram
            
            
            indicatorClass.sharedInstance().hideIndicator()
            
            jsonResult = NSDictionary()
            jsonResult = Response as! NSDictionary
            let success = jsonResult.objectForKey("status") as! NSNumber
            
            if success == 1
            {
                print(jsonResult)
                
                CommonFunctionsClass.sharedInstance().alertViewOpen("\(jsonResult.valueForKey("msg")!)", viewController: self)
                
                
                
            }
                
            else
            {
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setObject("", forKey: "userLoginId")
                
                
                CommonFunctionsClass.sharedInstance().alertViewOpen("Your session is expired, Please login again", viewController: self)
                indicatorClass.sharedInstance().hideIndicator()
                
            }

        }
        
        
        
        
        
        
        
    }
    
    
    
    
    
    //MARK: Short the user profile data
    func shortUserProfile(result:NSMutableDictionary) {
        
        print(result.valueForKey("user")!.count)
        
        if result.valueForKey("user")!.count<1 {
          
            print("No User Found")
            
            
        }
        else
        {
        if ((result.valueForKey("user")?.objectAtIndex(0).objectForKey("_id")) != nil) {
            print(result.valueForKey("user")?.objectAtIndex(0).valueForKey("name"))
            
            print(result.valueForKey("user")?.objectAtIndex(0).valueForKey("profilePic"))
            print(result.valueForKey("user")?.objectAtIndex(0).valueForKey("email"))
            print(result.valueForKey("user")?.objectAtIndex(0).valueForKey("gender"))
            
            
            
            let userNameText = result.valueForKey("user")?.objectAtIndex(0).valueForKey("name") as? String ?? ""
            
            userNameLabel.text=userNameText
            
            let profileUrl = result.valueForKey("user")?.objectAtIndex(0).valueForKey("profilePic") as? String
              let imgurl = NSURL (string: profileUrl!)
            print(imgurl)
            profilePic .sd_setImageWithURL(imgurl, placeholderImage: UIImage (named: "backgroundImage"))
          
            
            let source = result.valueForKey("user")?.objectAtIndex(0).valueForKey("source") as? String
            
            
            //if loged in from Facebook or Instagram the icons shows filled and user intraction will disable
            
           if source == "PYT"{
                facebookBtn.setImage(UIImage (named: "fbSetting"), forState: UIControlState .Normal)
                instaBtn.setImage(UIImage (named: "instaSetting"), forState: UIControlState .Normal)
                
                instaBtn.userInteractionEnabled=true
                facebookBtn.userInteractionEnabled=true
            }
           
            
            let connection = result.valueForKey("user")?.objectAtIndex(0).valueForKey("connection") as! NSArray

            if connection.count > 0 {
                
                for i in 0..<connection.count {
                    
                    let connectedAccount = connection.objectAtIndex(i) as? String ?? ""
                    if connectedAccount == "facebook" {
                        
                        facebookBtn.setImage(UIImage (named: "fillFbSetting"), forState: UIControlState .Normal)
                        facebookBtn.userInteractionEnabled=false
                        
                    }
                    else
                    {
                        if source == "instagram" {
                            
                            instaBtn.setImage(UIImage (named: "fillInstaSetting"), forState: UIControlState .Normal)
                            instaBtn.userInteractionEnabled=false
                        }
                    }
                    
                    
                    
                }
                
                
            }
            else{
                facebookBtn.setImage(UIImage (named: "fbSetting"), forState: UIControlState .Normal)
                instaBtn.setImage(UIImage (named: "instaSetting"), forState: UIControlState .Normal)
                
                instaBtn.userInteractionEnabled=true
                facebookBtn.userInteractionEnabled=true
            }
            
         
        }
        
    }
    
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    //MARK:- Instagram Connect button action

    
    @IBAction func instagramConnectAction(sender: AnyObject) {
        
        self.tabBarController?.tabBar.hidden=true
        
        
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
        cancelBtn.frame=CGRectMake(8, 8, 38, 38)
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
                
                let defaults = NSUserDefaults.standardUserDefaults()
                let uId = defaults .stringForKey("userLoginId")
                
                let parameterString = NSString(string:"connect_to_instagram/\(uId!)/\(accessInsta)") as String
                
                
                
                 SettingApiClass.sharedInstance().Connectfacebook_Instagram(parameterString, viewController: self)
                self.tabBarController?.tabBar.hidden = false
                //apiClass.sharedInstance().Connectfacebook_Instagram(parameterString, viewController: self) // call api with parameters
                
                
                
                
            }
            return false
        }
        return true
    }
    
    
    func cancleInstagram(sender:UIButton) -> Void {
        
        self.instagramWebView .removeFromSuperview()
        CommonFunctionsClass.sharedInstance().alertViewOpen("You canceled the action!", viewController: self)
        self.tabBarController?.tabBar.hidden = false
    }
    
    
    /////////////////--------- Instagram handel end --------///////////////
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
