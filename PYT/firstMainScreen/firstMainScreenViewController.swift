//
//  firstMainScreenViewController.swift
//  PYT
//
//  Created by Niteesh on 02/08/16.
//  Copyright © 2016 appsMaven. All rights reserved.
//

import UIKit
import CoreLocation
import IQKeyboardManager
import SDWebImage

 var selectedindxSearch = Int()

class firstMainScreenViewController: UIViewController, UINavigationControllerDelegate, apiClassInterestDelegate, UITextFieldDelegate {

   
    @IBOutlet var heightOfcontentView: NSLayoutConstraint!//heightOfContentView inside scrlView

    @IBOutlet weak var scrollHideView: UIView!
    
    @IBOutlet var heightOfTableView: NSLayoutConstraint! //trendingTable
    
    @IBOutlet var heightOfLocationTable: NSLayoutConstraint!

    @IBOutlet var okeyBtn: UIButton! //used to proceed to next page
    
    @IBOutlet var locationCountLabel: UILabel!
  
    var trendingArray = NSMutableArray()
   
    
    
    var deleteBool = Bool()
    
    @IBOutlet var proceedBtnOutlet: UIButton!
    
    @IBOutlet var menuButton: UIButton!
    
    //indicator objects
    var messageFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    
    
    
    @IBOutlet var cancelOutlet: UIButton!
    @IBOutlet var backButton: UIButton!
    
    
    
    @IBOutlet var doneBtn: UIButton!
    var arrayOfIntrest = NSMutableArray()
   
    
    @IBOutlet var textField: UITextField!
    
    @IBOutlet var BloggersTableView: UITableView!//trendingTable
    @IBOutlet var locationtableView: UITableView!//searched locationTable
    
    
    @IBOutlet var trendingLabel: UILabel!
    
    
   // @IBOutlet var logout: UIButton!
    
    ////////------ trending View
    
    @IBOutlet var heightOfTrendingView: NSLayoutConstraint!
    
    @IBOutlet var firstTrendingBtn: UIButton!
    
    @IBOutlet var firstTrendingName: UILabel!
    
    @IBOutlet var firstTrendingImage: UIImageView!
    
    @IBOutlet var secondTrendingImage: UIImageView!
    
    @IBOutlet var secondTrendingName: UILabel!
    
    @IBOutlet var secondTrendingBtn: UIButton!
    
    @IBOutlet var thirdTrendingImage: UIImageView!
    
    @IBOutlet var thirdTrendingName: UILabel!
    
    @IBOutlet var thirdTrendingBtn: UIButton!
    
    @IBOutlet var forthTrendingImage: UIImageView!
    
    @IBOutlet var forthTrendingName: UILabel!
    
    @IBOutlet var forthTrendingBtn: UIButton!
    
    
    @IBOutlet weak var scrollMainView: UIScrollView!
    
    
    
    //STory view
    
    @IBOutlet weak var storyView: UIView!
    @IBOutlet weak var storyCountLabel: UILabel!
    @IBOutlet weak var bucketCountLabel: UILabel!
    
    
    
    //Autoprompt view
    
    @IBOutlet weak var autoPromptTable: UITableView!
    
    @IBOutlet weak var autoPromptView: UIView!
    
    @IBOutlet weak var promptIndicator: UIActivityIndicatorView!
    var task = NSURLSessionDataTask?()
    var promptArray = NSMutableArray()
    var locationAutoPrompt = NSString()
    var locationType = NSString()
    
    
    @IBOutlet weak var topSpaceForHideView: NSLayoutConstraint!
    
    
    
    
    override func viewWillAppear(animated: Bool) {
        scrollHideView.hidden=true
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        
       
        
        
    }
    
    
    
    //MARK:- ViewDidLoad method 
    //MARK:-
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        doneBtn.layer.cornerRadius=8.0
        doneBtn.clipsToBounds=true
        
        storyCountLabel.layer.cornerRadius=storyCountLabel.frame.size.width/2
        storyCountLabel.clipsToBounds=true
        
        bucketCountLabel.layer.cornerRadius=bucketCountLabel.frame.size.width/2
        bucketCountLabel.clipsToBounds=true
       
        self.okeyBtn.hidden=true
        
        
         self.automaticallyAdjustsScrollViewInsets = false //adjust navigation bar
        
        //disable pop of navigation
        navigationController?.interactivePopGestureRecognizer?.enabled = false
        
        
        
         dispatch_async(dispatch_get_main_queue(), {
        
        //////////------- temp handle intrets:
        
        let tabledata2 = NSUserDefaults.standardUserDefaults().arrayForKey("arrayOfIntrest")
        if tabledata2?.count<1
        {
         //do nothing
            
            self.backButton.hidden=true
            self.proceedBtnOutlet.hidden=true
            
            
            
        }
        else
        {
         let tabledata:NSMutableArray = [NSUserDefaults.standardUserDefaults().arrayForKey("arrayOfIntrest")!]
         print(tabledata[0])
         print(tabledata[0].count)
        
            for i in 0..<tabledata[0].count
            {
            var srrObj = NSMutableDictionary()
               srrObj = (tabledata[0] .objectAtIndex(i) as! NSMutableDictionary).mutableCopy() as! NSMutableDictionary
                
              
            self.arrayOfIntrest .addObject(srrObj)
            
            }
            
        }
        
        
        
        
       self.BloggersTableView.rowHeight=150
        
        self.locationtableView.rowHeight=55
        
        self.SetUpLabels()//manage the corner radius of labels
        
        
        apiClassInterest.sharedInstance().delegate=self
        
        //get the trending places here
        
        let trendingDataSaved = NSUserDefaults.standardUserDefaults().objectForKey("arrayOfTrending")
        if (trendingDataSaved != nil) {
           
            self.trendingArray=NSMutableArray(array: trendingDataSaved as! NSArray)
            
            self.updateTrending()
            
            self.adjustHeightOftableView()
            
            // self.serverResponseArrivedInterest(trendingDataSaved! as AnyObject)
            
        }
        else
        {
            apiClassInterest.sharedInstance().postApiForTrendingLocations(self)
            
        }
        
        
        
        
        
        
        
        self.adjustHeightOftableView()
        
        self.deleteBool=false
        
        
        NSURLCache.sharedURLCache().removeAllCachedResponses()//clear cache
        
       
        
        
        
        
        
        
        
        
        self.navigationController?.navigationBarHidden = true
        
        self.tabBarController?.tabBar.hidden = true
        
        
        
        
        
        self.cancelOutlet.hidden=true
        
        
       selectedindxSearch=0
        
        
        
        })
        
            
        /*
 
         UITableViewCell *c = [tableView cellForRowAtIndexPath:indexPath];
         if (c.accessoryType == UITableViewCellAccessoryCheckmark) {
         [c setAccessoryType:UITableViewCellAccessoryNone];
         }
 
 */
            
        
        textField.delegate=self
        
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside=true
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(firstMainScreenViewController.keyboardDidHide(_:)), name: UIKeyboardDidHideNotification, object: nil)
        
            
        
    }
    
    
    
    func keyboardDidHide(notif: NSNotification) {
        
        if promptArray.count<1{
            
            UIView.animateWithDuration(0.4, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {() -> Void in
                self.autoPromptTable.frame = CGRectMake(0, self.autoPromptView.bounds.height, self.autoPromptView.bounds.width, self.view.bounds.height )
                
                }, completion: {(finished: Bool) -> Void in
                    self.autoPromptView.hidden=true
                     self.scrollMainView.contentOffset.y = 0
                    
            })
            
            
            self.scrollMainView.scrollEnabled=true
            promptArray.removeAllObjects()
            autoPromptTable .reloadData()
            //locationAutoPrompt="Empty"
            
        }
        
    }
    

    
    //MARK:- layers of the labels
    
    func SetUpLabels() -> Void {
        
        
        okeyBtn.layer.cornerRadius=okeyBtn.frame.size.height/2
        okeyBtn.clipsToBounds=true
        
        doneBtn.layer.cornerRadius=doneBtn.frame.size.height/2
        doneBtn.clipsToBounds=true
        
        

        
        textField.layer.cornerRadius=textField.frame.size.height/2
        textField.clipsToBounds=true
        
        
        
        
//////////-------ADD padding and searchicon on the textField------//////////
        let padding = UIView()
        padding.frame=CGRectMake(25, 0, 55, 40)
        let imView = UIImageView()
        imView.frame=CGRectMake(15, 8, 25, 25)
        imView.image=UIImage (named: "searchSc")
        padding .addSubview(imView)
        textField.leftView=padding
        textField.leftViewMode=UITextFieldViewMode .Always
       
        
        
//        
//        if arrayOfIntrest.count<1
//        {
//            //BloggersTableView .reloadData()
//        }
//        else
//        {
//            locationtableView .reloadData()
//           // BloggersTableView .reloadData()
//        }
     
        

        
        //////------ make trending label corner radius from top only
        //let maskPath = UIBezierPath(roundedRect: trendingLabel.bounds,
                                   // byRoundingCorners: [.TopLeft , .TopRight],
                                  //  cornerRadii: CGSize(width: 4.0, height: 4.0))
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: trendingLabel.bounds, byRoundingCorners: UIRectCorner.TopLeft.union(.TopRight), cornerRadii: CGSizeMake(4, 4)).CGPath

        
        maskLayer.frame=maskLayer.bounds
        trendingLabel.layer.mask = maskLayer
        trendingLabel.layer.masksToBounds=true
        //trendingLabel.clipsToBounds=true
        
        
        
        
        
        
        
        
    }
    
    
   
    
    
    
    
    //MARK:- Update the height of TableView Rows with increase of intrests
    
    func adjustHeightOftableView() -> Void
    {
        if arrayOfIntrest.count<1
        {
            topSpaceForHideView.constant=0
            
            okeyBtn.alpha=0.5
            okeyBtn.userInteractionEnabled=false
          
            self.navigationItem.leftBarButtonItem=nil
           
            heightOfTableView.constant = self.BloggersTableView.rowHeight * 3//CGFloat(trendingArray.count)
            heightOfLocationTable.constant=0
            
            heightOfTrendingView.constant=self.view.frame.size.width - 20
            
            self.heightOfcontentView.constant=self.heightOfTableView.constant + 355 + heightOfTrendingView.constant
            
            locationCountLabel.hidden=true
            locationCountLabel.text="0 Added"
            
            backButton.hidden=true
            proceedBtnOutlet.hidden=true
            
            NSUserDefaults.standardUserDefaults().setObject(arrayOfIntrest, forKey: "arrayOfIntrest")
            
            if countArray.objectForKey("storyImages") != nil  {
                print(countArray)
                var countst = NSNumber()
                countst = 0
                storyView.hidden=false
                self.view .bringSubviewToFront(storyView)
                print(countst)
                if countArray.objectForKey("storyCount") != nil {
                    
                    countst = countArray.valueForKey("storyCount") as! NSNumber
                    
                }
                
                if countst == 0 {
                    storyView.hidden=true
                }
               
                
                storyCountLabel.text = String(countst)
                
                
            }
            else
            {
                
                storyView.hidden=true
                
                print("Nothing")
            }

            
            
        }
        else
        {
            if deleteBool==true {
                backButton.hidden=true
            }
            else{
                
                backButton.hidden=false
            }
            
            proceedBtnOutlet.hidden=false
            
            
             self.locationtableView .reloadData()
            print("HEIGHT   ________   \(heightOfTrendingView.constant)")
          heightOfLocationTable.constant=locationtableView.rowHeight * CGFloat (arrayOfIntrest.count)
             print("HEIGHT table   ________   \(heightOfLocationTable.constant)")
            heightOfTableView.constant = self.BloggersTableView.rowHeight * 3
            
            self.heightOfcontentView.constant=self.heightOfTableView.constant + 355 + self.heightOfLocationTable.constant + heightOfTrendingView.constant
           
           print("heightOfcontentView   ________   \(heightOfcontentView.constant)")

            
            
           locationCountLabel.text="\(arrayOfIntrest.count) Added"
            locationCountLabel.hidden=true
            
           
            
            
            okeyBtn.alpha=1
            okeyBtn.userInteractionEnabled=true
           
            
            self.textField.hidden=false
            self.doneBtn.hidden=false
            
            topSpaceForHideView.constant = 0
                    if(self.arrayOfIntrest.count==5)
                    {
                        topSpaceForHideView.constant = -164
                        self.heightOfcontentView.constant = self.heightOfcontentView.constant - 160
                        self.textField.hidden=true
                        self.doneBtn.hidden=true
                    }
            
                    if self.arrayOfIntrest.count<1 {
             topSpaceForHideView.constant = 0
                        self.navigationItem.setHidesBackButton(true, animated: true)
                        
                    }
            
            storyView.hidden=true

             NSUserDefaults.standardUserDefaults().setObject(arrayOfIntrest, forKey: "arrayOfIntrest")
            
        }
        
        

        
        
        
    }
    
    
    
    //MARK: AUTO PROMPT module Starts from here
    //MARK:-
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        print("While entering the characters this method gets called")
    
        
       textField.addTarget(self, action: #selector(firstMainScreenViewController.checkTextField(_:)), forControlEvents: UIControlEvents.EditingChanged)
        
        
        
        //else{
            return true
       // }
        
    }
    
    
    func checkTextField(textField: UITextField) {
        
        
        let characterset = NSCharacterSet(charactersInString: " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
        
        let stringText:NSString = textField.text!
        
        
        
        var SearchString = NSString()
        
        
        if (stringText.rangeOfCharacterFromSet(characterset.invertedSet).location != NSNotFound){
            print("Could not handle special characters")
            let newStr = stringText .substringToIndex(stringText .length - 1)
            
            textField.text = newStr
            SearchString = newStr
        }
            
        else{
            SearchString = textField.text!
        }
        
        
        print(SearchString)
        
        
        locationAutoPrompt="Empty"
        
        
        //if SearchString.length == 3 {
            
        
            
           
            
       // }
        
        if autoPromptView.hidden==true {
            self.scrollMainView.scrollEnabled=false
            self.autoPromptTable.frame = CGRectMake(0, self.autoPromptView.bounds.height, self.autoPromptView.bounds.width, self.autoPromptView.bounds.height )
            self.autoPromptView.hidden=false
            
            UIView.animateWithDuration(0.4, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {() -> Void in
                
                self.scrollMainView.contentOffset.y = 65
                
                self.autoPromptTable.frame = CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height )
                }, completion: {(finished: Bool) -> Void in
            })
        }
        
        
        
        
        
         if SearchString.length >= 3 {
             self.scrollMainView.scrollEnabled=false
            promptIndicator.hidden=false
            promptIndicator.startAnimating()
            
            let defaults = NSUserDefaults.standardUserDefaults()
            let uId = defaults .stringForKey("userLoginId")

            
            if task != nil {
                
                if task!.state == NSURLSessionTaskState.Running {
                    task!.cancel()
                    print("\n\n Task 1 cancel\n\n")
                }
            }
           
            let parameterString = NSString(string:"query=\(SearchString)&userId=\(uId!)") as String
            print(parameterString)
            
            
            
            self .postApiForAutoPromptLocations(parameterString)
            
            
        }
        
        if SearchString.length < 1 {
            
            promptArray.removeAllObjects()
            autoPromptTable .reloadData()
            locationAutoPrompt="Empty"
            UIView.animateWithDuration(0.4, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {() -> Void in
                self.autoPromptTable.frame = CGRectMake(0, self.autoPromptView.bounds.height, self.autoPromptView.bounds.width, self.view.bounds.height )
                
                }, completion: {(finished: Bool) -> Void in
                    self.autoPromptView.hidden=true
                    
            })
            
            
            
            self.scrollMainView.scrollEnabled=true
            
        }
        
        
    }
    
    
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        locationAutoPrompt="Empty"
        
        print("TextField did begin editing method called")
        
        
      
        
         promptIndicator.hidden=true
        
        // if autoPromptView.hidden==false {
        scrollMainView.scrollEnabled=false
        // }
        if autoPromptView.hidden==true {
            self.autoPromptTable.frame = CGRectMake(0, self.autoPromptView.bounds.height, self.autoPromptView.bounds.width, self.autoPromptView.bounds.height )
            self.autoPromptView.hidden=false
            
            UIView.animateWithDuration(0.4, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {() -> Void in
                
                  self.scrollMainView.contentOffset.y = 65
                
                self.autoPromptTable.frame = CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height )
                }, completion: {(finished: Bool) -> Void in
            })
        }
        
        
        
        
        let SearchString: NSString = textField.text!
        
        if SearchString.length >= 3 {
            
           // promptIndicator.hidden=false
           // promptIndicator.startAnimating()
            
            let defaults = NSUserDefaults.standardUserDefaults()
            let uId = defaults .stringForKey("userLoginId")
            
            
            if task != nil {
                
                if task!.state == NSURLSessionTaskState.Running {
                    task!.cancel()
                    print("\n\n Task 1 cancel\n\n")
                }
            }
            
            let parameterString = NSString(string:"query=\(SearchString)&userId=\(uId!)") as String
            print(parameterString)
            
            
            
           // self .postApiForAutoPromptLocations(parameterString)
            
            
        }
        
        
        
        
    }
    
    
    
    
    
    func postApiForAutoPromptLocations(searchString: String)
    {
        
        
       
          //  let request = NSMutableURLRequest(URL: NSURL(string: "http://35.164.60.90/")!)

            
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
            // CommonFunctionsClass.sharedInstance().startIndicator(viewController.view)
            
            var urlString = NSString(string:"http://35.164.60.90/searchPlaces")
            print("WS URL----->>" + (urlString as String))
            
            urlString = urlString .stringByReplacingOccurrencesOfString(" ", withString: "%20")
            
            let url:NSURL = NSURL(string: urlString as String)!
            let session = NSURLSession.sharedSession()
            
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
            
            
            print(searchString)
            request.HTTPBody = searchString.dataUsingEncoding(NSUTF8StringEncoding)
            
         
            
            
          
            
            
            
             task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
                
                NSOperationQueue.mainQueue().addOperationWithBlock
                    {
                        
                        self.promptIndicator.hidden=true
                        self.promptIndicator.stopAnimating()

                        if data == nil
                        {
                           // CommonFunctionsClass.sharedInstance().alertViewOpen("Server is not responding", viewController: self)
                           
                        }
                        else
                        {
                            
                            
                            do {
                                
                                let result = NSString(data: data!, encoding:NSASCIIStringEncoding)!
                                print("Body: \(result)")
                                
                                
                                
                                let anyObj: AnyObject = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                                
                                
                                jsonResult = NSDictionary()
                                jsonResult = anyObj as! NSDictionary
                                let status = jsonResult .valueForKey("status") as! NSNumber
                                
                                if status == 1{
                                    
                                    //let resultArray = jsonResult .valueForKey("result") as! NSMutableArray
                                    //print(resultArray.count)
                                    self.promptArray.removeAllObjects()
                                    self.autoPromptTable .reloadData()
                                    self.locationAutoPrompt="Empty"
                                    self.promptArray = jsonResult .valueForKey("result") as! NSMutableArray
                                    print(self.promptArray.count)
                                    print("prompt array\n \n \(self.promptArray)")
                                    self.autoPromptTable .reloadData()
                                    
                                }
                                    
                                else
                                {
                                    if self.promptArray.count<1
                                    {
                                    print("No result found")
                                        
                                    }
                                    else
                                    {
                                        self.autoPromptTable .reloadData()
                                        
                                    }
                                    
                                     self.textField .resignFirstResponder()
                                    CommonFunctionsClass.sharedInstance().alertViewOpen("No Location Found", viewController: self)
                                    
                                   
                                    //print("No result found")
                                    
                                }
                                
                                
                                
                                
                            } catch
                            {
                                print("json error: \(error)")
                                CommonFunctionsClass.sharedInstance().alertViewOpen("Sorry there is some issue in backend, Please try again", viewController: self)
                                // indicatorClass.sharedInstance().hideIndicator()
                                //MBProgressHUD.hideAllHUDsForView(viewController.view, animated: true)
                            }
                            
                            
                            
                            
                            
                            
                        }
                }
            })
            
            task!.resume()
        }
        else
        {
            CommonFunctionsClass.sharedInstance().alertViewOpen("Please Check Internet Connection", viewController: self)
           
        }
            
            
        
    }
    
    
    
    
    
    //MARK:-
    
    
    
    
    
   
    /*
 
     DONE action will add the entered location into the array after verifying it from the google reverse api 
        and also check the entered location is valid or not
     
     PROCEED action will move to the new view controller
     
     */
    
    
    
    //MARK:- //////////Buttons Action Here//////
    //MARK:-
    
    
    
    //MARK:-done and proceed button
    
    
    @IBAction func doneBtnAction(sender: AnyObject)
    {
    
       
        print(locationAutoPrompt)
        if locationAutoPrompt=="Empty" {
            
            CommonFunctionsClass.sharedInstance().alertViewOpen("Please Select Location First!", viewController: self)
        }
            
        else
        {
        
        
        
        
        if arrayOfIntrest .valueForKey("location").containsObject(locationAutoPrompt) {
            
            CommonFunctionsClass.sharedInstance().alertViewOpen("Please Enter Different Name", viewController: self)
            self.messageFrame.removeFromSuperview()
            self.textField.userInteractionEnabled=true
            self.doneBtn.userInteractionEnabled=true
            self.okeyBtn.userInteractionEnabled=true
            self.textField.text=""
            scrollHideView.hidden=true
            
        }else{
            
            var dict = NSMutableDictionary()
            dict = ["location":locationAutoPrompt,"lat": "0.0", "long": "0.0", "type": locationType, "country":"\(locationAutoPrompt)",  "delete":false ]
            
            
            
            if self.arrayOfIntrest.count<5{
                 topSpaceForHideView.constant = 0
                self.arrayOfIntrest .addObject(dict)
                print(self.arrayOfIntrest)
                self.textField.text=""
            }
            else{
                CommonFunctionsClass.sharedInstance().alertViewOpen("Max of five places can be added!", viewController: self)
                 topSpaceForHideView.constant = -164
                self.scrollHideView.hidden=true
            }
            
            
            
            
            
             topSpaceForHideView.constant = 0
            //hide if there are 5 locations in the array
            
            if(self.arrayOfIntrest.count==5)
            {
                 topSpaceForHideView.constant = -164
                //self.textField.hidden=true
                self.doneBtn.hidden=true
                
                
            }
            
            self.adjustHeightOftableView()
            
            
            }
        
            
            
            
            
            
            
            
            
            
            
            
        }
        
        
        
        /*
        scrollHideView.hidden=false
        
        progressBarDisplayer("Verifying", true)
        
        
        
        self.textField.resignFirstResponder()
        self.textField.userInteractionEnabled=false
        self.doneBtn.userInteractionEnabled=false
        self.okeyBtn.userInteractionEnabled=false
        
        
        //capital letter first
        var str2 = String()
        str2=textField.text!
        var str = NSString()
        str=str2
        
        
        
        print(str)
        
        if str.length<1 // check if empty textfield
        {
            self.messageFrame.removeFromSuperview()
            CommonFunctionsClass.sharedInstance().alertViewOpen("Please Enter Location!", viewController: self)
            
            self.textField.userInteractionEnabled=true
            self.doneBtn.userInteractionEnabled=true
            self.okeyBtn.userInteractionEnabled=true
            scrollHideView.hidden=true
        }
            
        else if(str .rangeOfCharacterFromSet(NSCharacterSet .decimalDigitCharacterSet()).location != NSNotFound)//check numeric value
        {
            
            CommonFunctionsClass.sharedInstance().alertViewOpen("Please Enter valid Location!", viewController: self)
            self.messageFrame.removeFromSuperview()
            self.textField.userInteractionEnabled=true
            self.doneBtn.userInteractionEnabled=true
            self.okeyBtn.userInteractionEnabled=true
            self.textField.text=""
            scrollHideView.hidden=true
        }
            
            //finaly add location with G.Reverse api
        else
        {
            //str2.replaceRange(str2.startIndex...str2.startIndex, with: String(str2[str2.startIndex]).capitalizedString)
            str2 = str2.capitalizedString
            var str = NSString()
            print(str2)
            str = str2 .stringByTrimmingCharactersInSet(NSCharacterSet .whitespaceCharacterSet())
            
            
            if arrayOfIntrest .valueForKey("location").containsObject(str) {
                
                CommonFunctionsClass.sharedInstance().alertViewOpen("Please Enter Different Name", viewController: self)
                self.messageFrame.removeFromSuperview()
                self.textField.userInteractionEnabled=true
                self.doneBtn.userInteractionEnabled=true
                self.okeyBtn.userInteractionEnabled=true
                self.textField.text=""
                scrollHideView.hidden=true
                
            }
            else
            {
                
                
                ///get the lat long if not avaliable
                let address = textField.text! as String
                let geocoder = CLGeocoder()
                geocoder
                
                geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
                    if((error) != nil)
                    {
                        print("Error", error)
                        self.textField.text=""
                        self.messageFrame.removeFromSuperview()
                        
                        CommonFunctionsClass.sharedInstance().alertViewOpen("Please enter proper location!", viewController: self)
                        
                        self.textField.userInteractionEnabled=true
                        self.doneBtn.userInteractionEnabled=true
                        self.okeyBtn.userInteractionEnabled=true
                        self.scrollHideView.hidden=true
                    }
                    
                    if let placemark = placemarks?.first
                    {
                        let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                        print(coordinates)
                        let latitude = String(format:"%f", coordinates.latitude)
                        
                        print(placemark)
                        print(placemark.addressDictionary)
                        
                        
                        if placemark.addressDictionary==nil
                        {
                            
                            var type = NSString()//used to find the entered string is a City, State, or country
                            type = "city"
                            let longitude = String(format: "%f", coordinates .longitude)
                            
                            var dict = NSMutableDictionary()
                            dict = ["location":str,"lat": latitude, "long": longitude, "type": type, "country":"null",  "delete":false ]
                            
                            
                            
                            if self.arrayOfIntrest.count<5{
                                self.arrayOfIntrest .addObject(dict)
                                print(self.arrayOfIntrest)
                                self.textField.text=""
                            }
                            else{
                                CommonFunctionsClass.sharedInstance().alertViewOpen("Max of five places can be added!", viewController: self)
                                 self.scrollHideView.hidden=true
                            }
                            
                            
                           
                            
                            
                            
                            //hide if there are 5 locations in the array
                            
                            if(self.arrayOfIntrest.count==5)
                            {
                                //self.textField.hidden=true
                                self.doneBtn.hidden=true
                               
                                
                            }
                            
                            
                            self.adjustHeightOftableView()
                            
                            self.messageFrame.removeFromSuperview()
                            
                            self.textField.userInteractionEnabled=true
                            self.doneBtn.userInteractionEnabled=true
                            self.okeyBtn.userInteractionEnabled=true
                             self.scrollHideView.hidden=true
                            
                        }
                            
                        else
                        {
                            
                            
                            
                            let state = placemark.addressDictionary!["State"] as? String ?? ""
                            print(state)
                            
                            let city = placemark.addressDictionary!["City"] as? String ?? ""
                            print(city)
                            
                            
                            
                            let country = placemark.addressDictionary!["Country"] as? String ?? "null"
                            print(country)
                            
                            var type = NSString()//used to find the entered string is a City, State, or country
                            
                            
                            if(str.caseInsensitiveCompare(city) == NSComparisonResult.OrderedSame)
                            {
                                print("is city")
                                type = "city"
                            }
                                
                            else if(str.caseInsensitiveCompare(state) == NSComparisonResult.OrderedSame)
                            {
                                print("is state")
                                type = "state"
                            }
                            else if(str.caseInsensitiveCompare(country) == NSComparisonResult.OrderedSame)
                            {
                                print("is country")
                                type = "country"
                            }
                                
                                
                                
                                //if not get any city, state, country
                                
                            else
                            {
                                
                                if (placemark.administrativeArea==nil || placemark.areasOfInterest==nil)
                                {
                                    CommonFunctionsClass.sharedInstance().alertViewOpen("Location not found!", viewController: self)
                                    type = "nil"
                                    
                                }
                                else
                                {
                                    
                                    let admArea = placemark.administrativeArea! as String ?? ""
                                    print(admArea)
                                    
                                    let areaIntrest = placemark.areasOfInterest! as [String] ?? [""]
                                    print(areaIntrest)
                                    
                                    let strr = areaIntrest[0]
                                    print( strr)
                                    
                                    if(str.caseInsensitiveCompare(admArea) == NSComparisonResult.OrderedSame)
                                    {
                                        print("is other")
                                        type = "other"
                                    }
                                        
                                    else  if(str.caseInsensitiveCompare(strr) == NSComparisonResult.OrderedSame)
                                    {
                                        print("is city")
                                        type = "other"
                                    }
                                    else{
                                        CommonFunctionsClass.sharedInstance().alertViewOpen("Location not found!", viewController: self)
                                        type = "nil"
                                        
                                    }
                                }
                                
                                
                                
                                
                            }
                            
                            
                            if type == "nil"
                            {
                                print("is city")
                                type = "city"
                            }
                            else
                            {
                                let longitude = String(format: "%f", coordinates .longitude)
                                
                                var diction = NSMutableDictionary()
                                diction = ["location":str,"lat": latitude, "long": longitude, "type": type, "country": country,  "delete":false ]
                                
                                if self.arrayOfIntrest.count<5{
                                    self.arrayOfIntrest .addObject(diction)
                                    print(self.arrayOfIntrest)
                                    self.textField.text=""
                                }
                                else{
                                    CommonFunctionsClass.sharedInstance().alertViewOpen("Cann't add more than five!", viewController: self)
                                }
                                
                                
                            }
                            
                            
                            //hide if there are 5 locations in the array
                           
                            if(self.arrayOfIntrest.count==5)
                            {
                                self.textField.hidden=true
                                self.doneBtn.hidden=true
                                 self.scrollHideView.hidden=true
                              
                            }
                            
                            
                            
                            self.adjustHeightOftableView()
                            
                            self.messageFrame.removeFromSuperview()
                            
                            self.textField.userInteractionEnabled=true
                            self.doneBtn.userInteractionEnabled=true
                            self.okeyBtn.userInteractionEnabled=true
                             self.scrollHideView.hidden=true
                        }
                        
                    }
                })
                
            }
        }
    */
    
    }
    
    
    
    
    @IBAction func cancelDelete(sender: AnyObject) {
        
         deleteBool=false
        self.adjustHeightOftableView()
        cancelOutlet.hidden=true
    }
    
    
    
    
    
    //MARK:- Goto Story Screen
    
    @IBAction func storyButtonAction(sender: AnyObject) {
        
        let nxtObj = self.storyboard?.instantiateViewControllerWithIdentifier("storyViewcontrollerViewController") as! storyViewcontrollerViewController
        
        dispatch_async(dispatch_get_main_queue(), {
            self.navigationController! .pushViewController(nxtObj, animated: true)
            nxtObj.hidesBottomBarWhenPushed = true
        })
        
    }
    
    
    
    //MARK:- Goto Bucket List
    
    @IBAction func bucketListAction(sender: AnyObject) {
    
        let nxtObj = self.storyboard?.instantiateViewControllerWithIdentifier("BucketListViewController") as! BucketListViewController
        
       
            self.navigationController! .pushViewController(nxtObj, animated: true)
        
        }
    
    
    
    
    
    
    
    /*
    @IBAction func deleteButton(sender: AnyObject) {
    
        
        
        if deleteBool==true { //delete the selected locations
         deleteBool=false
            


            
            for (var i=0; i<arrayOfIntrest.count; i += 1){
                
                if arrayOfIntrest.objectAtIndex(i).valueForKey("delete") as! Bool == true {
                arrayOfIntrest .removeObjectAtIndex(i)
                    i -= 1
                    print(i)
                    print(arrayOfIntrest)
                }
                
                
            }
        
            
            cancelOutlet.hidden=true
            self.adjustHeightOftableView()
            
            
            
        }
            //first time
        else
        {
        deleteBool=true
        cancelOutlet.hidden=true//false
        backButton.hidden=true
        locationtableView .reloadData()
        
        }
        
 
        
    }
    
    
    */
    
    
    
    
    
    
    
    //// action of proceed button to move next third
   
    @IBAction func nextPageAction(sender: AnyObject)
    {
        if arrayOfIntrest.count<1
        {
            CommonFunctionsClass.sharedInstance().alertViewOpen("Please add minimum one interest", viewController: self)
        }
        else
        {
            //hit api
            let defaults = NSUserDefaults.standardUserDefaults()
            let uId = defaults .stringForKey("userLoginId")
           
            
            
            let typeArr = NSMutableArray()
            let locArr = NSMutableArray()
            
            for i in 0..<arrayOfIntrest.count {
                
                print(arrayOfIntrest.objectAtIndex(i).valueForKey("location"))
                
                let combineStr = "\((arrayOfIntrest.objectAtIndex(i).valueForKey("location")! as? String)!)-PYT-\((arrayOfIntrest.objectAtIndex(i).valueForKey("type")! as? String)!)"
                print(combineStr)
                
                typeArr .addObject(combineStr)
                
            }
            
            
            
             let dic: NSDictionary = ["search":typeArr as NSMutableArray, "userId":uId!]
            
            
            print(dic)
            
             // dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {
            
            apiClass.sharedInstance().postRequestSearchedLocations("userId=\(uId!)", totalLocations: dic , viewController: self)
            
                //})
            
            NSUserDefaults.standardUserDefaults().setObject(arrayOfIntrest, forKey: "arrayOfIntrest")
            
            let nxtObj = self.storyboard?.instantiateViewControllerWithIdentifier("MainTabBarViewController") as! MainTabBarViewController
           
            
            
            
           // dispatch_async(dispatch_get_main_queue(), {
                self.navigationController! .pushViewController(nxtObj, animated: true)
                self.dismissViewControllerAnimated(true, completion: {})
                NSURLCache.sharedURLCache().removeAllCachedResponses()
           // })
            
            
            
        }
        
        
        
    }
    
    
    
   
    ////-- back button 
    
    @IBAction func backBtnAction(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
        self.dismissViewControllerAnimated(true, completion: {})
        NSURLCache.sharedURLCache().removeAllCachedResponses()
    }
    
    
    
    
    
    
    
    
    
    
    
    //MARK:- indicator with some text function
    //MARK:-
   
    func progressBarDisplayer(msg:String, _ indicator:Bool )
    {
         print(msg)
         strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 200, height: 50))
         strLabel.text = msg
         strLabel.textColor = UIColor.whiteColor()
         messageFrame = UIView(frame: CGRect(x: self.view.frame.midX - 90, y: self.view.frame.midY - 25 , width: 180, height: 50))
        messageFrame.layer.cornerRadius = 15
        messageFrame.backgroundColor = UIColor(white: 0, alpha: 0.7)
        if indicator
        {
            activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
            activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            activityIndicator.startAnimating()
            messageFrame.addSubview(activityIndicator)
        }
        messageFrame.addSubview(strLabel)
        self.view.addSubview(messageFrame)
    }
    
    
    
    
    
    
    
    //MARK:- Buttons action to remove the intrests
    
    
    
    
    func deleteLocation(sender:UIButton) -> Void {
        
        
        print(arrayOfIntrest.count)
        
        arrayOfIntrest .removeObjectAtIndex(sender.tag)
        
        if arrayOfIntrest.count<5 {
            self.doneBtn.hidden=false
        }
        
        self .adjustHeightOftableView()
        
    }
    

    
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        
        return 1
        
        
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView==locationtableView {
            return arrayOfIntrest.count
        }
        else if tableView == autoPromptTable{
            return promptArray.count
        }
        else{
           return 3//trendingArray.count
        }
        
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        if tableView==locationtableView {
            
             let cellLocation:locationsCell = tableView.dequeueReusableCellWithIdentifier("cellLocation")! as! locationsCell
            
            let LocationNameString = arrayOfIntrest.objectAtIndex(indexPath.row).valueForKey("location") as? String ?? ""
            
            cellLocation.locationLabel.text = LocationNameString
            let whiteView = cellLocation.viewWithTag(222)
            whiteView?.layer.cornerRadius=5
            whiteView?.clipsToBounds=true
            
              cellLocation.accessoryType = .None
             cellLocation.backgroundColor=UIColor .clearColor()
            cellLocation.markerImage.image=UIImage (named: "markerSearch")
            
            
            
            
           
            
            
            
            
            return cellLocation
            
        }
          
            
            
        else if tableView == autoPromptTable{
            
            
             let cellPrompt:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("promptCell")! 
            
            
            
            let searchLabel = cellPrompt.viewWithTag(5555) as! UILabel
            
            searchLabel.text = promptArray.objectAtIndex(indexPath.row).valueForKey("name") as? String ?? ""
            
            
            return cellPrompt
            
        }
            
            
            
            
            
            
            
            
            
            
          //Bloggers location table
        else
        {
            let cell:searchTableCell = tableView.dequeueReusableCellWithIdentifier("searchCell")! as! searchTableCell
            
            
           var profileUrl = NSString()
            
            if indexPath.row==0 {
                profileUrl = "https://scontent.xx.fbcdn.net/v/t1.0-1/c3.0.50.50/p50x50/11659245_858591540881778_3443521200972300309_n.jpg?oh=2684f2e2132c48d119e0c3cbf65bfe40&oe=58ED6DFB"
            //Nitin Sir

                cell.bloggerName.text="Nitin Trehan"
                cell.locationImage.image=UIImage (named: "img2")
                
                cell.blogsBtnLbl .setTitle("96 Blogs", forState: UIControlState .Normal)
                cell.likesBtnLbl .setTitle("1976 Likes", forState: UIControlState .Normal)
                
            }
            else if indexPath.row==1{
               
                profileUrl = "https://scontent.xx.fbcdn.net/v/t1.0-1/p50x50/15349790_10154566396396609_4262469596483300295_n.jpg?oh=af3eec7939958de237acaee1ab7886fd&oe=58DBFF64"
                cell.bloggerName.text="Tanvi Trehan"
                cell.locationImage.image=UIImage (named: "img3")
                
                cell.blogsBtnLbl .setTitle("84 Blogs", forState: UIControlState .Normal)
                cell.likesBtnLbl .setTitle("1463 Likes", forState: UIControlState .Normal)
                
            }
                
                
            else
            {
                
                profileUrl = "https://scontent.xx.fbcdn.net/v/t1.0-1/p50x50/15726441_10154581083519193_8947036995706174825_n.jpg?oh=de675214c09b0dc901deca70d3bd6276&oe=58F1ACC3"
                cell.bloggerName.text="Dimple Duggal"
                cell.locationImage.image=UIImage (named: "img4")
                
                cell.blogsBtnLbl .setTitle("62 Blogs", forState: UIControlState .Normal)
                cell.likesBtnLbl .setTitle("1233 Likes", forState: UIControlState .Normal)
               //Tanvi mam
            }
            
            
            let url = NSURL(string: profileUrl as String)
            
           // cell.locationImage.sd_setImageWithURL(url)
            
          cell.profileImage.sd_setImageWithURL(url)
            
            
            
            //        cell.locationImage.image=UIImage (named: imgsCity[indexPath.row])
            
            
            
            
          
            
            
            
           
            //Layout and constraints
            
            cell.profileImage!.layer.cornerRadius=cell.profileImage.frame.size.width/2
            cell.profileImage!.clipsToBounds=true
            
            cell.profileBorder.layer.cornerRadius=cell.profileBorder.frame.size.width/2
            cell.profileBorder!.clipsToBounds=true
            
            cell.whiteView.layer.cornerRadius=5
            cell.whiteView.layer.shadowColor = UIColor .lightGrayColor().CGColor
            cell.whiteView.layer.shadowOffset = CGSizeMake(0, 2.0)
            cell.whiteView.layer.shadowOpacity = 0.7
            cell.whiteView.layer.shadowRadius = 1.0
           
            cell.locationImage.contentMode = .ScaleAspectFill
            cell.locationImage.layer.cornerRadius=4
            cell.locationImage.clipsToBounds=true

            
            
            return cell
        }
        
        
        
        
    }

    func tableView(tableView: (UITableView!), commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: (NSIndexPath!)) {
        
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
         if tableView==locationtableView {
            return true
        }
         else if tableView == autoPromptTable{
            
            return false
         }
         else{
            return false
        }
        
    }
    
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        
        let deleteAction = UITableViewRowAction(style: .Default, title: "Delete") {action in
            
            if tableView==self.locationtableView {
                
                
                    self.arrayOfIntrest .removeObjectAtIndex(indexPath.row)
                    self.adjustHeightOftableView()
                
                
                
            }
        }
        
        
        return [deleteAction]
    }
    
    
    
    func tableView(tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: NSIndexPath) {
        
        
        
       
    }
    
    
    
    
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if tableView==locationtableView {
            
            
            selectedindxSearch=indexPath.row
           
            self .nextPageAction(self)
            
        }
            
        else if tableView == autoPromptTable
        {
            
                let selectedString = promptArray.objectAtIndex(indexPath.row).valueForKey("name") as? String ?? ""
                print(selectedString)
                textField.text=selectedString
            locationAutoPrompt = selectedString
            
            let ArrToSeperate = selectedString .componentsSeparatedByString(",")
            if ArrToSeperate.count>1 {
                locationAutoPrompt=ArrToSeperate[0] as String
            }
            
            
            
            let str = promptArray.objectAtIndex(indexPath.row).valueForKey("id") as? String ?? ""
            
            let stringWithoutDigit = (str.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet()) as NSArray).componentsJoinedByString("")
            
            if stringWithoutDigit == "" {
                locationType="city"
            }
            else{
            locationType = stringWithoutDigit
            }
            
            print(locationType)
           
            
            
            
            UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {() -> Void in
                self.autoPromptTable.frame = CGRectMake(0, self.autoPromptView.bounds.height, self.autoPromptView.bounds.width, self.view.bounds.height )
                
                }, completion: {(finished: Bool) -> Void in
                    self.autoPromptView.hidden=true
                    self.scrollMainView.contentOffset.y = 0
                    
            })
            
            
           textField.resignFirstResponder()
            self.scrollMainView.scrollEnabled=true
           promptArray.removeAllObjects()
            autoPromptTable .reloadData()
           
            
        }
            
        else
        {
            
            
        }
        
        
        
        
    }
 
 
 
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        
        
        if scrollView==autoPromptTable {
           textField .resignFirstResponder()
            
            if promptArray.count<1{
                
                UIView.animateWithDuration(0.4, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {() -> Void in
                    self.autoPromptTable.frame = CGRectMake(0, self.autoPromptView.bounds.height, self.autoPromptView.bounds.width, self.view.bounds.height )
                    
                    }, completion: {(finished: Bool) -> Void in
                        self.autoPromptView.hidden=true
                       // self.scrollMainView.contentOffset.y = -65
                        
                })
                
                
                self.scrollMainView.scrollEnabled=true
                promptArray.removeAllObjects()
                autoPromptTable .reloadData()
                locationAutoPrompt="Empty"
                
            }
            
            
            
            
        }
       
        
    }
    
    
    
    
    
//    
//    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
//       
//        if tableView==autoPromptTable {
//            
//            let selectedString = promptArray.objectAtIndex(indexPath.row).valueForKey("name") as? String ?? ""
//            print(selectedString)
//           textField.text=selectedString
//            
//        }
//        
//       
//    }
    
    
    
    
    
    ////////------- Get the trending locations from the api----//////
    
    //MARK:- Trending Locations
    //MARK:-
     func serverResponseArrivedInterest(Response:AnyObject){
        
        
        jsonMutableArray = NSMutableArray()
        jsonMutableArray = (Response as? NSMutableArray)!
        
        
        print(trendingArray)
        
        trendingArray=jsonMutableArray
        
        NSUserDefaults.standardUserDefaults().setObject(trendingArray, forKey: "arrayOfTrending")
        
        
        
        print(trendingArray.count)
        
        //self.BloggersTableView.reloadData()
        
        self.updateTrending()
        
        self.adjustHeightOftableView()
        
        
    }
    
    
    
    //MARK:Show Trending Labels
    //MARK:
    func updateTrending() -> Void
    {
        
        for i in 0..<trendingArray.count {
            
            
            let nameSt = trendingArray.objectAtIndex(i).valueForKey("country") as? String ?? " "
            
            
            let pImage : UIImage = UIImage(named:"backgroundImage")! //placeholder image
            let imageLoc = trendingArray.objectAtIndex(i).valueForKey("imageLarge") as? String ?? ""
            
            let url = NSURL(string: imageLoc as String)
            
            
            switch i {
            case 0:
                
                firstTrendingName.text=nameSt
                let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in
                    //print(self)
                    
                }
                
               firstTrendingImage.sd_setImageWithURL(url, placeholderImage: pImage, completed: block)
                firstTrendingImage.contentMode = .ScaleAspectFill
                firstTrendingImage.layer.cornerRadius=4
                firstTrendingImage.clipsToBounds=true
                
                firstTrendingBtn.tag=0
                firstTrendingBtn.addTarget(self, action: #selector(firstMainScreenViewController.addFromTrending(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                
                
                
            case 1:
                
                secondTrendingName.text=nameSt
                let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in
                    //print(self)
                    
                }
                
                secondTrendingImage.sd_setImageWithURL(url, placeholderImage: pImage, completed: block)
                secondTrendingImage.contentMode = .ScaleAspectFill
                secondTrendingImage.layer.cornerRadius=4
                secondTrendingImage.clipsToBounds=true
                
                secondTrendingBtn.tag=1
                secondTrendingBtn.addTarget(self, action: #selector(firstMainScreenViewController.addFromTrending(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                

            case 2:
                
                thirdTrendingName.text=nameSt
                let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in
                    //print(self)
                    
                }
                
                thirdTrendingImage.sd_setImageWithURL(url, placeholderImage: pImage, completed: block)
                thirdTrendingImage.contentMode = .ScaleAspectFill
                thirdTrendingImage.layer.cornerRadius=4
                thirdTrendingImage.clipsToBounds=true
                
                thirdTrendingBtn.tag=2
                thirdTrendingBtn.addTarget(self, action: #selector(firstMainScreenViewController.addFromTrending(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                
            case 3:
                
                forthTrendingName.text=nameSt
                let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in
                    //print(self)
                    
                }
                
                forthTrendingImage.sd_setImageWithURL(url, placeholderImage: pImage, completed: block)
                forthTrendingImage.contentMode = .ScaleAspectFill
                forthTrendingImage.layer.cornerRadius=4
                forthTrendingImage.clipsToBounds=true
                
                forthTrendingBtn.tag=3
                forthTrendingBtn.addTarget(self, action: #selector(firstMainScreenViewController.addFromTrending(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                
                
            default:
                print("done with for 4 locations")
            }
            
            
            
        }
        
        heightOfTrendingView.constant=self.view.frame.size.width - 15
       
        
    }
    
    
    //MARK: Function to select the location in trending and move tonext screen
    //MARK:
    
    func addFromTrending(sender:UIButton) {
        
        
        
        
        print(sender.tag)
        
        
        
        let locationSt = trendingArray.objectAtIndex(sender.tag).valueForKey("country") as? String ?? ""
        
        if arrayOfIntrest .valueForKey("location").containsObject(locationSt) {
            
                CommonFunctionsClass.sharedInstance().alertViewOpen("Already selected", viewController: self)
            
            
            
            
            
        }
            
        else
        {
        
        
        if arrayOfIntrest.count<5 {
            
            
            
            
            var dic = NSMutableDictionary()
            dic = ["location":locationSt,"lat": "0.0", "long": "0.0", "type": "country", "country": locationSt, "delete":false]
            
            self.arrayOfIntrest .addObject(dic)
            print(self.arrayOfIntrest)
            self.textField.text=""
            deleteBool=false
            
            
            
            
            //manage the index to be show in feed screen
            selectedindxSearch=self.arrayOfIntrest.count-1
            
            
          
            
            
            
            
            self.nextPageAction(self)
            //self .adjustHeightOftableView()
        }
        else{
            CommonFunctionsClass.sharedInstance().alertViewOpen("Max of five places can be added!", viewController: self)
            }

        
        }
        
        
        
    }
    
    
    
    
    
        
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        NSURLCache.sharedURLCache().removeAllCachedResponses()

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



////////////////-------- inherit tableView cell class

class locationsCell: UITableViewCell {
    
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var markerImage: UIImageView!
    
    
}




