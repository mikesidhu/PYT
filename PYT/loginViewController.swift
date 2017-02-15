//
//  loginViewController.swift
//  PYT
//
//  Created by Niteesh on 07/12/16.
//  Copyright © 2016 appsMaven. All rights reserved.
//

import UIKit
import MBProgressHUD

class loginViewController: UIViewController, apiClassDelegate {

    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
   
    @IBOutlet var loginButtonOutlet: UIButton!
    var tabledata = NSUserDefaults.standardUserDefaults().arrayForKey("arrayOfIntrest")

    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        loginButtonOutlet.layer.cornerRadius=loginButtonOutlet.frame.size.height/2
        loginButtonOutlet.clipsToBounds=true
        
        loginButtonOutlet!.layer.borderColor=UIColor (colorLiteralRed: 157.0/255.0, green: 194.0/255.0, blue: 134.0/255.0, alpha: 1).CGColor
        loginButtonOutlet!.layer.borderWidth=1.0
        
        
        apiClass.sharedInstance().delegate=self //delegate of api class
        
        // Do any additional setup after loading the view.
    }

    
    //MARK:
    //MARK:Action of buttons
    //MARK:
    
        //MARK:     Back Button
    @IBAction func BackButtonAction(sender: AnyObject) {
        
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKindOfClass(ViewController) {
                self.navigationController?.popToViewController(controller as UIViewController, animated: true)
                break
            }
        }
        
        //self.navigationController?.popViewControllerAnimated(true)
    }
    
    
        //MARK:Login Button
    @IBAction func loginButtonAction(sender: AnyObject) {
        self.loginInDatabase()
    }
    
    
        //MARK:SignUp Button
    @IBAction func signUpButtonAction(sender: AnyObject) {
        
        
        
        let n: Int! = self.navigationController?.viewControllers.count
        let oldUIViewController: UIViewController = (self.navigationController?.viewControllers[n-2])!
        
        
        
        if oldUIViewController.isKindOfClass(ViewController) {
            
           // print("This is first View controller")
            
            let nxtObj = self.storyboard?.instantiateViewControllerWithIdentifier("SignUpScreenViewController") as! SignUpScreenViewController
            
            
            self.dismissViewControllerAnimated(true, completion: {})
            self.navigationController! .pushViewController(nxtObj, animated: true)
            
        }
        else{
            
            //print("This is new view controller")
            self.navigationController?.popViewControllerAnimated(true)
        }
        
        
        
       
        
        
        
    }
    
    
    
    //MARK:
    //MARK: Function To check the Login Credentials
    //MARK:
    
    func loginInDatabase() -> Void {
        
      
        
        
        if emailTextField.text == "" {
            CommonFunctionsClass.sharedInstance().alertViewOpen("Enter email ", viewController: self)
        }
        else
        {
            if isValidEmail(emailTextField.text!)
            {
                emailTextField.textColor=UIColor .blackColor()
                
                if passwordTextField.text=="" {
                    CommonFunctionsClass.sharedInstance().alertViewOpen("Enter password", viewController: self)
                    
                }else{
                    
                    
                    //device token
                    
                    
                    
                    self.emailTextField .resignFirstResponder()
                    self.passwordTextField.resignFirstResponder()
                    
                    let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                    loadingNotification.mode = MBProgressHUDMode.Indeterminate
                    loadingNotification.label.text = "Logging in"
                    
                    self .loginApi(emailTextField.text! as String, password: passwordTextField.text! as String)
                    
                }
                
                
                
            }
            else
            {
                //emailTf.textColor=UIColor .redColor()
                CommonFunctionsClass.sharedInstance().alertViewOpen("Enter valid email", viewController: self)
            }
            
        }
        
        
    
        
    }
    
    
    //MARK:- Valid Email or not
    func isValidEmail(candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluateWithObject(candidate)
    }
    
    
    func loginApi(email:NSString, password:NSString) -> Void{
        
        //print("Password=\(password), email=\(email)")
        
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let token = defaults.stringForKey("deviceToken")!
        print(token)
        
        let parameterString = NSString(string:"email=\(emailTextField.text!)&password=\(passwordTextField.text!)&deviceToken=\(token)") as String
        print(parameterString)
        
        
        apiClass.sharedInstance().postRequestForLogin(parameterString, viewController: self)
        //apiClass.sharedInstance().postRequestSearch(parameterString, viewController: self)// call api
        
        
    }

    
    
    
    
    func moveinsideApp() -> Void {
        
        
        if tabledata?.count<1 {
            
            
            // if not select any location show search screen
            let nxtObj = self.storyboard?.instantiateViewControllerWithIdentifier("firstMainScreenViewController") as! firstMainScreenViewController
            
            
            
            self.navigationController! .pushViewController(nxtObj, animated: true)
            
            
            
            
        }
        else
        {
            self.performSegueWithIdentifier("MainHomeView", sender: self) //if already selected locations then go to home screen
            
        }
        
        
        
        
    }
    
    
    
    
    
    
    func serverResponseArrived(Response:AnyObject){
        
        
        jsonResult = NSDictionary()
        jsonResult = Response as! NSDictionary
        let success = jsonResult.objectForKey("status") as! NSNumber
        if success == 1 {
            
            var userDetail = NSMutableArray()
            userDetail = jsonResult.objectForKey("data") as! NSMutableArray
            
            //print(userDetail)
            //Save the user data for login for further use
            let defaults = NSUserDefaults.standardUserDefaults()
            
            let uEmail = userDetail[0].valueForKey("email") as? String ?? ""
            defaults.setObject(uEmail, forKey: "loginEmail")
            
            let upasswd = userDetail[0].valueForKey("password") as? String ?? ""
            defaults.setObject(upasswd, forKey: "LoginPassword")
            
            let uname = userDetail[0].valueForKey("name") as? String ?? ""
            defaults.setObject(uname, forKey: "userLoginName")
            
            let uid = userDetail[0].valueForKey("userId") as? String ?? ""
            defaults.setObject(uid, forKey: "userLoginId")
            
            let profilePic = userDetail[0].valueForKey("profilePic") as? String ?? ""
            
            defaults.setObject(profilePic, forKey: "userProfilePic")
            
            
         
            
            
            
            
            
            
            
            
            
            
            
            let runtimeLocations = userDetail[0].valueForKey("runtimeLocation") as! NSMutableArray
            
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
                    
                    
                    print("Loc:- \(loc) \n Type-\(type))")
                    
                    
                    var dic = NSMutableDictionary()
                    dic = ["location":loc,"lat": "0.0", "long": "0.0", "type": type, "country": runtimeLocations.objectAtIndex(l), "delete":false]
                     arrayOfLoc .addObject(dic)
                    
                }
                
                 NSUserDefaults.standardUserDefaults().setObject(arrayOfLoc, forKey: "arrayOfIntrest")
               
                
            }
            
            
            
            
            let nxtObj3 = self.storyboard?.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
            
            if nxtObj3.tabledata?.count<1 {
                
                let nxtObj = self.storyboard?.instantiateViewControllerWithIdentifier("firstMainScreenViewController") as! firstMainScreenViewController
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), {() -> Void in
                    
                    self.navigationController! .pushViewController(nxtObj, animated: true)
                    self.dismissViewControllerAnimated(true, completion: {})
                })
                
                
                
            }
            else
            {
                let nxtObj = self.storyboard?.instantiateViewControllerWithIdentifier("MainTabBarViewController") as? MainTabBarViewController
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.navigationController! .pushViewController(nxtObj!, animated: true)
                    self.dismissViewControllerAnimated(true, completion: {})
                })
                
            }
            
           dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {
                
                let uId2 = defaults .stringForKey("userLoginId")
                let objt = storyCountClass()
                objt.postRequestForcountStory("userId=\(uId2!)")
            
            
//            dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {
//                let objt2 = UserProfileDetailClass()
//                objt2.postRequestForGetTheUserProfileData("userId=\(uId2!)")
//            })
            
            })

           
            
            
           
            
            
            
            
        }
        
        
        else
        {
            print(jsonResult)
            if success == 0 {
                
                let alertTxt = jsonResult.valueForKey("data") as? String ?? "Not Valid password"
                
                
                CommonFunctionsClass.sharedInstance().alertViewOpen(alertTxt, viewController: self)
                
            }
            else{
                
                CommonFunctionsClass.sharedInstance().alertViewOpen("Email is not regesterd with PYT", viewController: self)
            }
            
            
            
        }
        
        
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        
    }

   
    
    
    
    //Call api to get the response from the server and send it to the search screen or main feed screen
    /*
    func callApiToGetSearchedPlaces(userId: NSString) -> NSMutableArray {
        
        
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
            
            
            
            request.HTTPBody = userId.dataUsingEncoding(NSUTF8StringEncoding)
            
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
                                    
                                    let detailUser = jsonResult.valueForKey("user")?.objectAtIndex(0).valueForKey("runtimeLocation") as! NSMutableArray
                                    
                                    print(detailUser.count)
                                    print(detailUser)
                                    
                                
                                    
                                    
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

        
        
*/
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
