//
//  intrestViewController.swift
//  PYT
//
//  Created by Niteesh on 04/11/16.
//  Copyright © 2016 appsMaven. All rights reserved.
//

import UIKit
import HMSegmentedControl
import SDWebImage
import MBProgressHUD

class intrestViewController: UIViewController, apiClassInterestDelegate {

   //apiClassDelegate
    
    //top views
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var storyBtn: UIButton!
    @IBOutlet var segmentControl: HMSegmentedControl!
    
    
    @IBOutlet var tableOfIntrests: UITableView!
    @IBOutlet var categoryView: UIView!
    
    //Data Arrays
    var selectedLocation = NSString()
    var photosArray = NSMutableArray()
    var categorySelected = NSString()
    var appearBool = Bool() // For select category view
    var locationarray = NSMutableArray()
    var categoryArray = NSMutableArray()
    var multiplePhotosArray = NSMutableArray()
    var  longTapedView = UIView()
    
    
    var categId = NSMutableArray()
    var interestCase = Bool()
    
    
    //POPUP views for categories
    @IBOutlet var categorytableView: UITableView!
    var tagsArr:NSMutableArray = [] //
    var checked = NSMutableArray()
    var index1 = Int()
    var index2 = Int()
    
    
    
    @IBOutlet var bucketOutlet: UIButton!
    @IBOutlet var bucketCount: UILabel!
    @IBOutlet var storyCountLabel: UILabel!
    var storyBucketBool = Bool()
    
    @IBOutlet weak var addToBucketLblInPopup: UILabel!
    
    
    
    
    /////-----pop up view
    
    @IBOutlet var popUpView: UIView!
    
    @IBOutlet var addToStory: UIImageView!
    @IBOutlet var likeImage: UIImageView!
    @IBOutlet var addToBucket: UIImageView!
    @IBOutlet var addStoryLabelInPopup: UILabel!
    @IBOutlet var likeLabel: UILabel!
    
    @IBOutlet weak var deleteImage: UIImageView!
    @IBOutlet weak var deleteViewInDetail: UIView!
      @IBOutlet var deleteViewBottom: NSLayoutConstraint!
    
    
    
    var likeCount = NSMutableArray() //Array to temporary save the likes
    
    
    
    override func viewWillAppear(animated: Bool) {
        
        self.tabBarController?.tabBar.hidden = false
        
        
         apiClassInterest.sharedInstance().delegate=self
        
        bucketCount.layer.cornerRadius=bucketCount.frame.size.width/2
        bucketCount.clipsToBounds=true
        
        storyCountLabel.layer.cornerRadius=storyCountLabel.frame.size.width/2
        storyCountLabel.clipsToBounds=true
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let firstLaunch = defaults.boolForKey("refreshInterest")
        
        if firstLaunch {
            print("refresh")
            
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setBool(false, forKey: "refreshInterest")
            
            
            
            photosArray .removeAllObjects()
            multiplePhotosArray .removeAllObjects()
            tableOfIntrests .reloadData()
            
            
            //Header Text
            let headerText = NSUserDefaults.standardUserDefaults().valueForKey("selectedLocation") as? String ?? ""
            
            
            
            self.categoryView.layer.cornerRadius=1
            self.categoryView.clipsToBounds=true
            
            let doneBtn = self.categoryView.viewWithTag(555) as! UIButton
            doneBtn.layer.cornerRadius=doneBtn.frame.size.height/2
            doneBtn.clipsToBounds=true
            
            // apiClass.sharedInstance().delegate=self //delegate for response api
            
            
            
            
            let name = defaults.stringForKey("userLoginId")
            if name==nil
            {
                // print("DONE")
                
                self.tabBarController?.tabBar.hidden = true
                
                let nxtObj = self.storyboard?.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.navigationController! .pushViewController(nxtObj, animated: true)
                    self.dismissViewControllerAnimated(true, completion: {})
                })
                
                
                //            let defaults = NSUserDefaults.standardUserDefaults()
                //            defaults.setObject("", forKey: "faceBookAccessToken")
                //            defaults.setObject("", forKey: "instagramAccessToken")
                //            defaults.setObject("logo", forKey: "userProfilePic")
                //            defaults.setObject("PYT", forKey: "userName")
                
            }
                //if user is logged in
            else
            {
                
                 self.tabBarController?.tabBar.hidden = false
                
                /////////-------- already selected categories ------/////////
                checked = defaults.mutableArrayValueForKey("Interests")
                categId = defaults.mutableArrayValueForKey("IntrestsId")
                
                tagsArr = defaults.mutableArrayValueForKey("categoriesFromWeb")
                //defaults .setValue(nil, forKey: "Interests")
                
                if checked.count<1 {
                    
                    if tagsArr.count<1 {
                        
                         apiClass.sharedInstance().postRequestCategories("", viewController: self)
                        
                        
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), {() -> Void in
                          self.categorytableView.reloadData()
                            
                        })
                        
                        //if not then login from facebook
                        
                        
                    }
                    else{
                        self.categoryBtnAction(self)
                    }
                }
                    
                else{
                    
                    categoryView.hidden=true
                    tableOfIntrests.userInteractionEnabled=true
                    segmentControl.userInteractionEnabled=true
                    if appearBool==false {
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                            loadingNotification.mode = MBProgressHUDMode.Indeterminate
                            loadingNotification.label.text = "Fetching Feeds"
                            
                            //hit api to get the data from the web
                            let strarr = self.categId .componentsJoinedByString(",")
                            let type = NSUserDefaults.standardUserDefaults().valueForKey("selectedLocationType") as? String ?? ""
                            
                            let defaults = NSUserDefaults.standardUserDefaults()
                            let uId = defaults .stringForKey("userLoginId")
                            
                            let parameterString = "userId=\(uId!)&placeName=\(headerText)&placeType=\(type)&category=\(strarr)"//testing
                            print(parameterString)
                            self.interestCase=true
                            
                            //hit the api for shorted interests from web
                            
                            apiClassInterest.sharedInstance().postRequestInterestWiseData(parameterString, viewController: self)
                            self.segMentManage()
                            
                        })
                    }
                    appearBool=false
                }
                
                
                
                
               
                
                //self .shortData(tabledata)
                
                
                
            }
            
            
 headerLabel.text=headerText
            
            
            
            
            
            
        }
        else{
            
            print(" not refresh the intrests")
            
        }
        
            
            
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), {() -> Void in
            
            print(countArray)
            
            self.storyCountLabel.text="0"
            
            
            if countArray.objectForKey("storyCount") != nil {
                if let stCount = countArray.valueForKey("storyCount"){
                    
                    self.storyCountLabel.text=String(stCount)
                }
                
            }
            
            
            if countArray.objectForKey("bucketCount") != nil {
                if let bktCount = countArray.valueForKey("bucketCount"){
                    
                    bucketListTotalCount=String(bktCount)
                }
                
            }
            
            self.bucketCount.text=bucketListTotalCount
            
            
            
            
            
            
        })
        
        
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
    
    
    
    
    
    
    
    //MARK:reload from another class(detailview class)
    //MARK:-
    
    func loadInterest(notification: NSNotification){
        //load data here
        
       // print(likeCount.lastObject)
        
        self.tableOfIntrests .reloadData()
        
        
    }
    
    
    
    func loadCount(notification: NSNotification){
        //load data here
        
        self.storyCountLabel.text="0"
       
        if countArray.objectForKey("storyCount") != nil {
            if let stCount = countArray.valueForKey("storyCount"){
                
                self.storyCountLabel.text=String(stCount)
            }
            
        }
        
        
        if countArray.objectForKey("bucketCount") != nil {
            if let stCount = countArray.valueForKey("bucketCount"){
                
                bucketListTotalCount=String(stCount)
            }
            
        }
        
        
        self.bucketCount.text=bucketListTotalCount
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden=true //hide the navigationBar

      
        
       
        
        
        tableOfIntrests.rowHeight=250
        
        
        
        
        
        
        likeCount .removeAllObjects() // clear the liked
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(intrestViewController.loadInterest(_:)),name:"loadInterest", object: nil)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(intrestViewController.loadCount(_:)),name:"loadCount", object: nil)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(intrestViewController.loadDeletedCell(_:)),name:"loadDeleteInterest", object: nil)
        
        
    }

    
    
    
    
    
   
    func loadDeletedCell(notification: NSNotification) {
        
        
        
        self .deletImageManage()
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    //MARK:- Manage the segment control
     func segmentedControlChangedValue(segmentedControl: HMSegmentedControl) {
    
        print(segmentedControl.selectedSegmentIndex)
        
        categorySelected = checked .objectAtIndex(segmentControl.selectedSegmentIndex) as! NSString
        print(categorySelected)
        
      
        self .shortData(self.locationarray)
    
        
        
    }

    
    
    func segMentManage() -> Void {
        
        /////segmentControl
        var arrayInt = NSMutableArray()
        arrayInt = ["Musium", "Hotel"]
        var tabledata2 = NSArray()
        
        if checked.count<1 {
            tabledata2 = arrayInt as NSArray
        }
        else{
            tabledata2 = checked as NSArray
            
        }
        
        let viewWidth = CGRectGetWidth(self.view.frame);
        let title2 = tabledata2
        
        
        segmentControl.sectionTitles = title2 as! [String]
        segmentControl.autoresizingMask = [.FlexibleRightMargin, .FlexibleWidth]
        segmentControl.frame = CGRectMake(0, 65, viewWidth, 30)
        segmentControl.segmentEdgeInset = UIEdgeInsetsMake(0, 6, 0, 10)
        segmentControl.selectionStyle = HMSegmentedControlSelectionStyle.FullWidthStripe
        segmentControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocation.Down
        
        segmentControl.selectionIndicatorColor = UIColor(red: 157/255, green: 194/255, blue: 134/255, alpha: 1.0)
        segmentControl.selectionIndicatorHeight=3.0
        segmentControl.verticalDividerEnabled = true
        segmentControl.verticalDividerColor = UIColor.clearColor()
        segmentControl.verticalDividerWidth = 0.8
        segmentControl.backgroundColor = UIColor .clearColor()
        
        let selectedAttributes: NSDictionary = [
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "Roboto-Bold", size: 16)!
        ]
        
        
        let segAttributes: NSDictionary = [
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name:"Roboto-Regular", size: 15.0)!
        ]
        
        
        segmentControl .selectedTitleTextAttributes = selectedAttributes as [NSObject : AnyObject]
        segmentControl .titleTextAttributes = segAttributes as [NSObject : AnyObject]
        
        categorySelected = checked.objectAtIndex(0) as! NSString
        segmentControl.setSelectedSegmentIndex(0, animated: true)
        segmentControl.addTarget(self, action: #selector(self.segmentedControlChangedValue), forControlEvents: .ValueChanged)
        
        
    }
    
    
    
    
    //MARK:- Btn Actions
    
    @IBAction func doneAction(sender: AnyObject) {
   
        if checked.count<1 {
            CommonFunctionsClass.sharedInstance().alertViewOpen("Please select some of your intrests!", viewController: self)
        }
        else
        {
        let defaults = NSUserDefaults.standardUserDefaults()
            defaults .setValue(checked, forKey: "Interests")
            defaults .setValue(categId, forKey: "IntrestsId")

          
            
            
            UIView.animateWithDuration(0.4, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {() -> Void in
                self.categoryView.frame = CGRectMake(0, self.view.bounds.height, self.view.bounds.width, self.view.bounds.height )
                }, completion: {(finished: Bool) -> Void in
                     self.categoryView.hidden=true
            })
            
           
            
            
            
            
            
            
            
            tableOfIntrests.userInteractionEnabled=true
            segmentControl.userInteractionEnabled=true
            
         //   print(checked)
            
            
            
             dispatch_async(dispatch_get_main_queue(), {
                
                
                //10153101414156609
                
                
                let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                loadingNotification.mode = MBProgressHUDMode.Indeterminate
                loadingNotification.label.text = "Fetching Feeds"
                
             let strarr = self.categId .componentsJoinedByString(",")
                
                let defaults = NSUserDefaults.standardUserDefaults()
                let uId = defaults .stringForKey("userLoginId")
                
                let parameterString = "userId=\(uId!)&interest=\(strarr)"
                //let parameterString = "userId=106337066460748&placeName=kohsamui&placeType=city&category=\(strarr)"//testing
                print(parameterString)
                apiClassInterest.sharedInstance().postRequestInterest(parameterString, viewController: self)
                
                
                
                
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    //hit api to get the data from the web
                    let strarr2 = self.categId .componentsJoinedByString(",")
                    //  let parameterString = "userId=10153101414156609&interest=\(strarr)"
                    
                    let headerText = NSUserDefaults.standardUserDefaults().valueForKey("selectedLocation") as? String ?? ""
                    
                    let headerType = NSUserDefaults.standardUserDefaults().valueForKey("selectedLocationType") as? String ?? ""
                    
                    let parameterString2 = "userId=\(uId!)&placeName=\(headerText)&placeType=\(headerType)&category=\(strarr2)"//testing
                    print(parameterString2)
                    self.interestCase=true
                    //get the shorted data from the api
                   

                    apiClassInterest.sharedInstance().postRequestInterestWiseData(parameterString2, viewController: self)
                    
                })

            
                
            self .segMentManage()
           // self .shortData(self.tabledata)
            })
            
            
        }
        
    }
    
    
    //open the popup view of categories
    
    @IBAction func categoryBtnAction(sender: AnyObject) {
       
        
//        
//        categoryView.hidden=false
//        let popUpView = categoryView
//        let centre : CGPoint = CGPoint(x: self.view.center.x, y: self.view.center.y)
//        
//        popUpView.center = centre
//        popUpView.layer.cornerRadius = 10.0
//        let trans = CGAffineTransformScale(popUpView.transform, 0.01, 0.01)
//        popUpView.transform = trans
//        self.view .addSubview(popUpView)
//        UIView .animateWithDuration(0.5, delay: 0.0, options:     UIViewAnimationOptions.CurveEaseInOut, animations: {
//            
//            popUpView.transform = CGAffineTransformScale(popUpView.transform, 100.0, 100.0)
//            
//            }, completion: {
//                (value: Bool) in
//                
//        })

        self.categoryView.frame = CGRectMake(0, self.view.bounds.height, self.view.bounds.width, self.view.bounds.height )
        self.categoryView.hidden=false
        
        UIView.animateWithDuration(0.4, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {() -> Void in
            self.categoryView.frame = CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height )
            }, completion: {(finished: Bool) -> Void in
        })
        
        
        
        self.categorytableView.reloadData()
        tableOfIntrests.userInteractionEnabled=false
        segmentControl.userInteractionEnabled=false
        
    
    }
    
   
    
    
    
    ///////////-------- Stoy Action----//////
    
    @IBAction func storyBtnAction(sender: AnyObject) {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(false, forKey: "refreshInterest")
        
        
        let nxtObj = self.storyboard?.instantiateViewControllerWithIdentifier("storyViewcontrollerViewController") as! storyViewcontrollerViewController
        
        dispatch_async(dispatch_get_main_queue(), {
            self.navigationController! .pushViewController(nxtObj, animated: true)
            nxtObj.hidesBottomBarWhenPushed = true
        })
        
    }
    
    
    //////// Bucket button action
    
    
    @IBAction func bucketAction(sender: AnyObject) {
  let nxtObj = self.storyboard?.instantiateViewControllerWithIdentifier("BucketListViewController") as! BucketListViewController
        
        self.navigationController! .pushViewController(nxtObj, animated: true)
        nxtObj.hidesBottomBarWhenPushed = true
        
    
        
    }
    
    
    
    
    
    
    
    
    
    //MARK: DataSource and delegate of tableView
    //MARK:-
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView==categorytableView {
            return tagsArr.count
        }
            
        else{
            
            if photosArray.count<1 {
                return 0
            }
            else
            {
                return photosArray.count
            }
        
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        if tableView == categorytableView {
            let cell = tableView.dequeueReusableCellWithIdentifier("CategoriesCell") as! CategoriesCell
            cell.name.text = tagsArr .objectAtIndex(indexPath.row).valueForKey("name") as? String
            
            
            
           
            
            
            //iconImage
            
            cell.checkMark.layer.cornerRadius=cell.checkMark.frame.size.width/2
            cell.checkMark.clipsToBounds=true
            
            
            if checked .containsObject(tagsArr .objectAtIndex(indexPath.row).valueForKey("name") as! String)
            {
                
                cell.checkMark.image=UIImage (named: "searchSelect")
                cell.checkMark.backgroundColor = UIColor .clearColor()
                
            }
            else
            {
                cell.checkMark.backgroundColor=UIColor .clearColor()
                cell.checkMark.image = UIImage (named: "searchUnselect")
            }
            
            return cell
        }
            
            
        else
        {
        let cell:IntrestTableViewCell = tableView.dequeueReusableCellWithIdentifier("intrestCell") as! IntrestTableViewCell
            
            
            cell.clock.layer.cornerRadius=12
            cell.clock.clipsToBounds=true
        
        cell.museumNameLabel.text=photosArray.objectAtIndex(indexPath.row).valueForKey("placeTag") as? String ?? ""
            cell.beenThereLabel.text=photosArray.objectAtIndex(indexPath.row).valueForKey("name") as? String ?? ""
           
            let locationCity = "\(photosArray.objectAtIndex(indexPath.row).valueForKey("city") as? String ?? "")"
            
            //let locationCountry = "\(photosArray.objectAtIndex(indexPath.row).valueForKey("country") as? String ?? "")"
            
        
            
            
            
            ////Attributed string---///
            let segAttributes: NSDictionary = [
                NSForegroundColorAttributeName: UIColor.darkGrayColor(),
                NSFontAttributeName: UIFont(name:"Roboto-Light", size: 12.0)!
            ]
            
            let segAttributes2: NSDictionary = [
                NSForegroundColorAttributeName: UIColor.blackColor(),
                NSFontAttributeName: UIFont(name:"Roboto-Medium", size: 14.0)!
            ]
            
            let attributedString1 = NSMutableAttributedString(string:"Location: ", attributes:segAttributes as? [String : AnyObject])
            
            let attributedString2 = NSMutableAttributedString(string:locationCity, attributes:segAttributes2 as? [String : AnyObject])

            attributedString1.appendAttributedString(attributedString2)
            cell.locationLabel.attributedText = attributedString1
            
            
            
            
            
//            cell.locationLabel.hidden=false
//            cell.beenThereLabel.hidden=false
//            
//            
            let museumImage = photosArray.objectAtIndex(indexPath.row).valueForKey("imageStandard")!//("imageLarge")!
             let url2 = NSURL(string: museumImage as! String)
            
            
          //  let museumName = photosArray.objectAtIndex(indexPath.row).valueForKey("")
            
            let pImage : UIImage = UIImage(named:"backgroundImage")! //placeholder image
  
            
            
            
            let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in
                
            
            }
            
//            //completion block of the sdwebimageview
            cell.museumImage.sd_setImageWithURL(url2, placeholderImage: pImage, completed: block)
            
            //cell.layer.cornerRadius=5
            cell.clipsToBounds=true
            
         
             cell.tag=1000*self.segmentControl.selectedSegmentIndex+indexPath.row
            
            let longView = UIView()
            longView.frame=cell.frame
            longView.tag=1000*self.segmentControl.selectedSegmentIndex+indexPath.row
            //cell .addSubview(longView)
            
            
            let longTapGest = UILongPressGestureRecognizer(target: self, action: #selector(intrestViewController.longTap(_:)))
            
            cell.addGestureRecognizer(longTapGest)

            
            
            
            
            
            
            //MARK:  ////////// MANAGE LIKE AND ITS COUNT////////
            var countLik = NSNumber()
            //MANAGE from the crash
          
            if self.photosArray.objectAtIndex(indexPath.row).valueForKey("count") != nil
            {
                countLik = self.photosArray.objectAtIndex(indexPath.row).valueForKey("count") as! NSNumber
            }
            else
            {
                countLik=0
            }
            
            
            
            
            let likeimg = cell.viewWithTag(7477) as! UIImageView
            let likecountlbl = cell.viewWithTag(7478) as! UILabel
            let defaults = NSUserDefaults.standardUserDefaults()
            let uId = defaults .stringForKey("userLoginId")
            
            let imageId2 = photosArray[indexPath.row] .valueForKey("id") as? String ?? " "
            
           var likedByMe2 = NSArray()
            
           // print(self.photosArray .objectAtIndex(indexPath.row).valueForKey("userLiked"))
            
            if self.photosArray .objectAtIndex(indexPath.row).valueForKey("userLiked") != nil { // as? NSNull != NSNull(){
                
                likedByMe2 = self.photosArray[indexPath.row].valueForKey("userLiked") as! NSArray
                
            }
           
            
            //SHOW THE COUNT OF LIKED
            likecountlbl.text=String(countLik)
            likeimg.image=UIImage (named: "like_count")
            
            
            ///////-  Show liked by me-/////
            if likedByMe2.count>0
            {
                if likedByMe2.containsObject(uId!)
                {
                    
                    
                    if likeCount.valueForKey("imageId").containsObject(imageId2) {
                        
                        let indexOfImageId = likeCount.valueForKey("imageId") .indexOfObject(imageId2)
                        
                        if likeCount.objectAtIndex(indexOfImageId) .valueForKey("like") as! Bool == true {
                            likeimg.image=UIImage (named: "likedCount")
                            let staticCount = likeCount.objectAtIndex(indexOfImageId).valueForKey("count") as? NSNumber
                            likecountlbl.text=String(staticCount!)// String(self.addTheLikes(staticCount!))
                            
                            
                            
                        }
                        else{
                            likeimg.image=UIImage (named: "like_count")
                            let staticCount = likeCount.objectAtIndex(indexOfImageId).valueForKey("count") as? NSNumber
                            likecountlbl.text=String(staticCount!) //(self.addTheLikes(staticCount!))
                        }
                    }
                        
                        //if not contains the imageId
                    else
                    {
                        likeCount .addObject(["imageId":imageId2,"userId":uId!, "like": true, "count": countLik])
                        print(likeCount)
                        likecountlbl.text=String(countLik)
                        likeimg.image=UIImage (named: "likedCount")
                    }
                    
                    
                    
                }
                    
                else
                {
                    
                    
                        if likeCount.valueForKey("imageId").containsObject(imageId2) {
                            
                            let indexOfImageId = likeCount.valueForKey("imageId") .indexOfObject(imageId2)
                            
                            if likeCount.objectAtIndex(indexOfImageId) .valueForKey("like") as! Bool == true {
                                likeimg.image=UIImage (named: "likedCount")
                                let staticCount = likeCount.objectAtIndex(indexOfImageId).valueForKey("count") as? NSNumber
                                likecountlbl.text=String(staticCount!)
                                
                            }
                            else{
                                let staticCount = likeCount.objectAtIndex(indexOfImageId).valueForKey("count") as? NSNumber
                                likecountlbl.text=String(staticCount!)
                                likeimg.image=UIImage (named: "like_count")
                            }
                        }
                        
                        
                        
                    
                    
                    
                }
                
                
                
            }
            else{
                
                if likeCount.valueForKey("imageId").containsObject(imageId2) {
                    
                    let indexOfImageId = likeCount.valueForKey("imageId") .indexOfObject(imageId2)
                    
                    if likeCount.objectAtIndex(indexOfImageId) .valueForKey("like") as! Bool == true {
                        likeimg.image=UIImage (named: "likedCount")
                        let staticCount = likeCount.objectAtIndex(indexOfImageId).valueForKey("count") as? NSNumber
                        likecountlbl.text=String(staticCount!)
                        
                    }
                    else{
                        let staticCount = likeCount.objectAtIndex(indexOfImageId).valueForKey("count") as? NSNumber
                        likecountlbl.text=String(staticCount!)
                        likeimg.image=UIImage (named: "like_count")
                    }
                }
                
                
                
            }
            
            
            
            
            
            
            
            
            
            
            
            
        return cell
        }
    }
    
    
//    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
//        if(tableView == categorytableView)
//        {
//
//        }
//
//    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if tableView == categorytableView {
            
            
            
            
            if checked .containsObject(tagsArr .objectAtIndex(indexPath.row).valueForKey("name") as! String)
            {
                
                let objId = (tagsArr .objectAtIndex(indexPath.row).valueForKey("category_id") as? Int)
                
                let objectInt = (tagsArr .objectAtIndex(indexPath.row).valueForKey("name") as? String)
                checked .removeObject(objectInt!)
                categId .removeObject(objId!)
        
                
                
            } else
            {
//                let object = tagsArr .objectAtIndex(indexPath.row).valueForKey("name") as? String ?? ""
//                checked .addObject(object)
                
                let objId = (tagsArr .objectAtIndex(indexPath.row).valueForKey("category_id") as? Int)
                let objectInt = (tagsArr .objectAtIndex(indexPath.row).valueForKey("name") as? String)
                checked .addObject(objectInt!)
                categId .addObject(objId!)
                
                
                
            }
            
            
            categorytableView .reloadData()
            
            
            
        
        }
        
        
            
            //////
       
        else
        
        {
            
            print(photosArray[indexPath.row])
            
      
            let str = self.photosArray[indexPath.row] .valueForKey("description") as? String ?? "No Description Found"//description
            let profileImage = self.photosArray .objectAtIndex(indexPath.row) .valueForKey("profilePic")! as! NSString//profile image Link
         
    //////////////////////----------------Location----------------------------///////////////////
            var location = NSString()
            var sendgeoTag = self.photosArray[indexPath.row] .valueForKey("placeTag") as? String ?? " "
            
            var Location_name = ""
            let fullName22 = sendgeoTag
            let fullNameArr22 = fullName22.characters.split{$0 == ","}.map(String.init)
        
            if fullNameArr22.count>0 {
                  sendgeoTag = fullNameArr22[0]
            }
            
                
            var lat = NSNumber()
            var long = NSNumber()
            
            
            if self.photosArray.objectAtIndex(indexPath.row).valueForKey("latitude") != nil && self.photosArray.objectAtIndex(indexPath.row).valueForKey("latitude") as? NSNull != NSNull()   {
                
                lat = self.photosArray.objectAtIndex(indexPath.row).valueForKey("latitude") as! NSNumber  //as? String ?? "0.0"
                
                long = self.photosArray.objectAtIndex(indexPath.row).valueForKey("longitude") as! NSNumber //as? String ?? "0.0"
            }
            else
            {
                lat=0
                long=0
            }
            
            
            
            
            // remove the another part of string
            let changeStr:NSString = sendgeoTag
            let ddd = changeStr.stringByReplacingOccurrencesOfString("&", withString: " and ") //replace & with and
            sendgeoTag = ddd
            location = "\(self.captitalString(sendgeoTag as? String ?? "")), \(self.captitalString(self.photosArray.objectAtIndex(indexPath.row).valueForKey("city") as? String ?? "")), \(self.captitalString(self.photosArray.objectAtIndex(indexPath.row).valueForKey("country") as? String ?? ""))"
    
            
            var arrImg = NSString()
            arrImg = self.photosArray[indexPath.row].valueForKey("imageLarge") as? String ?? "" //locationSingleImage
            var arrImgStand = NSString()
            arrImgStand = self.photosArray[indexPath.row].valueForKey("imageStandard") as? String ?? "" // image standard
            print(arrImgStand)
            
            
             let name = self.photosArray .objectAtIndex(indexPath.row).valueForKey("name") as? String ?? " " //userName
            
            
            
            //MANAGE Source for images
            
            var sourceType = "Other"
            
            let Source = self.photosArray .objectAtIndex(indexPath.row).valueForKey("source") as? String ?? " " //userName
            if Source == "PYT" {
                
                
                sourceType = Source
                
            }
            
            
            
            
            
            
            let txt = headerLabel.text
            
            
             let multiImg: NSMutableArray = (multiplePhotosArray.objectAtIndex(indexPath.row) as? NSMutableArray)!
            //let multiImgStandard: NSMutableArray = (multiplePhotosArray.objectAtIndex(indexPath.row) as? NSMutableArray)!
            print(arrImgStand)
            
            let multiImgArr = NSMutableArray()
            let multiImgStandArr = NSMutableArray()
            
            for i in 0..<multiImg.count {
                let imgLinkStr = multiImg .objectAtIndex(i).valueForKey("imageLarge") as? String ?? ""
                let imgLinkStandard = multiImg .objectAtIndex(i).valueForKey("imageStandard") as? String ?? ""
                print("large===\(imgLinkStr)====== standard==\(imgLinkStandard)")
                
                if arrImg == imgLinkStr {
                    
                }
                else
                {
                    multiImgArr .addObject(imgLinkStr)
                    multiImgStandArr .addObject(imgLinkStandard)
                }
                
                
                
               
        }
            
            multiImgArr .insertObject(arrImg, atIndex: 0)
            multiImgStandArr .insertObject(arrImgStand, atIndex: 0)
            print(multiImgStandArr)
            
            let categoriesArray:NSArray = photosArray.objectAtIndex(indexPath.row).valueForKey("category") as! NSArray
            let countryName = photosArray.objectAtIndex(indexPath.row).valueForKey("country") as? String ?? ""
            var cityName = photosArray.objectAtIndex(indexPath.row).valueForKey("city") as? String ?? ""
            
            
            
            
            
            let arrayData = NSMutableArray()
            
            
            let strcat = categoriesArray.componentsJoinedByString(",")
            print(strcat)
            
            
            
            
            let imId = photosArray[indexPath.row].valueForKey("id") as? String ?? ""
            
            
            
            
            
            //Likes count
            
            var countLik = NSNumber()
            if photosArray[indexPath.row].valueForKey("count") != nil  {
                
                countLik = photosArray[indexPath.row].valueForKey("count") as! NSNumber  //as? String ?? "0.0"
                
                
            }else
            {
                countLik=0
                
            }
            
            
            
            let otherUserId = photosArray[indexPath.row].valueForKey("userId") as? String ?? ""
            
            var mutableDic = NSMutableDictionary()
            
            
            if cityName=="" {
                cityName=txt!
            }
            
            
            print("City Name=\(cityName)")
            
            
             if self.likeCount.count>0 {
             if self.likeCount.valueForKey("imageId") .containsObject(imId) {
             
             let index = self.likeCount.valueForKey("imageId").indexOfObject(imId)
             
             if self.likeCount.objectAtIndex(index).valueForKey("like") as! Bool == true {
             
             mutableDic = ["Description":str, "profileImage": profileImage, "location": location, "locationImage": arrImg, "Venue": cityName, "CountryName": countryName, "geoTag": sendgeoTag,"imageId":imId ,"latitude":lat, "longitude":long, "userName":name, "Type": sourceType, "multipleImagesLarge": multiImgArr, "Category": strcat, "likeBool":true, "otherUserId":otherUserId, "likeCount":countLik, "cityName": cityName, "standardImage":arrImgStand, "multipleImagesStandard": multiImgStandArr]
             
             arrayData .addObject(mutableDic)
             }
                
             
             else
             {
                
                mutableDic = ["Description":str, "profileImage": profileImage, "location": location, "locationImage": arrImg, "Venue": cityName, "CountryName": countryName, "geoTag": sendgeoTag,"imageId":imId ,"latitude":lat, "longitude":long, "userName":name, "Type": sourceType, "multipleImagesLarge": multiImgArr, "Category": strcat, "likeBool":false, "otherUserId":otherUserId, "likeCount":countLik, "cityName": cityName, "standardImage":arrImgStand, "multipleImagesStandard": multiImgStandArr]
                
                arrayData .addObject(mutableDic)
                
                
                }
                
             
             }
             else
             {
             mutableDic = ["Description":str, "profileImage": profileImage, "location": location, "locationImage": arrImg, "Venue": cityName, "CountryName": countryName, "geoTag": sendgeoTag,"imageId":imId ,"latitude":lat, "longitude":long, "userName":name, "Type": sourceType, "multipleImagesLarge": multiImgArr, "Category": strcat, "likeBool":false, "otherUserId":otherUserId, "likeCount":countLik, "cityName": cityName, "standardImage":arrImgStand, "multipleImagesStandard": multiImgStandArr]
             
             arrayData .addObject(mutableDic)
             }
             
             }
             else
             {
             mutableDic = ["Description":str, "profileImage": profileImage, "location": location, "locationImage": arrImg, "Venue": cityName, "CountryName": countryName, "geoTag": sendgeoTag,"imageId":imId ,"latitude":lat, "longitude":long, "userName":name, "Type": sourceType, "multipleImagesLarge": multiImgArr, "Category": strcat, "likeBool":false, "otherUserId":otherUserId, "likeCount":countLik, "cityName": cityName, "standardImage":arrImgStand, "multipleImagesStandard": multiImgStandArr]
             
             arrayData .addObject(mutableDic)
             
            }
            
            
            
            //print(arrayData)
            
            /*
            arrayData .addObject(["Description":str, "profileImage": profileImage, "location": location, "locationImage": arrImg, "Venue": txt!, "CountryName": countryName, "geoTag": sendgeoTag,"imageId":imId ,"latitude":0, "longitude":0, "userName":name, "Type": "Other", "multipleImages": multiImgArr, "Category": strcat])
            
 */
 
            let nxtObj2 = self.storyboard?.instantiateViewControllerWithIdentifier("detailViewController") as! detailViewController
            nxtObj2.arrayWithData=arrayData
            nxtObj2.fromStory=false
            nxtObj2.countLikes=likeCount
            nxtObj2.fromInterest = true
            
            dispatch_async(dispatch_get_main_queue(), {
            
                    self.navigationController! .pushViewController(nxtObj2, animated: true)
                    self.appearBool=true
                })
            
            
        }

   
            
    }

    
    
    
    
    
    func captitalString(nameString:NSString) -> String {
        
        var nameString2 = nameString
        nameString2 = nameString.capitalizedString
        return nameString2 as String
        
    }
    
    
    
    
    
    
   
    
    
    
    
    
    
    /////////////////////////////////////////////////////////////////////////
    //MARK:- Function to short the data with categories
    //MARK:- 
    
    func shortData(dataArray: NSMutableArray) -> Void {
        
        let index = self.segmentControl.selectedSegmentIndex
        
      
        photosArray .removeAllObjects()
        multiplePhotosArray .removeAllObjects()
        tableOfIntrests .reloadData()
        
        let selectedText = checked.objectAtIndex(index) as? String
        
        if categoryArray .containsObject(selectedText!) {
           
            
            let index2 = categoryArray.indexOfObject(selectedText!)
            
            
            
            let userArray = NSMutableArray()
            let st: AnyObject? = dataArray.objectAtIndex(index2)
            
            
            
            
            
            if st is NSArray {
                // obj is a string array. Do something with stringArray
                print("array")
                
                
               
                
                userArray .addObject((dataArray .objectAtIndex(index2) as? NSArray)!)
                // print(userArray.objectAtIndex(0))
                
                if userArray[0].count<1 {
                    
                    CommonFunctionsClass.sharedInstance().alertViewOpen("No content found", viewController: self)
                    
                    
                }
                else{
                    
                    
                    
                    for i in 0..<userArray[0].count {
                        
                        //print(userArray[0] .objectAtIndex(0).valueForKey("users") as! NSArray)
                        
                        let userImagesArr = NSMutableArray()
                        
                        userImagesArr .addObject(userArray[0] .objectAtIndex(i).valueForKey("users") as! NSArray)
                        
                        for j in 0..<userImagesArr[0].count {
                            
                            // print(userImagesArr[0] .objectAtIndex(j).valueForKey("images"))
                            
                            let arr = NSMutableArray()
                            arr .addObject ((userImagesArr[0].objectAtIndex(j).valueForKey("images")?.objectAtIndex(0))!)
                            // print(arr)
                            
                            photosArray .addObject((userImagesArr[0].objectAtIndex(j).valueForKey("images")?.objectAtIndex(0))!)
                            
                            let multImgArr:NSArray = userImagesArr[0] .objectAtIndex(j).valueForKey("images") as! NSArray
                            
                            multiplePhotosArray .addObject(multImgArr)
                            
                           // print("multiImages array=====\(multiplePhotosArray)")
                            //print("multiImages array count=====\(multiplePhotosArray.count)")
                            
                        }
                        
                        
                        
                    }
                    self.tableOfIntrests .reloadData()
                    
                    
                    
                }
                
                
                
            }
                
            else {
                print("not array")
                photosArray.removeAllObjects()
                CommonFunctionsClass.sharedInstance().alertViewOpen("No content found", viewController: self)
                tableOfIntrests .reloadData()
                // obj is not a string array
            }
            

            
            
            
        }
        
        else
        {
            
        }
        
        
        
        tableOfIntrests.contentOffset.y=0
        
        
        
        
    }
    
  
    
    
    
    
    
    
    
    
    
    //MARK:- Response from the interest API
    //MARK:-
    
    func serverResponseArrivedInterest(Response:AnyObject)
    {
        
        
        
        //////////---------- REsponse for the add and interest database-----------////////
        
        if interestCase==true {
            
            jsonMutableArray = NSMutableArray()
            jsonMutableArray = Response as! NSMutableArray
            
            photosArray .removeAllObjects()
            categoryArray .removeAllObjects()
            locationarray .removeAllObjects()
            //print(jsonMutableArray)
            likeCount .removeAllObjects()
            
            for i in 0..<jsonMutableArray.count {
                
               // print(jsonMutableArray[i])
                //print(jsonMutableArray[i].valueForKey("data"))
                
                let inter = jsonMutableArray[i].valueForKey("interest") as? String ?? ""
                
                categoryArray .addObject(inter)
                
                var dataOfLocations = NSMutableArray()
                
                dataOfLocations = jsonMutableArray[i] .valueForKey("data") as! NSMutableArray
                
                //print(dataOfLocations.count)
                
                if dataOfLocations.count>0 {
                    
                    
                    locationarray .addObject(dataOfLocations)//as Array)
                    
                    print(locationarray.count)
                    
//                    for j in 0..<dataOfLocations.count {
//                       
//                        print(dataOfLocations.objectAtIndex(j))
//                        
//                        //var userIdArray = NSMutableArray()
//                      //  userIdArray = dataOfLocations[j].valueForKey("data") as! NSMutableArray
//                        locationarray .addObject(dataOfLocations.objectAtIndex(j))
//                        
//                    }
                    
                   
                    
                    
                    
                    
                    
                    /*
                    
                    for j in 0..<dataOfLocations.count {
                        
                        print(dataOfLocations[j].valueForKey("_id")) //location in the place
                        
                        
                        var userIdArray = NSMutableArray()
                      userIdArray = dataOfLocations[j].valueForKey("userIds") as! NSMutableArray
                        
                        let totalPhoto = dataOfLocations[j].valueForKey("users") as! NSArray
                        
                      print(totalPhoto.count)
                        
                        
                        for k in 0..<totalPhoto.count {
                            
                            let multiuserPhoto = totalPhoto.objectAtIndex(k).valueForKey("images") as! NSArray
                                locationarray .addObject(multiuserPhoto)
                            
                            }
                        
                            
                        }
                    */
                        
                    
                        
                    }
                else{
                    
                    locationarray .addObject("")
                }
                    
                
                    
                }
            
            
            
            
                 self .shortData(locationarray)
                
                
            
            
                
            }
            
        
        
             MBProgressHUD.hideHUDForView(self.view, animated: true)
            
        }
        
      
        
        
       
    
    
    
    
    
    
    //////////-------Long Tap gesture------//////
    //MARK:- Long Tap
    //MARK:-
    
    func longTap(sender: UILongPressGestureRecognizer)-> Void {
        
        headerLabel.text=NSUserDefaults.standardUserDefaults().valueForKey("selectedLocation") as? String ?? ""
        
        if sender.state == .Began
        {
            
            let a:Int? = (sender.view?.tag)! / 1000
            let b:Int? = (sender.view?.tag)! % 1000
            
            
            
            index1 = a!
            index2 = b!
            
             longTapedView=sender.view!
            
            
            let imageId = self.photosArray.objectAtIndex(index2).valueForKey("id") as? String ?? ""
            let defaults = NSUserDefaults.standardUserDefaults()
            let uId = defaults .stringForKey("userLoginId")
            
            
             if countArray.objectForKey("storyImages") != nil  {
                
                let countst = countArray.valueForKey("storyImages") as! NSArray
                addStoryLabelInPopup.text="Add To Story"
                addToStory.image=UIImage (named: "selectionStory")
                
                if countst.count>0 {
                    
                    print(countst)
                    if countst.containsObject(imageId) {
                        
                        addStoryLabelInPopup.text="Remove From Story"
                        addToStory.image=UIImage (named: "removeStory")
                        
                    }
                    
                    
                }
            }
        
            
            
            
            ///Bucket manage
            
            if countArray.objectForKey("bucketImages") != nil  {
                
                let countst = countArray.valueForKey("bucketImages") as! NSArray
                addToBucketLblInPopup.text="Add To Bucket List"
                addToBucket.userInteractionEnabled=true
                
                if countst.count>0 {
                    
                    print(countst)
                    if countst.containsObject(imageId) {
                        
                        addToBucketLblInPopup.text="Bucketed"
                       addToBucket.userInteractionEnabled=false
                        
                        
                        
                    }
                    
                    
                }
            }
            
           
            
            
            
            
            //MANAGE Delete Image icon
            let source = self.photosArray.objectAtIndex(index2).valueForKey("source") as? String ?? ""
            print("Source ----\(source)")
            deleteViewBottom.constant = -(deleteViewInDetail.frame.size.height)
            deleteViewInDetail.hidden=true
            
            
            
            
            if source != NSNull() || source != ""  {
                
                
               
                if source == "PYT" {
                    
                  
                    
                    if self.photosArray.objectAtIndex(index2).valueForKey("userId") as? String == uId! {
                        
                        print("Enter if match the user id")
                        
                        if deleteViewBottom.constant<9
                        {
                            deleteViewBottom.constant = 9
                            deleteViewInDetail.hidden=false
                        }
                        
                        
                        
                    }
                    
                    
                    
                    
                    
                    ///can delete
                    
                }
                
                
            }
            
            
            
            
            
            
            
            ///Like manage
            
            likeLabel.text="Like"
            likeImage.image=UIImage (named: "selectionLike")
            
            if likeCount.valueForKey("imageId") .containsObject(imageId) {
                let index = self.likeCount.valueForKey("imageId").indexOfObject(imageId)
                if self.likeCount.objectAtIndex(index).valueForKey("like") as! Bool == true {
                    likeLabel.text="Unlike"
                    likeImage.image=UIImage (named: "unlikeSelection")
                }
                
                
            }

          
            
            self.detailSelectBtnAction(true)
        }
        
    }
    
        
        
        
    func tabBarController(aTabBar: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        //        if !self.hasValidLogin() && (viewController != aTabBar.viewControllers[0]) {
        //            // Disable all but the first tab.
        //            return false
        //        }
        
        
        print("---------------Its comes here------------------")
        return true
    }
    
    
    
    func detailSelectBtnAction(showView:Bool) -> Void
    {
        
        
        //// hide the view
        if showView==false {
            
            self.tabBarController?.tabBar.hidden = false
            
            self.popUpView.hidden = true
            
            let popUpView2 = popUpView
            //let centre : CGPoint = CGPoint(x: self.view.center.x, y: self.view.center.y)
            let centre : CGPoint = CGPoint(x: (self.tabBarController?.view.center.x)!, y: (self.tabBarController?.view.center.y)!)
            
            popUpView2.center = centre
            popUpView2.layer.cornerRadius = 0.0
            let trans = CGAffineTransformScale(popUpView2.transform, 1.0, 1.0)
            popUpView2.transform = trans
            self.view .addSubview(popUpView2)
            UIView .animateWithDuration(0.3, delay: 0.0, options:     UIViewAnimationOptions.CurveEaseInOut, animations: {
                
                popUpView2.transform = CGAffineTransformScale(popUpView2.transform, 0.1, 0.1)
                
                
                }, completion: {
                    (value: Bool) in
                    //popUpView .removeFromSuperview()
                    
                    
                    popUpView2.transform = CGAffineTransformIdentity
            })
            
            
            
            //self.tabBarController?.tabBar.userInteractionEnabled=true
           
            
            
        }
            
            ////Show the View
        else
        {
                       
           print(self.tabBarController?.tabBar.frame)
            self.tabBarController?.view.backgroundColor=UIColor .blackColor()
            
            self.popUpView.hidden=false
            self.tabBarController?.tabBar.hidden = true
           
          
            
            let popUpView2 = popUpView
            let centre : CGPoint = CGPoint(x: self.view.center.x, y: self.view.center.y)
            
            // let centre : CGPoint = CGPoint(x: (self.tabBarController?.view.center.x)!, y: (self.tabBarController?.view.center.y)!)
            
            popUpView2.center = centre
            popUpView2.layer.cornerRadius = 0.0
            let trans = CGAffineTransformScale(popUpView2.transform, 0.01, 0.01)
            popUpView2.transform = trans
            self.view .addSubview(popUpView2)
            UIView .animateWithDuration(0.3, delay: 0.0, options:     UIViewAnimationOptions.CurveEaseInOut, animations: {
                
                popUpView2.transform = CGAffineTransformScale(popUpView2.transform, 100.0, 100.0)//CGAffineTransformIdentity
                
                }, completion: {
                    (value: Bool) in
                    
                   
                    
            })
            ///------first End----/////
            
            
            
            
            self.tabBarController?.view.bringSubviewToFront(popUpView)
            
            
            let tapGestureRecognizer = UITapGestureRecognizer()
            tapGestureRecognizer.addTarget(self, action: #selector(intrestViewController.tempFunc))
            
            popUpView.addGestureRecognizer(tapGestureRecognizer)
            
            
            
            let tapGestureRecognizer2 = UITapGestureRecognizer(target:self, action:#selector(intrestViewController.storyImageTapped))
            addToStory.userInteractionEnabled = true
            addToStory.addGestureRecognizer(tapGestureRecognizer2)
            
            self.popUpView.bringSubviewToFront(addToStory)
            
            
            
            let tapGestureRecognizer3 = UITapGestureRecognizer(target:self, action:#selector(intrestViewController.likeImageTapped))
            likeImage.userInteractionEnabled = true
            likeImage.addGestureRecognizer(tapGestureRecognizer3)
            
            self.popUpView.bringSubviewToFront(likeImage)
            
            
            
            let tapGestureRecognizer4 = UITapGestureRecognizer(target:self, action:#selector(intrestViewController.bucketImageTapped))
            addToBucket.userInteractionEnabled = true
            addToBucket.addGestureRecognizer(tapGestureRecognizer4)
            
            self.popUpView.bringSubviewToFront(addToBucket)
            
            
            
            let tapGestureRecognizer5 = UITapGestureRecognizer(target:self, action:#selector(intrestViewController.deleteImageTapped))
            deleteImage.userInteractionEnabled = true
            deleteImage.addGestureRecognizer(tapGestureRecognizer5)
            
            self.popUpView.bringSubviewToFront(deleteImage)
            
            
            
            
            //self.tabBarController?.tabBar.userInteractionEnabled=false
           // self.tabBarController?.tabBar.alpha = 0.6
            
        }
        
        
        
        
    }
    
    
    //MARK:- Tap gesture functions to manage the popup view
    
    ///Temp function to
    func tempFunc() -> Void {
        
        self .detailSelectBtnAction(false)
        
    }
    
    ///story image tapped
    func storyImageTapped()
    {
        // Your action
        
        storyBucketBool=true
        
        print("Story image tapped")
        
        //collectionIndex = b!
        // tableIndex = a!
        
        
        
        var imageName2 = NSString()
        var thumbnailImage = NSString()
        var imageId = NSString()
        var desc = NSString()
        var categ = NSString()
        var nameUser = NSString()
        var country = NSString()
        var lat = NSNumber()
        var long = NSNumber()
        var cityName = NSString()
        
        
        
        
        
        nameUser = self.photosArray.objectAtIndex(index2) .valueForKey("name") as? String ?? ""
        
        let geoTag = self.photosArray.objectAtIndex(index2) .valueForKey("placeTag") as? String ?? ""
        
        country = self.photosArray.objectAtIndex(index2) .valueForKey("country") as? String ?? ""
        
        //MANAGE from the crash
      
        //check if lat long are nil or nsnull
        if self.photosArray.objectAtIndex(index2).valueForKey("latitude") != nil && self.photosArray.objectAtIndex(index2).valueForKey("latitude") as? NSNull != NSNull()   {
            
            lat = self.photosArray.objectAtIndex(index2).valueForKey("latitude") as! NSNumber  //as? String ?? "0.0"
           
            long = self.photosArray.objectAtIndex(index2).valueForKey("longitude") as! NSNumber //as? String ?? "0.0"
        }
        else
        {
            lat=0
            long=0
        }
        
        
        
        //print(arrCategory)
        
        imageName2 = self.photosArray.objectAtIndex(index2).valueForKey("imageLarge") as? String ?? ""
        thumbnailImage = self.photosArray.objectAtIndex(index2).valueForKey("imageStandard") as? String ?? ""
        
        imageId = self.photosArray.objectAtIndex(index2).valueForKey("id") as? String ?? ""
        
        
        desc=""
        
        let catrr = self.photosArray.objectAtIndex(index2).valueForKey("category") as? NSMutableArray
        
        
        
        categ = catrr!.componentsJoinedByString(",")
        
        
        
        if self.photosArray.objectAtIndex(index2).valueForKey("location") as? NSNull != NSNull()  {
            
            cityName = self.photosArray.objectAtIndex(index2).valueForKey("city") as? String ?? ""
            
            
        }
        
        
                 //  apiClassStory.sharedInstance().postRequestDeleteStory(dataStr, viewController: self)
            
           cityName = self.photosArray.objectAtIndex(index2).valueForKey("city") as? String ?? ""
            
                     
            
            
        
        
        
            
            self.detailSelectBtnAction(true)
            
        
            
            let profileImage = self.photosArray.objectAtIndex(index2).valueForKey("profilePic")! as? NSString ?? ""
            
            let headerType = NSUserDefaults.standardUserDefaults().valueForKey("selectedLocationType") as? String ?? ""
            
            let defaults = NSUserDefaults.standardUserDefaults()
            let uId = defaults .stringForKey("userLoginId")
        
        
        
        var countst = NSNumber()
        
        countst = 0
        
        
        if countArray.valueForKey("storyCount") != nil
        {
            countst = countArray.valueForKey("storyCount") as! NSNumber
        }
        
        
        
        let sourceStr = self.photosArray.objectAtIndex(index2).valueForKey("source")! as? NSString ?? ""
       
        
    
        
        print(countst)
        let nxtObjMain = self.storyboard?.instantiateViewControllerWithIdentifier("mainHomeViewController") as! mainHomeViewController
        
        if addStoryLabelInPopup.text=="Add To Story" {
            
            //"imageThumb": imageThumbnail
            let dat: NSDictionary = ["userid": "\(uId!)", "id": imageId, "imageLink": imageName2, "location": headerLabel.text!, "source":"facebook", "latitude": lat, "longitude": long, "geoTag":geoTag, "category":categ,  "description":desc, "userName":nameUser,"type":"\(sourceStr)", "profileImage":profileImage, "cityName": cityName, "imageThumb": thumbnailImage ]
            
            
            
            
            print("Post parameters to select the images for story--- \(dat)")
             self.proceedBtnAction(self)
            //add image to story
            apiClass.sharedInstance().postRequestWithMultipleImage("", parameters: dat, viewController: self)
            storyCountLabel.text=String(nxtObjMain.addTheLikes(countst))
        }
            
        else
        {
            
            
            let dataStr = "userId=\(uId!)&imageId=\(imageId)&place=\(headerLabel.text!)&cityName=\(cityName)"
            
            print(dataStr)
            
            apiClassStory.sharedInstance().postRequestDeleteStory(dataStr, viewController: self)
            storyCountLabel.text=String(nxtObjMain.subtractTheLikes(countst))
            
        }
        
        
        self.tempFunc()
        
    
        
        
        
    }
    
    
    
    
    ///Like image tapped
    func likeImageTapped()
    {
   
        // Your action
        
        print("like image tapped")
        
        
        
        
        
        /*
         et str = self.photosArray[indexPath.row] .valueForKey("description") as? String ?? "No Description Found"//description
         let profileImage = self.photosArray .objectAtIndex(indexPath.row) .valueForKey("profilePic")! as! NSString//profile image Link
         
         //////////////////////----------------Location----------------------------///////////////////
         var location = NSString()
         var sendgeoTag = self.photosArray[indexPath.row] .valueForKey("placeTag") as? String ?? " "
         
         var Location_name = ""
         let fullName22 = sendgeoTag
         let fullNameArr22 = fullName22.characters.split{$0 == ","}.map(String.init)
         sendgeoTag = fullNameArr22[0]
         
         
         // remove the another part of string
         let changeStr:NSString = sendgeoTag
         let ddd = changeStr.stringByReplacingOccurrencesOfString("&", withString: " and ") //replace & with and
         sendgeoTag = ddd
         location = "\(self.captitalString(sendgeoTag as? String ?? "")), \(self.captitalString(self.photosArray.objectAtIndex(indexPath.row).valueForKey("city") as? String ?? "")), \(self.captitalString(self.photosArray.objectAtIndex(indexPath.row).valueForKey("country") as? String ?? ""))"
         
         
         var arrImg = NSString()
         arrImg = self.photosArray[indexPath.row].valueForKey("imageLarge") as? String ?? "" //locationSingleImage
         
         let name = self.photosArray .objectAtIndex(indexPath.row).valueForKey("name") as? String ?? " " //userName
         
         
         let txt = headerLabel.text
         
         
         let multiImg: NSMutableArray = (multiplePhotosArray.objectAtIndex(indexPath.row) as? NSMutableArray)!
         
         
         let multiImgArr = NSMutableArray()
         
         for i in 0..<multiImg.count {
         let imgLinkStr = multiImg .objectAtIndex(i).valueForKey("imageLarge") as? String ?? ""
         
         
         multiImgArr .addObject(imgLinkStr)
         }
         
         multiImgArr .insertObject(arrImg, atIndex: 0)
         
         let categoriesArray:NSArray = photosArray.objectAtIndex(indexPath.row).valueForKey("category") as! NSArray
         let countryName = photosArray.objectAtIndex(indexPath.row).valueForKey("country") as? String ?? ""
         
         
         let arrayData = NSMutableArray()
         
         
         let strcat = categoriesArray.componentsJoinedByString(",")
         print(strcat)
         
         
         
         
         let imId =
        */
        
        
        
        
        
        // Your action
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let uId = defaults .stringForKey("userLoginId")
        var arrId = NSArray()
      
        let imageId = photosArray[index2].valueForKey("id") as? String ?? ""
        
        
        let otherUserId = photosArray[index2].valueForKey("userId") as? String ?? ""
        
        
        print("like image tapped")
        
        
        
        
        ///MANAGE LIKE View
        
        
        let likecountlbl = longTapedView.viewWithTag(7478) as! UILabel
        
        // hide and show the view of like
        
        
        let likeimg = longTapedView.viewWithTag(7477) as! UIImageView
        
        
        let nxtObjMain = self.storyboard?.instantiateViewControllerWithIdentifier("mainHomeViewController") as! mainHomeViewController
        
        
        
        
        //MARK: LIKE COUNT MANAGE
        
        var countLik = NSNumber()
        
        if self.photosArray.objectAtIndex(index2).valueForKey("likeCount") != nil  {
            
            countLik = self.photosArray.objectAtIndex(index2).valueForKey("likeCount") as! NSNumber  //as? String ?? "0.0"
            
            
        }else
        {
            countLik=0
            
        }
        
        
        
        if likeCount.count>0 {
            if likeCount.valueForKey("imageId") .containsObject(imageId) {
                
                let index = self.likeCount.valueForKey("imageId").indexOfObject(imageId)
                
                if likeCount.objectAtIndex(index).valueForKey("like") as! Bool == true {
                    
                    let staticCount = likeCount.objectAtIndex(index).valueForKey("count") as? NSNumber
                    likecountlbl.text=String(nxtObjMain.subtractTheLikes(staticCount!))
                    
                    
                    likeCount .removeObjectAtIndex(index)
                    
                    likeCount .addObject(["userId":uId!, "imageId":imageId, "like":false, "count": nxtObjMain.subtractTheLikes(staticCount!)])
                    
                    
                    
                    
                    likeimg.image=UIImage (named: "like_count")
                    
                    let dat: NSDictionary = ["userId": "\(otherUserId)", "photoId":"\(imageId)", "userLiked":"\(uId!)", "status":"0"]
                    print("Post to like picture---- \(dat)")
                    apiClass.sharedInstance().postRequestLikeUnlikeImage(dat, viewController: self)
                    
                    
                }
                else
                {
                    let staticCount = likeCount.objectAtIndex(index).valueForKey("count") as? NSNumber
                    likecountlbl.text=String(nxtObjMain.addTheLikes(staticCount!))
                    
                    likeCount .removeObjectAtIndex(index)
                    likeCount .addObject(["userId":uId!, "imageId":imageId, "like":true, "count": nxtObjMain.addTheLikes(staticCount!)])
                    
                    
                    print(likeCount.lastObject)
                    
                    likeimg.image=UIImage (named: "likedCount")
                    
                    let dat: NSDictionary = ["userId": "\(otherUserId)", "photoId":"\(imageId)", "userLiked":"\(uId!)", "status":"1"]
                    
                    
                    print("Post to like picture---- \(dat)")
                    
                    apiClass.sharedInstance().postRequestLikeUnlikeImage(dat, viewController: self)
                    
                    
                }
            }
                // if not liked already
            else{
                likeCount .addObject(["userId":uId!, "imageId":imageId, "like":true, "count": nxtObjMain.addTheLikes(countLik)])
                likecountlbl.text=String(nxtObjMain.addTheLikes(countLik))
                likeimg.image=UIImage (named: "likedCount")
                
                let dat: NSDictionary = ["userId": "\(otherUserId)", "photoId":"\(imageId)", "userLiked":"\(uId!)", "status":"1"]
                
                
                print("Post to like picture---- \(dat)")
                
                apiClass.sharedInstance().postRequestLikeUnlikeImage(dat, viewController: self)
                
            }
            
        }
            
        else
            
        {
            
            likeCount .addObject(["userId":uId!, "count":nxtObjMain.addTheLikes(countLik), "like": true, "imageId": imageId])
            likecountlbl.text=String(nxtObjMain.addTheLikes(countLik))
            likeimg.image=UIImage (named: "likedCount")
            
            let dat: NSDictionary = ["userId": "\(otherUserId)", "photoId":"\(imageId)", "userLiked":"\(uId!)", "status":"1"]
            
            
            print("Post to like picture---- \(dat)")
            
            apiClass.sharedInstance().postRequestLikeUnlikeImage(dat, viewController: self)
        }
        
    
        
        
        
        self.tempFunc()
    
    
        
    }
    
    
    
    ///bucket image tapped
    func bucketImageTapped()
    {
        // Your action
        
        storyBucketBool=false // add to bucket
        print("bucket image tapped")
        
        
        
        
        var imageName2 = NSString()
        var thumbnailImage = NSString()
        var imageId = NSString()
        var desc = NSString()
        var categ = NSString()
        var nameUser = NSString()
        var country = NSString()
        var lat = NSNumber()
        var long = NSNumber()
        var cityName = NSString()
        
        
        
        
        
        nameUser = self.photosArray.objectAtIndex(index2) .valueForKey("name") as? String ?? ""
        
        let geoTag = self.photosArray.objectAtIndex(index2) .valueForKey("placeTag") as? String ?? ""
        
        country = self.photosArray.objectAtIndex(index2) .valueForKey("country") as? String ?? ""
        
        //MANAGE from the crash
        
        //check if lat long are nil or nsnull
        if self.photosArray.objectAtIndex(index2).valueForKey("latitude") != nil && self.photosArray.objectAtIndex(index2).valueForKey("latitude") as? NSNull != NSNull()   {
            
            lat = self.photosArray.objectAtIndex(index2).valueForKey("latitude") as! NSNumber  //as? String ?? "0.0"
            
            long = self.photosArray.objectAtIndex(index2).valueForKey("longitude") as! NSNumber //as? String ?? "0.0"
        }
        else
        {
            lat=0
            long=0
        }
        
        
        
        //print(arrCategory)
        
        imageName2 = self.photosArray.objectAtIndex(index2).valueForKey("imageLarge") as? String ?? ""
        thumbnailImage = self.photosArray.objectAtIndex(index2).valueForKey("imageStandard") as? String ?? ""
        
        imageId = self.photosArray.objectAtIndex(index2).valueForKey("id") as? String ?? ""
        
        
        desc=""
        
        let catrr = self.photosArray.objectAtIndex(index2).valueForKey("category") as? NSMutableArray
        
        
        
        categ = catrr!.componentsJoinedByString(",")
        
        
        
        if self.photosArray.objectAtIndex(index2).valueForKey("location") as? NSNull != NSNull()  {
            
            cityName = self.photosArray.objectAtIndex(index2).valueForKey("city") as? String ?? ""
            
            
        }
        
        
        //  apiClassStory.sharedInstance().postRequestDeleteStory(dataStr, viewController: self)
        
        cityName = self.photosArray.objectAtIndex(index2).valueForKey("city") as? String ?? ""
        
        
        
        
        
        
        
        
        self.detailSelectBtnAction(true)
        
        
        
        let profileImage = self.photosArray.objectAtIndex(index2).valueForKey("profilePic")! as? NSString ?? ""
        
        let headerType = NSUserDefaults.standardUserDefaults().valueForKey("selectedLocationType") as? String ?? ""
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let uId = defaults .stringForKey("userLoginId")
        
        
        
        var countst = NSNumber()
        
        countst = 0
        
        
        if countArray.valueForKey("storyCount") != nil
        {
            countst = countArray.valueForKey("storyCount") as! NSNumber
        }
        
        
        
        print(countst)
        let nxtObjMain = self.storyboard?.instantiateViewControllerWithIdentifier("mainHomeViewController") as! mainHomeViewController
        
        if addToBucketLblInPopup.text=="Add To Bucket List" {
            

            
            
            let parameterString = "city=\(cityName)&country=\(country)&userId=\(uId!)&imageId=\(imageId)"
            print("parameter of add t0 bucket=\(parameterString)")
            
            MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            
            //add image to bucket
           bucketListApiClass.sharedInstance().postRequestForAddBucket(parameterString, viewController: self)
            self.proceedBtnAction(self)
            
        }
            
        else
        {
            
            
            let dataStr = "userId=\(uId!)&imageId=\(imageId)&place=\(headerLabel.text!)&cityName=\(cityName)"
            
            print(dataStr)
            
            //delete from bucket
            
           // apiClassStory.sharedInstance().postRequestDeleteStory(dataStr, viewController: self)
        
            
        }
        
        
        self.tempFunc()

        
        
        
    }
    
    
    ///delete image tapped
    func deleteImageTapped()
    {
        // Your action
        
         self.tempFunc()
       
        
        
        
        // Create the alert controller
        let alertController = UIAlertController(title: "Pyt", message: "Are you sure to delete this image?", preferredStyle: .Alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            
            print("delete image tapped")
            
            let source = self.photosArray.objectAtIndex(self.index2).valueForKey("source") as? String ?? ""
            let imageId = self.photosArray.objectAtIndex(self.index2).valueForKey("id") as? String ?? ""
            let imageUrl = self.photosArray.objectAtIndex(self.index2).valueForKey("imageLarge") as? String ?? ""
            
            
            let defaults = NSUserDefaults.standardUserDefaults()
            let uId = defaults .stringForKey("userLoginId")
            
            
            
            let parameterString = "userId=\(uId!)&photoId=\(imageId)&imageUrl=\(imageUrl)"
            print(parameterString)
           
            MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            apiClass.sharedInstance().postRequestDeleteImagePytFromInterest(parameterString, viewController: self)
            
            
            
           
            
                
        
            
            
        }
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
            
            
        }
        
        
        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
        
        
        
        
             
        
       
    }
    
    
    
    func deletImageManage() {
        
       // print(photosArray)
        photosArray .removeObjectAtIndex(index2)
        //print(photosArray)
        //locationarray .replaceObjectAtIndex(index1, withObject: "")
        
        let indexPath = NSIndexPath(forRow: index2, inSection: 0)
        
        tableOfIntrests.deselectRowAtIndexPath(indexPath, animated: true)
        
        
        let index = self.segmentControl.selectedSegmentIndex
        
        if locationarray.count == 1 {
            
            locationarray .replaceObjectAtIndex(index, withObject: "")
            
            
        }
        else{
            
            locationarray.objectAtIndex(index).removeObjectAtIndex(index2)
            
        }
        
        
        
        
        self .shortData(locationarray)
        
        
    }
    
    
    
    
    
    
    
    func proceedBtnAction(sender: AnyObject)
    {
        
        
        
        
       
        
        
        let indexPathTable = NSIndexPath(forRow: index2, inSection: 0)
        
        
        let cell : IntrestTableViewCell =  tableOfIntrests.cellForRowAtIndexPath(indexPathTable)! as! IntrestTableViewCell
        // grab the imageview using cell
        
        let imgV = cell.museumImage as UIImageView
        
        
        
        
        // get the exact location of image
        var rect : CGRect =  imgV.superview!.convertRect(imgV.frame, fromView: nil)
        rect = CGRectMake(self.view.frame.size.width/2, (rect.origin.y * -1)-10, imgV.frame.size.width, imgV.frame.size.height)
        print(String.localizedStringWithFormat("rect is %f %f %f %f", rect.origin.x,rect.origin.y,rect.size.width,rect.size.height ))
        
        // create new duplicate image
        let starView : UIImageView = UIImageView(image: imgV.image)
        starView.frame = rect //CGRectMake(imgV.frame.origin.x, imgV.frame.origin.y, 70, 70)
        starView.frame.size.height=50
        starView.frame.size.width=50
        starView.layer.cornerRadius=5;
        starView.layer.borderWidth=1;
        
        self.view.addSubview(starView)
        
        
        var rect2 : CGRect =  starView.superview!.convertRect(starView.frame, fromView: nil)
        
        
        
        
        
        var endPoint = CGPoint()
        
        if storyBucketBool == true { //Add to story
           rect2 = CGRectMake(5, (rect2.origin.y * -1)-10, starView.frame.size.width, starView.frame.size.height)
            endPoint = CGPointMake(30, 30)
        }
        else
        { //Add to bucket
            let fltV: CGFloat = self.view.frame.size.width-30
            rect2 = CGRectMake(self.view.frame.size.width - 6, (rect2.origin.y * -1)-10, starView.frame.size.width, starView.frame.size.height)
            endPoint = CGPointMake(fltV, 30)
        }

        
        
        
        
        
        // create a new CAKeyframeAnimation that animates the objects position
        
        let pathAnimation = CAKeyframeAnimation(keyPath: "position")
        pathAnimation.calculationMode = kCAAnimationPaced
        pathAnimation.fillMode = kCAFillModeForwards
        pathAnimation.removedOnCompletion = false
        pathAnimation.duration = 1.0
        pathAnimation.delegate=self
        
        let curvedPath:CGMutablePath = CGPathCreateMutable()
        CGPathMoveToPoint(curvedPath, nil, CGFloat(1.0), CGFloat(1.0))
        CGPathMoveToPoint(curvedPath, nil, starView.frame.origin.x, starView.frame.origin.y)
        CGPathAddCurveToPoint(curvedPath, nil, endPoint.x, starView.frame.origin.y, endPoint.x, starView.frame.origin.y, endPoint.x, endPoint.y)
        pathAnimation.path = curvedPath
        
        // apply transform animation
        let basic : CABasicAnimation = CABasicAnimation(keyPath: "transform");
        let transform : CATransform3D = CATransform3DMakeScale(2,2,1 ) //0.25, 0.25, 0.25);
        basic.setValue(NSValue(CATransform3D: transform), forKey: "scaleText");
        basic.duration = 1.0
        
        starView.layer.addAnimation(pathAnimation, forKey: "curveAnimation")
        starView.layer.addAnimation(basic, forKey: "transform");
        
        let control: UIControl = UIControl()
        
        let dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(1.15 * Double(NSEC_PER_SEC)))
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            
            // imgV .removeFromSuperview()
            
            control.sendAction(#selector(UIView.removeFromSuperview), to: starView, forEvent: nil)
//            control.sendAction(#selector(mainHomeViewController.reloadBadgeNumber), to: self, forEvent: nil)
        })
    }
    
    
    
    
    
    
    
    
    
    
    
    
//
//    func serverResponseArrived(Response:AnyObject)
//    {
//
//
//        jsonMutableArray = NSMutableArray()
//        jsonMutableArray = Response as! NSMutableArray
//        
//        tagsArr = jsonMutableArray
//        let defaults = NSUserDefaults.standardUserDefaults()
//        defaults .setValue(tagsArr, forKey: "categoriesFromWeb")//
//        self.categoryBtnAction(self)
//        
//    }
 
    
    
    
    
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
