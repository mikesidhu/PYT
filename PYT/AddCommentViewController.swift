//
//  AddCommentViewController.swift
//  PYT
//
//  Created by Niteesh on 14/02/17.
//  Copyright © 2017 appsMaven. All rights reserved.
//

import UIKit
import SDWebImage
import IQKeyboardManager

class AddCommentViewController: UIViewController {

    
   var dictionaryData = NSDictionary()
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBOutlet weak var commenttextView: UITextView!
    
    @IBOutlet weak var addCommentButton: UIButton!
    
    
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    IQKeyboardManager.sharedManager().shouldResignOnTouchOutside=true
        
        imageView.clipsToBounds=true

        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.activityIndicatorViewStyle = .Gray
        activityIndicator.center = imageView.center
        imageView .addSubview(activityIndicator)
        imageView .bringSubviewToFront(activityIndicator)
        
        activityIndicator .startAnimating()
        
        let thumb = dictionaryData.valueForKey("thumbnailImage") as? String ?? "" //thumbnail
        let large = dictionaryData.valueForKey("largeImage") as? String ?? "" //large
        
        let pImage : UIImage = UIImage(named:"backgroundImage")!
        imageView.sd_setImageWithURL(NSURL(string: thumb as String), placeholderImage: pImage)
        
        let url2 = NSURL(string: large )
        
        
      
        let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in
           activityIndicator .removeFromSuperview()
        }
        
        //completion block of the sdwebimageview
        imageView.sd_setImageWithURL(url2, placeholderImage: imageView.image, completed: block)
        
        imageView.contentMode = .ScaleToFill
        
        
        
        
        ///////text view
        commenttextView.text="Enter Your Comment here"
        commenttextView.textColor=UIColor .lightGrayColor()
        
        addCommentButton.backgroundColor = UIColor (colorLiteralRed: 43/255, green: 50/255, blue: 68/255, alpha: 1.0)
        addCommentButton.layer.cornerRadius = addCommentButton.frame.size.height/2
        addCommentButton.clipsToBounds=true
        
    
        // Do any additional setup after loading the view.
    }

    
    
    //MARK: TextView delegates
    func textViewDidBeginEditing(textView : UITextView) {
        if textView.textColor == UIColor .lightGrayColor() {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
    }
    
    
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter Your Comment here"
            textView.textColor = UIColor .lightGrayColor()
        }
    }
    
    
    
    


    @IBAction func addCommentAction(sender: AnyObject) {
    
        commenttextView.resignFirstResponder()
        
        
        if (commenttextView.textColor == UIColor .lightGrayColor()) {
            
            
            
        }
        else
        {
            let defaults = NSUserDefaults.standardUserDefaults()
            let uId = defaults .stringForKey("userLoginId")!
            let userName = defaults .stringForKey("userLoginName")!
            let userPic = defaults .stringForKey("userProfilePic")!
            let imgId = dictionaryData.valueForKey("imageid") as? String ?? ""
            
            print("id=\(uId)\n name=\(userName)\n Pic=\(userPic)\n imageid=\(imgId)")
            
            
            self.backAction(self)
            
            
        }
       
        
        
    
    }
    
    @IBAction func backAction(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    
    
    
    
    
    //MARK: Add Comment Api
    func AddCommentApi(userId: String, imageId: String ) -> Void {
        
        let parameterString = ""//"imageId=\(imageId)&userId=\(userId)&imageOwner=\(locationName)&review=\(locationType)"
        
        print("Parameter=\(parameterString)")
        
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
            let request = NSMutableURLRequest(URL: NSURL(string: "\(appUrl)add_review")!)
            
            
            request.HTTPMethod = "POST"
            let postString = parameterString
            request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
                guard error == nil && data != nil else {                                                          // check for fundamental networking error
                    //print("error=\(error)")
                    return
                }
                
                if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                    //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    //print("response = \(response)")
                }
                
                let responseString = String(data: data!, encoding: NSUTF8StringEncoding)
                ////print("responseString = \(responseString)")
                
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    do {
                        
                        let result = NSString(data: data!, encoding:NSASCIIStringEncoding)!
                         print("Body: \(result)")
                        
                        let anyObj: AnyObject = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                        
                        basicInfo = NSMutableDictionary()
                        basicInfo = anyObj as! NSMutableDictionary
                        
                        let status = basicInfo .valueForKey("status") as! NSNumber
                        
                        if status == 1{
                            
                            
                                
                                
                                
                                
                            
                            
                        }
                        else
                        {
                            
                            //CommonFunctionsClass.sharedInstance().alertViewOpen("No Older chats found", viewController: self)
                            
                            
                        }
                        
                        
                        
                        
                        
                        
                    } catch {
                        //print("json error: \(error)")
                        CommonFunctionsClass.sharedInstance().alertViewOpen("Sorry there is some issue in backend, Please try again", viewController: self)
                        indicatorClass.sharedInstance().hideIndicator()
                        
                        //  self .postRequestCategories("", viewController: viewController) //recall
                        
                    }
                    
                    
                  
                 
                    
                })
                
                
                
                
                
                
                
            }
            task.resume()
            
        }
        else
        {
            CommonFunctionsClass.sharedInstance().alertViewOpen("Please Check Internet Connection", viewController: self)
        }
        
        
        
    }
    
    

    
    
    
    
    
    
    
    
    
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
