//
//  mainHomeViewController.swift
//  PYT
//
//  Created by Niteesh on 06/07/16.
//  Copyright © 2016 appsMaven. All rights reserved.
//

import UIKit
import SDWebImage
//import BetterSegmentedControl
import MBProgressHUD
import HMSegmentedControl
import ImageSlideshow




class mainHomeViewController: UIViewController, SDWebImageManagerDelegate, apiClassDelegate {
    
    @IBOutlet var mainViewWithGradient: UIView!
    
    
    
    var storedOffsets = [Int: CGFloat]()
    
    
    @IBOutlet var imagesTableView: UITableView!
    
    @IBOutlet var segmentControl: HMSegmentedControl!
    @IBOutlet var firstView: UIView!
    @IBOutlet var detailView: UIView!
    @IBOutlet var detailSubView: UIView!
   
    @IBOutlet var detailSub1: UIView!
   
    @IBOutlet var detailSub2: UIView!
    
    @IBOutlet var detailSub3: UIView!
    
    @IBOutlet var detailSub4: UIView!
    
    
    @IBOutlet var detailSub5Bottom: NSLayoutConstraint!
    
    
    var dataArray = NSMutableArray()
    var arrayOfimages1 = NSMutableArray()
    var userDetailArray = NSMutableArray()
    var tagForBtnCollection = Int()
    var tagForBtnIndex = Int()
    
    
    
    
    
    
    
    var colorArray = [
        UIColor.greenColor().colorWithAlphaComponent(0.5) ,
        UIColor.blueColor().colorWithAlphaComponent(0.5) ,
        UIColor.redColor().colorWithAlphaComponent(0.5) ,
        UIColor.orangeColor().colorWithAlphaComponent(0.5) ,
        UIColor.yellowColor().colorWithAlphaComponent(0.5) ,
        UIColor.purpleColor().colorWithAlphaComponent(0.5) ,
        UIColor.cyanColor().colorWithAlphaComponent(0.5)
        
    ] //array of colors for profile pictures of users
    
    var photos = []
    var tabledata = []
    var refreshControl: UIRefreshControl!
    
    //used for send the parameters in api
    var globalLocation = NSString()
    var globalLatitide = NSString()
    var globalLongitude = NSString()
    var globalType = NSString()
    var globalCountry = NSString()
    var selectedIndexOfLocation = Int()
    
    
    ////////Pop up View items
    
    @IBOutlet var addToStory: UIImageView!
    var storyBool = Bool()
    
    @IBOutlet var addStoryLabelInPopup: UILabel!
    
    @IBOutlet var likeLabelPopup: UILabel!
    
    
    @IBOutlet weak var addToBucketLblInPopup: UILabel!
    
    
   
    
    @IBOutlet var likeImage: UIImageView!
    @IBOutlet var addToBucket: UIImageView!
    @IBOutlet var deleteImage: UIImageView!
    
    var storyBucketBool = Bool()
    
    
     var collectionIndex = Int()
    var tableIndex = Int()
    var longTapedView = UIView()
    
    
    
    
    
    
    
    var selectedCell =  NSMutableArray() //seleted array of cells
    var likeCount = NSMutableArray()//Array to temporary save the likes
    var reuseData = NSMutableDictionary()//Array to avoid again and again call the api of search
    
    var uId = ""
    
   
    
    
    
    
    
    //MARK:- Detail View outlets
    
   
   
    @IBOutlet var heightOfContentView: NSLayoutConstraint!
    @IBOutlet var heightOfTable: NSLayoutConstraint!
    
    
    
   
    
    
    @IBOutlet var cameraBtn: UIButton!
    
    @IBOutlet var storyBtnOutlet: UIButton!
    @IBOutlet var bucketListOutlet: UIButton!
    @IBOutlet var bucketListCount: UILabel!
    @IBOutlet var storyListCount: UILabel!
    
    
    
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator)
    {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    }
    
    
    
    
    

    
    
    
    
    override func viewWillAppear(animated: Bool)
    {
        indicatorClass.sharedInstance().hideIndicator() //hide the indigator

        self.navigationController?.navigationBarHidden=true //hide the navigationBar
        self.detailView.hidden = true
            //Ensures that views are not underneath the tab bar
         apiClass.sharedInstance().delegate=self //delegate for response api
        
       
        
        print("\\\\\\\\\\---------------Selected Index from search----=\(selectedindxSearch)")
        
        NSURLCache.sharedURLCache().removeAllCachedResponses() //clear cache

        //call api for first time
        
        if userDetailArray.count<1 {
             self.callApi(globalLocation, latitide: globalLatitide, longitude: globalLongitude, type: globalType, country: globalCountry)
        }
        
        self.tabBarController?.tabBar.hidden = false
       
        
       

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), {() -> Void in
            
            print(countArray)
            
            self.storyListCount.text="0"
            
            if countArray.objectForKey("storyCount") != nil {
                if let stCount = countArray.valueForKey("storyCount"){
                    
                    self.storyListCount.text=String(stCount)
                }

            }
            
            
            
            
            if countArray.objectForKey("bucketCount") != nil {
                if let bktCount = countArray.valueForKey("bucketCount"){
                    
                    bucketListTotalCount=String(bktCount)
                }
                
            }
            
           
            
            
            self.bucketListCount.text = bucketListTotalCount
            
            
            
        })
        
        
       
        
        
        
        
       
    }
    
    override func viewWillDisappear(animated: Bool)
    {
         self.detailView.hidden = true
         NSURLCache.sharedURLCache().removeAllCachedResponses()//clear cache
    }
    
    
    
    
    
    
    //MARK:-/////////////// function for hit api when segment change//////////////////
    //MARK:-
    func segmentedControlChangedValue(segmentedControl: HMSegmentedControl) {
        //print("Selected index \(Int(segmentedControl.selectedSegmentIndex)) (via UIControlEventValueChanged)")
        
       
        
        let indexLoc = Int(segmentedControl.selectedSegmentIndex)
        
        
        globalLocation = tabledata .objectAtIndex(indexLoc) .valueForKey("location") as! NSString
        print(globalLocation)
        globalLatitide = tabledata .objectAtIndex(indexLoc) .valueForKey("lat") as! NSString
        globalLongitude = tabledata .objectAtIndex(indexLoc) .valueForKey("long") as! NSString
        globalType = tabledata .objectAtIndex(indexLoc) .valueForKey("type") as! NSString
        globalCountry = tabledata .objectAtIndex(indexLoc) .valueForKey("country") as! NSString
        
        
        selectedCell .removeAllObjects() // clear the selected images
        likeCount .removeAllObjects() // clear the liked
        
       
        
        
        ////Set true to reload the data in iterest screen
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(true, forKey: "refreshInterest")
      
        
        //call api
        self.callApi(globalLocation, latitide: globalLatitide, longitude: globalLongitude, type: globalType, country: globalCountry)
    }
    
    
    

    
    
    

    
//    
//    override func viewDidAppear(animated: Bool) {
//        super.viewDidAppear(animated)
//        
//        SocketIOManager.sharedInstance.getChatMessage { (messageInfo) -> Void in
//            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                
//                
//                
//            })
//        }
//    }
    
    
    
    
    
    
    //MARK:- main viewDidload function
    //MARK:-
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    
//        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(4.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
//            
//            dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {
//                let defaults = NSUserDefaults.standardUserDefaults()
//                let uId = defaults .stringForKey("userLoginId")
//                
//                SocketIOManager.sharedInstance.connectToServerWithNickname(uId!, completionHandler: { (userList) -> Void in
//                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                        if userList != nil {
//                            
//                            print(userList)
//                            
//                        }
//                    })
//                })
//                
//            })
//            
//        }
        
        
        
        
        
        
        
       
       
          apiClass.sharedInstance().delegate=self //delegate for response api
        
        let defaults = NSUserDefaults.standardUserDefaults()
        uId = defaults .stringForKey("userLoginId")!
        
        
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.label.text = "Fetching..."
        
        
        
        
        //---- manage view behind the status and navigation bar----////
        self.edgesForExtendedLayout = UIRectEdge .None
        self.extendedLayoutIncludesOpaqueBars=false
        self.automaticallyAdjustsScrollViewInsets = false// adjust navigation bar
        
        
        
        
        
        
       ////---- get data of saved intrests -----///////
        tabledata = NSUserDefaults.standardUserDefaults().arrayForKey("arrayOfIntrest")! as NSArray
        globalLocation = tabledata .objectAtIndex(selectedindxSearch) .valueForKey("location") as! NSString
        globalLatitide = tabledata .objectAtIndex(selectedindxSearch) .valueForKey("lat") as! NSString
        globalLongitude = tabledata .objectAtIndex(selectedindxSearch) .valueForKey("long") as! NSString
        globalType = tabledata .objectAtIndex(selectedindxSearch) .valueForKey("type") as! NSString
        globalCountry = tabledata .objectAtIndex(selectedindxSearch) .valueForKey("country") as! NSString
       
        NSUserDefaults.standardUserDefaults().setObject(self.globalLocation, forKey: "selectedLocation")

        
    

        
        
        /////0------  Pull to refresh Control ------////////
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "")// "Fetching Feeds")
        refreshControl.addTarget(self, action: #selector(mainHomeViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.imagesTableView.addSubview(refreshControl)
        
        
        
      
       
        
        cameraBtn.layer.cornerRadius=cameraBtn.frame.size.width/2
        cameraBtn.clipsToBounds=true
      
         self.imagesTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
      
        
        
        bucketListCount.layer.cornerRadius=bucketListCount.frame.size.width/2
        bucketListCount.clipsToBounds=true
        storyListCount.layer.cornerRadius=storyListCount.frame.size.width/2
        storyListCount.clipsToBounds=true
        
        
        
        ////--- segment control ---//
        
        let viewWidth = CGRectGetWidth(self.view.frame);
        let title2 = tabledata .valueForKey("location")
        
        
        segmentControl.sectionTitles = title2 as! [String]
        segmentControl.autoresizingMask = [.FlexibleRightMargin, .FlexibleWidth]
        segmentControl.frame = CGRectMake(0, 60, viewWidth, 34)
        
        segmentControl.segmentEdgeInset = UIEdgeInsetsMake(0, 5, 0, 5)
       
        segmentControl.selectionStyle = HMSegmentedControlSelectionStyle.FullWidthStripe
        
        
        segmentControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocation.Down
        
        
        segmentControl.selectionIndicatorColor = UIColor(red: 157/255, green: 194/255, blue: 134/255, alpha: 1.0)
        segmentControl.selectionIndicatorHeight=3.0
        segmentControl.verticalDividerEnabled = true
        segmentControl.verticalDividerColor = UIColor.clearColor()
        segmentControl.verticalDividerWidth = 0.8
        segmentControl.backgroundColor = UIColor .clearColor()
        
        segmentControl.selectedSegmentIndex=selectedindxSearch
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
        

        segmentControl.addTarget(self, action: #selector(self.segmentedControlChangedValue), forControlEvents: .ValueChanged)
        
        
        
        //////-------- Gradient background color ----/////////
        
        let layer = CAGradientLayer()
        layer.frame = CGRect(x: 0, y: 0, width: mainViewWithGradient.frame.size.width, height: self.firstView.frame.origin.y+self.firstView.frame.size.height)
        let blueColor = UIColor(red: 0/255, green: 146/255, blue: 198/255, alpha: 1.0).CGColor as CGColorRef
        let purpleColor = UIColor(red: 117/255, green: 42/255, blue: 211/255, alpha: 1.0).CGColor as CGColorRef
        layer.colors = [purpleColor, blueColor]
        layer.startPoint = CGPoint(x: 0.1, y: 0.5)
        layer.endPoint = CGPoint(x: 1.0, y: 0.5)
        layer.locations = [0.25,1.0]
        self.mainViewWithGradient.layer.addSublayer(layer)
        
       
        self.view .bringSubviewToFront(firstView)

        
        
        
    
    
      
    
        
       
        
                    let widthTotal = self.view.frame.size.width / 2
                    self.imagesTableView.rowHeight = widthTotal + 77
       // self.imagesTableView.pagingEnabled=true
        
        
       
        //[UIApplication .sharedApplication().delegate!.window!!.addSubview(detailView)]
        
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(mainHomeViewController.loadList(_:)),name:"load", object: nil)

         NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(mainHomeViewController.loadCount(_:)),name:"loadCount", object: nil)

        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(mainHomeViewController.loadDeletedCell(_:)),name:"loadDelete", object: nil)
        
        
        
        
        
        
      

       
        
        
    }
    
    
    
    
    
    
//MARK: -   ///// Function to get the notification for the chat mesages is received
    //MARK:
    
    
    
    ////Add this method in view did appear to get the messages
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        SocketIOManager.sharedInstance.getChatMessageNotify { (messageInfo) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                print(messageInfo["count"])
               
                let count: String = String(messageInfo["count"]!)
                
              self.tabBarController?.tabBar.items?[3].badgeValue = count
                
                
            })
        }
        
        
        
        
        
        
        
        
    
        
        SocketIOManager.sharedInstance.establishConnection()
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(4.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
            
            //dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {
            let defaults = NSUserDefaults.standardUserDefaults()
            let uId = defaults .stringForKey("userLoginId")
            
            if uId == nil || uId == ""{
                
            }
            else
            {
                SocketIOManager.sharedInstance.connectToServerWithNickname(uId!, completionHandler: { (userList) -> Void in
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        if userList != nil {
                            
                            print(userList)
                            
                        }
                    })
                })
            }
            
            
            
            //})
            
        }

        
        
        
        
        
        
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /////////////////////////////////////////////////////////////////////////
    //MARK:reload from another class(detailview class)
    //MARK:-
    func loadList(notification: NSNotification){
        //load data here
        
       print(likeCount.lastObject)
        
        self.imagesTableView .reloadData()
    
        
    }
   
    
    func loadDeletedCell(notification: NSNotification) {
        
        
      //  CommonFunctionsClass.sharedInstance().alertViewOpen("Image deleted!", viewController: self)
        
        self .deletePhotoTemporary()
        
       // self.callApi(globalLocation, latitide: globalLatitide, longitude: globalLongitude, type: globalType, country: globalCountry)
        
        
    }
    
    
    
    
    //MARK:reload from another class(Story Count class)
    //MARK:-
    
    func loadCount(notification: NSNotification){
        //load data here
        
        self.storyListCount.text="0"
      
        
        if countArray.objectForKey("storyCount") != nil {
            if let stCount = countArray.valueForKey("storyCount"){
                
                self.storyListCount.text=String(stCount)
            }
            
        }
        
        if countArray.objectForKey("bucketCount") != nil {
            if let stCount = countArray.valueForKey("bucketCount"){
                
                bucketListTotalCount=String(stCount)
            }
           
            
        }
        
        bucketListCount.text=bucketListTotalCount
        
    
    
    
    }

    
    
    
    
    
    
    
    
    
    /////////////////////////////////////////////////////////////////////////
    
    func tabBarController(aTabBar: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        //        if !self.hasValidLogin() && (viewController != aTabBar.viewControllers[0]) {
        //            // Disable all but the first tab.
        //            return false
        //        }
        
        
        print("---------------Its comes here------------------")
        return true
    }
    
    
    
    
    
    
    
    
    /////////////////////////////////////////////////////////////////////////
        //MARK:- Pulltorefresh function
        //MARK:-
    
        func refresh(sender:AnyObject)
        {
            // Code to refresh table view
            refreshControl.endRefreshing()
            selectedCell .removeAllObjects()
            likeCount .removeAllObjects()
            
           
            
            let arrayOfKeys:NSArray = reuseData.allKeys
            if (arrayOfKeys.containsObject(globalLocation)) {
                
                reuseData[globalLocation]=nil
                
                
            }
            
            print(reuseData)
            
            
            //check the count of story is avaliable or not
             if countArray.objectForKey("storyImages") != nil  {
                 self.callApi(globalLocation, latitide: globalLatitide, longitude: globalLongitude, type: globalType, country: globalCountry)
            }
                
             else
             {
                
                
                let objt = storyCountClass()
                let objt2 = UserProfileDetailClass()
               
                print("This is run on the background queue")
                
                objt.postRequestForcountStory("userId=\(uId)")
                
                ///User profile
                //dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {
                objt2.postRequestForGetTheUserProfileData("userId=\(uId)")
                // })
                

                
                
                self.callApi(globalLocation, latitide: globalLatitide, longitude: globalLongitude, type: globalType, country: globalCountry)
                
            }
            
            
            
            
           
        }
    
    
    

    
    
    /////////////////////////////////////////////////////////////////////////
    //MARK:-delegate and datasource of tableView
    //MARK:-
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    
    
     func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
     {
        let cell:SectionTableHeaderCell = tableView.dequeueReusableCellWithIdentifier("homeSectionHeader") as! SectionTableHeaderCell
        cell.locationLabelName.text = tabledata .objectAtIndex(section) .valueForKey("location") as! NSString as String
            return cell.contentView
        }
    
    
    
     func numberOfSectionsInTableView(tableView: UITableView) -> Int
     {
        return 1
      }
    
    
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
     {
        if section > 0
            {
                return 0
            }
        else
            {
                return dataArray.count
            }
    }
   
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
            let cell:cellClassTableViewCell = tableView.dequeueReusableCellWithIdentifier("cellHome") as! cellClassTableViewCell
        
        
        
   // dispatch_async(dispatch_get_main_queue(), {
                
        cell.userNameLabel.text = self.userDetailArray .objectAtIndex(indexPath.row) .valueForKey("name") as? String
        cell.useraddressLabel.text = self.userDetailArray .objectAtIndex(indexPath.row) .valueForKey("email") as? String
        cell.useraddressLabel.hidden=true
                
        let pImage : UIImage = UIImage(named:"backgroundImage")! //placeholder image
        
       
        
        /////------ user profile pics---/////
        
        let profileImage = self.userDetailArray .objectAtIndex(indexPath.row) .valueForKey("profile")! as! NSString
        let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in
            
        }
        if profileImage .isEqualToString("")
        {
           cell.userProfilePic.image = pImage
        }
        else
        {
            let url = NSURL(string: profileImage as String)
            cell.userProfilePic.sd_setImageWithURL(url, placeholderImage: pImage, completed: block)
        }
                
        ///////---- give a border with color to user profile picture----///////
        
        cell.userProfilePic.layer.borderWidth = 1.3
        
        let random = { () -> Int in
            return Int(arc4random_uniform(UInt32(self.colorArray.count)))
        }
        let color = self.colorArray[random()]//get color randomly
        cell.userProfilePic.layer.borderColor = color  .CGColor
        
                
                
                
                
                

        cell.ChatButton.tag=indexPath.row // chat button
        cell.ChatButton.addTarget(self, action: #selector(self.chatButtonAction), forControlEvents: .TouchUpInside)
        cell.ChatButton.hidden=false
        let idUser = self.userDetailArray .objectAtIndex(indexPath.row) .valueForKey("id") as? String ?? ""
        if uId == idUser {
             cell.ChatButton.hidden=true
        }
        
        
        
        
        cell.ChatButton.layer.cornerRadius=cell.ChatButton.frame.size.height/2
        cell.ChatButton.clipsToBounds=true
        
        
        
        
        
        cell.imagesCollectionView.delegate=self
        cell.imagesCollectionView.dataSource=self
        cell.imagesCollectionView.tag=indexPath.row
        
        cell.imagesCollectionView .reloadData()
        
        
        
        
        cell.layer.shouldRasterize = true
        cell.layer.rasterizationScale = UIScreen.mainScreen().scale
        
        //cell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row, andForSection: indexPath.section)

        
        
          //  })
        
             return cell
            
        
        
        
    }
    
    

    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        //print("You tapped cell number \(indexPath.row).")
        
    }
    
    
    
    
    
    
     func tableView(tableView: UITableView,
                            willDisplayCell cell: UITableViewCell,
                                            forRowAtIndexPath indexPath: NSIndexPath) {
        
       guard let tableViewCell = cell as? cellClassTableViewCell else { return }
//        
///       tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row, andForSection: indexPath.section)
//       // tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
        tableViewCell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
    }
    
    
     func tableView(tableView: UITableView,
                            didEndDisplayingCell cell: cellClassTableViewCell,
                                                 forRowAtIndexPath indexPath: NSIndexPath) {
        
        guard let tableViewCell = cell as? cellClassTableViewCell else { return }
        
        storedOffsets[indexPath.row] = tableViewCell.collectionViewOffset
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /////////////////////////////////////////////////////////////////////////
    
    //MARK:-/////////////////////  buttons Action here //////////////
    //MARK:
    //MARK:- Chat button
    func chatButtonAction(sender: UIButton!)
    {
       
        
        
        let user2Id = userDetailArray.objectAtIndex(sender.tag).valueForKey("id") as? String ?? ""
        let usname = userDetailArray.objectAtIndex(sender.tag).valueForKey("name") as? String ?? ""
        let receiverProfileImage = userDetailArray .objectAtIndex(sender.tag) .valueForKey("profile")! as? String ?? ""
        
        
        var arrImgThumbnail = NSArray()
        var arrImgLarge = NSArray()
        
         arrImgLarge = self.arrayOfimages1[sender.tag] .valueForKey("largeImage") as! NSArray
        arrImgThumbnail = self.arrayOfimages1[sender.tag] .valueForKey("thumbnails") as! NSArray
        
        let sendArray = NSMutableArray()
        
        if arrImgLarge.count == arrImgThumbnail.count {
           
            for i in 0 ..< arrImgLarge.count {
                
                sendArray .addObject(["Thumbnail": arrImgThumbnail.objectAtIndex(i) as? String ?? "", "Large": arrImgLarge.objectAtIndex(i) as? String ?? ""])
                
                
            }
           // print(sendArray)
            
            
            
        }
        else{
            
        }
        
        
        
        let nxtObj = self.storyboard?.instantiateViewControllerWithIdentifier("ChatViewController") as! ChatViewController
        nxtObj.CountTableArray = sendArray
        nxtObj.receiver_Id = user2Id
        nxtObj.locationName = globalLocation
        nxtObj.locationType = globalType
        nxtObj.receiverName = usname
        nxtObj.receiverProfile = receiverProfileImage
        self.navigationController! .pushViewController(nxtObj, animated: true)
        nxtObj.hidesBottomBarWhenPushed = true
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
  
    
    ////MARK:-Go to search Screen action here
    
    @IBAction func SearchScreenAction(sender: AnyObject)
    {
        let nxtObj = self.storyboard?.instantiateViewControllerWithIdentifier("firstMainScreenViewController") as! firstMainScreenViewController
       
         dispatch_async(dispatch_get_main_queue(), {
            self.navigationController! .pushViewController(nxtObj, animated: true)
            nxtObj.hidesBottomBarWhenPushed = true
        })
        
    }
    
    
    
    //MARK:- Stoy Action Button----//////
    
    @IBAction func storyBtnAction(sender: AnyObject) {
        
        let nxtObj = self.storyboard?.instantiateViewControllerWithIdentifier("storyViewcontrollerViewController") as! storyViewcontrollerViewController
        
        dispatch_async(dispatch_get_main_queue(), {
            self.navigationController! .pushViewController(nxtObj, animated: true)
            nxtObj.hidesBottomBarWhenPushed = true
        })
        
    }
    
    
    
    
    //MARK:- Bucket button--//
    
    @IBAction func bucketListButton(sender: AnyObject) {
    
        let nxtObj = self.storyboard?.instantiateViewControllerWithIdentifier("BucketListViewController") as! BucketListViewController
        
        dispatch_async(dispatch_get_main_queue(), {
            self.navigationController! .pushViewController(nxtObj, animated: true)
            nxtObj.hidesBottomBarWhenPushed = true
        })
    
    
    }
    
    
    
    
    
    
    
//    
//    //Logout Btn Action
//    
//    @IBAction func LogoutBtn(sender: AnyObject) {
//        
//        self.tabBarController?.tabBar.hidden = true
//        
//        let nxtObj = self.storyboard?.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
//        
//        dispatch_async(dispatch_get_main_queue(), {
//            self.navigationController! .pushViewController(nxtObj, animated: true)
//            self.dismissViewControllerAnimated(true, completion: {})
//        })
//        
//        
//        let defaults = NSUserDefaults.standardUserDefaults()
//        defaults.setObject("", forKey: "faceBookAccessToken")
//        defaults.setObject("", forKey: "instagramAccessToken")
//        defaults.setObject("logo", forKey: "userProfilePic")
//        defaults.setObject("PYT", forKey: "userName")
//        
//        
//    }
//    
    
    
    
    
    
    
    
    //MARK:- ////////////////// Functions to manage like, unlike, add to story,////////////////
    
    
    
    //MARK:- Tap gesture functions to manage the popup view
    
    ///Temp function to show and hide the popup view
    
    func tempFunc() -> Void {
        
        self .detailSelectBtnAction(false)
        
    }
    
    
    
    ///MARK:- Story image tapped
    
    func storyImageTapped()
    {
        // Your action
        
        print("Story image tapped")
        
        storyBucketBool = true //make true when add to story
        
        
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
        
        var arrImg2 = NSArray()
        arrImg2 = self.arrayOfimages1[tableIndex] .valueForKey("largeImage") as! NSArray
        
        var ThumbArray = NSArray()
        ThumbArray = self.arrayOfimages1[tableIndex].valueForKey("thumbnails") as! NSArray
        
        var arrId = NSArray()
        arrId = self.arrayOfimages1[tableIndex] .valueForKey("id") as! NSArray
        
        var arrDesc = NSArray()
        arrDesc = self.arrayOfimages1[tableIndex] .valueForKey("description") as! NSArray
        
        var arrCategory = NSArray()
        arrCategory = self.arrayOfimages1[tableIndex] .valueForKey("category") as! NSArray
        
        nameUser = self.userDetailArray[tableIndex] .valueForKey("name") as? String ?? ""
        
        let geoTag = self.arrayOfimages1[tableIndex] .valueForKey("geoTag") as! NSArray
        
        var arrCountry = NSArray()
        arrCountry = self.arrayOfimages1[tableIndex].valueForKey("country") as! NSArray
        country = arrCountry[collectionIndex] as! NSString
        
        
        
        
        let source = self.arrayOfimages1[tableIndex] .valueForKey("source") as! NSArray
        var sourceStr = "Other"
        if source[collectionIndex] as? NSNull != NSNull()  {
            
            
             sourceStr = source.objectAtIndex(collectionIndex) as? String ?? ""
           
            
        }
        
        
        
        
        //MANAGE from the crash
        let latArr = self.arrayOfimages1[tableIndex].valueForKey("latitude") as! NSArray
        if latArr[collectionIndex] as? NSNull != NSNull()  {
            
            lat = latArr[collectionIndex] as! NSNumber  //as? String ?? "0.0"
            
            let longArr = self.arrayOfimages1[tableIndex].valueForKey("longitude") as! NSArray
            long = longArr[collectionIndex] as! NSNumber //as? String ?? "0.0"
        }
        else
        {
            lat=0
            long=0
        }
        
        
        //city name
        cityName = ""
        let cityArr = self.arrayOfimages1[tableIndex].valueForKey("location") as! NSArray
        if cityArr[collectionIndex] as? NSNull != NSNull()  {
            
            cityName = cityArr[collectionIndex] as? String ?? ""
            
        }
        
        
        
       
        //print(arrCategory)
        
        imageName2 = arrImg2[collectionIndex] as! String
        imageId = arrId[collectionIndex] as! String
        thumbnailImage = ThumbArray[collectionIndex] as! String
        
        if let descc = arrDesc[collectionIndex] as? String {
            desc = descc
        }
        else{
            desc = "NA"
        }
        
        
        
        
        
        /*
 
 
 userId=PYT1979023&imageId=584c014d0d3c6eea2b788bc9&place=portugal&cityName=real
 
         userId=PYT1979023&imageId=584c014d0d3c6eea2b788bc9&place=Portugal&cityName=real
 
 */
        
        
        
        
        
        
        categ = arrCategory[collectionIndex] .componentsJoinedByString(",")
        let location = "\(geoTag[collectionIndex] as? String ?? "")"
        
         let profileImage = self.userDetailArray .objectAtIndex(tableIndex) .valueForKey("profile")! as? NSString ?? ""
        
        
        
        
        var countst = NSNumber()
        countst = 0
       
        
        if countArray.objectForKey("storyCount") != nil  {
           
            countst = countArray.valueForKey("storyCount") as! NSNumber
            
            
            print(countst)
        
        }
        
        
            
       
        
        
        
        if  addStoryLabelInPopup.text=="Add To Story" {
            
            
            let dat: NSDictionary = ["userid": "\(uId)", "id": imageId, "imageLink": imageName2, "location": self.globalLocation, "source":"facebook", "latitude": lat, "longitude": long, "geoTag":location, "category":categ, "description":desc, "userName":nameUser,"type": sourceStr, "profileImage":profileImage, "cityName":cityName, "imageThumb": thumbnailImage ]
            
            //type=self,globaltype
            var postDict = NSDictionary()
            
            postDict = dat
            
            MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            
            print("Post parameters to select the images for story--- \(postDict)")
            
            //add image to story
            
           
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {
            apiClass.sharedInstance().postRequestWithMultipleImage("", parameters: postDict, viewController: self)
                })

            self.proceedBtnAction(tableIndex, collectionViewIndex: collectionIndex)
            
                        self.detailSelectBtnAction(true)
            
            storyListCount.text=String(self.addTheLikes(countst))
            
        }
            
        else
        {
            
            
            let dataStr = "userId=\(uId)&imageId=\(imageId)&place=\(self.globalLocation)&cityName=\(cityName)"
            
            print(dataStr)
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {
            apiClassStory.sharedInstance().postRequestDeleteStory(dataStr, viewController: self)
                
                })
            storyListCount.text=String(self.subtractTheLikes(countst))
            
        }
        
        
        
        
        
//        if self.selectedCell .valueForKey("id").containsObject(imageId){
//            let index = self.selectedCell.valueForKey("id").indexOfObject(imageId)
//            
//            
//            
//            self.selectedCell .removeObjectAtIndex(index)
//            
//            
//            if self.selectedCell.count<1{
//                
//                
//            }
//            
//            
//            
//        }
        
//        else
//        {
//            
//            self.selectedCell .addObject(["id": imageId, "imageLink": imageName2, "description": desc, "category":categ, "location":self.globalLocation, "type":self.globalType, "userName": nameUser, "geoTag": location, "index":tableIndex, "collectionIndex":collectionIndex, "latitude": lat, "long": long, "cityName":cityName])
//            
//            
//            
//            self.proceedBtnAction(tableIndex, collectionViewIndex: collectionIndex)
//            
//            self.detailSelectBtnAction(true)
//            
//            let profileImage = self.userDetailArray .objectAtIndex(tableIndex) .valueForKey("profile")! as? NSString ?? ""
//            
//            
//            
//        }
        
        
       
        
       
        
        self.tempFunc()
        
        
        
        
        
    }
    

    //MARK:- Action to add the image to story & Bucket
    
    func proceedBtnAction(tableViewIndex: Int, collectionViewIndex: Int)
    {
       // let tableIndex = selectedCell .valueForKey("index").objectAtIndex(selectedCell.count-1) as! Int
       // let collectionIndex = selectedCell .valueForKey("collectionIndex").objectAtIndex(selectedCell.count-1) as! Int
        let indexPathTable = NSIndexPath(forRow: tableViewIndex, inSection: 0)
        let indexPathCollection = NSIndexPath(forRow: collectionViewIndex, inSection: 0)
        
        
        let cell : cellClassTableViewCell =  imagesTableView.cellForRowAtIndexPath(indexPathTable)! as! cellClassTableViewCell
        // grab the imageview using cell
        
        let imgV = cell.imagesCollectionView.cellForItemAtIndexPath(indexPathCollection)?.viewWithTag(7459) as! UIImageView
        
        
        
        
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
         var endPoint=CGPoint()
        
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
        
        print( rect2)
        
        
       
        
        
        //rect2.size.height/2)
        
        
        
        
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
            control.sendAction(#selector(mainHomeViewController.reloadBadgeNumber), to: self, forEvent: nil)
        })
    }
    
    // update the Badge number
    func reloadBadgeNumber(){
        //      let storyTab : UITabBarItem = (self.tabBarController?.tabBar.items![3])! as UITabBarItem
        //
        //    storyTab.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.redColor()], forState:.Normal)
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //MARK: Like image tapped
    
    func likeImageTapped()
    {
        // Your action
        
        
        
        var arrId = NSArray()
        arrId = self.arrayOfimages1[tableIndex] .valueForKey("id") as! NSArray
        let imageId = arrId[collectionIndex] as? String ?? ""
        
        
        let otherUserId = userDetailArray.objectAtIndex(tableIndex).valueForKey("id") as? String ?? ""
        
        
        print("like image tapped")
        
        
        
        
        ///MANAGE LIKE View
        
        
        let likecountlbl = longTapedView.viewWithTag(7478) as! UILabel
        
        // hide and show the view of like
        
        
        let likeimg = longTapedView.viewWithTag(7477) as! UIImageView
        
        
        
        
        
        
        
        
        //MARK: LIKE COUNT MANAGE
        
        var countLik = NSNumber()
       // print("collection=\(collectionIndex)")
       // print("arrayofimgs=\(arrayOfimages1.count)")
        
        print(tableIndex)
        print(collectionIndex)
        
        
        
        let likeCountValue = self.arrayOfimages1[tableIndex].valueForKey("likeCount") as! NSArray
        print(likeCountValue)
        if likeCountValue[collectionIndex] as? NSNull != NSNull()  {
            
            countLik = likeCountValue[collectionIndex] as! NSNumber  //as? String ?? "0.0"
            
            
        }else
        {
            countLik=0
            
        }
        
        
        
        if likeCount.count>0 {
            if likeCount.valueForKey("imageId") .containsObject(imageId) {
                
                let index = self.likeCount.valueForKey("imageId").indexOfObject(imageId)
                
                if likeCount.objectAtIndex(index).valueForKey("like") as! Bool == true {
                    
                    let staticCount = likeCount.objectAtIndex(index).valueForKey("count") as? NSNumber
                    likecountlbl.text=String(self.subtractTheLikes(staticCount!))
                    
                    
                    likeCount .removeObjectAtIndex(index)
                    
                    likeCount .addObject(["userId":uId, "imageId":imageId, "like":false, "count": self.subtractTheLikes(staticCount!)])
                    
                    
                    
                    
                    likeimg.image=UIImage (named: "like_count")
                    
                    let dat: NSDictionary = ["userId": "\(otherUserId)", "photoId":"\(imageId)", "userLiked":"\(uId)", "status":"0"]
                    print("Post to like picture---- \(dat)")
                    dispatch_async(dispatch_get_main_queue(), {
                        apiClass.sharedInstance().postRequestLikeUnlikeImage(dat, viewController: self)
                    })
                    
                }
                else
                {
                    let staticCount = likeCount.objectAtIndex(index).valueForKey("count") as? NSNumber
                    likecountlbl.text=String(self.addTheLikes(staticCount!))
                    
                    likeCount .removeObjectAtIndex(index)
                    likeCount .addObject(["userId":uId, "imageId":imageId, "like":true, "count": self.addTheLikes(staticCount!)])
                    
                    
                    print(likeCount.lastObject)
                    
                    likeimg.image=UIImage (named: "likedCount")
                    
                    let dat: NSDictionary = ["userId": "\(otherUserId)", "photoId":"\(imageId)", "userLiked":"\(uId)", "status":"1"]
                    
                    
                    print("Post to like picture---- \(dat)")
                    dispatch_async(dispatch_get_main_queue(), {
                        apiClass.sharedInstance().postRequestLikeUnlikeImage(dat, viewController: self)
                    })
                    
                }
            }
                // if not liked already
            else{
                likeCount .addObject(["userId":uId, "imageId":imageId, "like":true, "count": self.addTheLikes(countLik)])
                likecountlbl.text=String(self.addTheLikes(countLik))
                likeimg.image=UIImage (named: "likedCount")
                
                let dat: NSDictionary = ["userId": "\(otherUserId)", "photoId":"\(imageId)", "userLiked":"\(uId)", "status":"1"]
                
                
                print("Post to like picture---- \(dat)")
                dispatch_async(dispatch_get_main_queue(), {
                    apiClass.sharedInstance().postRequestLikeUnlikeImage(dat, viewController: self)
                })
            }
            
        }
            
        else
            
        {
            
            likeCount .addObject(["userId":uId, "count":self.addTheLikes(countLik), "like": true, "imageId": imageId])
            likecountlbl.text=String(self.addTheLikes(countLik))
            likeimg.image=UIImage (named: "likedCount")
            
            let dat: NSDictionary = ["userId": "\(otherUserId)", "photoId":"\(imageId)", "userLiked":"\(uId)", "status":"1"]
            
            
            print("Post to like picture---- \(dat)")
            dispatch_async(dispatch_get_main_queue(), {
                apiClass.sharedInstance().postRequestLikeUnlikeImage(dat, viewController: self)
            })
        }
        
        
        
        
        
        
        
        
        self.tempFunc()
        
        
        
        
        
    }
    
    
    
    
    //MARK:bucket image tapped
    
    func bucketImageTapped()
    {
        // Your action
        
                print("bucket image tapped")
        
        storyBucketBool = false //make false when add to bucket
        
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
        
        var arrImg2 = NSArray()
        arrImg2 = self.arrayOfimages1[tableIndex] .valueForKey("largeImage") as! NSArray
        
        var ThumbArray = NSArray()
        ThumbArray = self.arrayOfimages1[tableIndex].valueForKey("thumbnails") as! NSArray
        
        var arrId = NSArray()
        arrId = self.arrayOfimages1[tableIndex] .valueForKey("id") as! NSArray
        
        var arrDesc = NSArray()
        arrDesc = self.arrayOfimages1[tableIndex] .valueForKey("description") as! NSArray
        
        var arrCategory = NSArray()
        arrCategory = self.arrayOfimages1[tableIndex] .valueForKey("category") as! NSArray
        
        nameUser = self.userDetailArray[tableIndex] .valueForKey("name") as? String ?? ""
        
        let geoTag = self.arrayOfimages1[tableIndex] .valueForKey("geoTag") as! NSArray
        
        var arrCountry = NSArray()
        arrCountry = self.arrayOfimages1[tableIndex].valueForKey("country") as! NSArray
        country = arrCountry[collectionIndex] as! NSString
        
        //MANAGE from the crash
        let latArr = self.arrayOfimages1[tableIndex].valueForKey("latitude") as! NSArray
        if latArr[collectionIndex] as? NSNull != NSNull()  {
            
            lat = latArr[collectionIndex] as! NSNumber  //as? String ?? "0.0"
            
            let longArr = self.arrayOfimages1[tableIndex].valueForKey("longitude") as! NSArray
            long = longArr[collectionIndex] as! NSNumber //as? String ?? "0.0"
        }else{
            lat=0
            long=0
        }
        
        
        //city name
        cityName = ""
        let cityArr = self.arrayOfimages1[tableIndex].valueForKey("location") as! NSArray
        if cityArr[collectionIndex] as? NSNull != NSNull()  {
            
            cityName = cityArr[collectionIndex] as? String ?? ""
            
        }
        
        
        
        
        //print(arrCategory)
        
        imageName2 = arrImg2[collectionIndex] as! String
        imageId = arrId[collectionIndex] as! String
        thumbnailImage = ThumbArray[collectionIndex] as! String
        
        if let descc = arrDesc[collectionIndex] as? String {
            desc = descc
        }
        else{
            desc = "NA"
        }
        
        
        
        
        
        /*
         
         
         userId=PYT1979023&imageId=584c014d0d3c6eea2b788bc9&place=portugal&cityName=real
         
         userId=PYT1979023&imageId=584c014d0d3c6eea2b788bc9&place=Portugal&cityName=real
         
         */
        
        
        
        
        
        
        categ = arrCategory[collectionIndex] .componentsJoinedByString(",")
        let location = "\(geoTag[collectionIndex] as? String ?? "")"
        
        let profileImage = self.userDetailArray .objectAtIndex(tableIndex) .valueForKey("profile")! as? NSString ?? ""
        
        
        
        
        var countst = NSNumber()
        countst = 0
        
        
        if countArray.objectForKey("storyCount") != nil  {
            
            countst = countArray.valueForKey("storyCount") as! NSNumber
            
            
            print(countst)
            
        }
        
        
        
        
      
        
        
        if  addToBucketLblInPopup.text=="Add To Bucket List" {
            
            
            
            MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            
            let parameterString = "city=\(cityName)&country=\(country)&userId=\(uId)&imageId=\(imageId)"
            print("parameter of add t0 bucket=\(parameterString)")
            
        
            
            
            
            
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {
                bucketListApiClass.sharedInstance().postRequestForAddBucket(parameterString, viewController: self)
                
                
//                   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), {() -> Void in
//                
//                    
//                    self.bucketListCount.text=bucketListTotalCount
                
                    
                               // })
    
                
            })
            
            
            self.proceedBtnAction(tableIndex, collectionViewIndex: collectionIndex)
            
            self.detailSelectBtnAction(true)

            
           
            
        }
            
        else
        {
            

            //remove from bucket
            
//            let dataStr = "userId=\(uId)&imageId=\(imageId)&place=\(self.globalLocation)&cityName=\(cityName)"
//            
//            print(dataStr)
//            dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {
//                apiClassStory.sharedInstance().postRequestDeleteStory(dataStr, viewController: self)
//                
//            })
//            storyListCount.text=String(self.subtractTheLikes(countst))
            
        }
        
        
        
        
        
        if self.selectedCell .valueForKey("id").containsObject(imageId){
            let index = self.selectedCell.valueForKey("id").indexOfObject(imageId)
            
            
            
          //  self.selectedCell .removeObjectAtIndex(index)
            
            
            if self.selectedCell.count<1{
                
                
            }
            
            
            
        }
            
        else
        {
            
          //  self.selectedCell .addObject(["id": imageId, "imageLink": imageName2, "description": desc, "category":categ, "location":self.globalLocation, "type":self.globalType, "userName": nameUser, "geoTag": location, "index":tableIndex, "collectionIndex":collectionIndex, "latitude": lat, "long": long, "cityName":cityName])
            
            
            
           // self.proceedBtnAction(self)
            
            //self.detailSelectBtnAction(true)
            
            
            
        }
        
        
        
        
       
        
        
        
        self.tempFunc()
    }
    
    
    
    //MARK: Delete Image Tapped
    
    func deleteImageTapped()
    {
              self.tempFunc()
        
        
        // Create the alert controller
        let alertController = UIAlertController(title: "Pyt", message: "Are you sure to delete this image?", preferredStyle: .Alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            
            print("delete image tapped")
            
            
            var arrImg2 = NSArray()
            arrImg2 = self.arrayOfimages1[self.tableIndex] .valueForKey("largeImage") as! NSArray
            
            var ThumbArray = NSArray()
            ThumbArray = self.arrayOfimages1[self.tableIndex].valueForKey("thumbnails") as! NSArray
            
            var arrId = NSArray()
            arrId = self.arrayOfimages1[self.tableIndex] .valueForKey("id") as! NSArray
            
            
            let imageUrl = arrImg2[self.collectionIndex] as! String
            let imageId = arrId[self.collectionIndex] as! String
            
            
           
            
            
            
            let parameterString = "userId=\(self.uId)&photoId=\(imageId)&imageUrl=\(imageUrl)"
            print(parameterString)
           
            MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            apiClass.sharedInstance().postRequestDeleteImagePyt(parameterString, viewController: self)
            
            
            
            
//            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
//                UIAlertAction in
//                NSLog("Cancel Pressed")
//                
            
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
    
    
    
    
    func deletePhotoTemporary() {
        
        
        
        //let tempArray = self.arrayOfimages1[tableIndex] as! NSArray
        let tempDict = self.arrayOfimages1[tableIndex] as! NSMutableDictionary
        
        
        let newMutableDict = NSMutableDictionary()
        
        for (key,values) in tempDict {
            
           // print("key=\(key), value=\(values)")
            
            var value = values as! NSArray
            
            var value2 = NSMutableArray()
            
            value2 = NSMutableArray(array: value )
            
            
            value2.removeObjectAtIndex(collectionIndex)
            
            value = NSArray(array: value2)
            //print("new value=\(value)")
            
            
            if value.count<1 {
                
            }else{
                 newMutableDict .setObject(value, forKey: key as! String)
            }
            
           
            //print(newMutableDict)
            
        }
        
        if newMutableDict.count<1 {
           // dispatch_async(dispatch_get_main_queue(), {
            print(self.dataArray.count)
            self.dataArray .removeObjectAtIndex(self.tableIndex)
            print(self.dataArray.count)
           reuseData[globalLocation]=nil
            
            self.imagesTableView .reloadData()
          //  })
            
        }
        else
        {
            self.arrayOfimages1.replaceObjectAtIndex(tableIndex, withObject: newMutableDict)
            
            let indexPath = NSIndexPath(forRow: tableIndex, inSection: 0)
            imagesTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)
         reuseData[globalLocation]=nil

        }
        
        reuseData[globalLocation]=nil
        
    }
    
    
   
    
    
    
    
    
    
    
    
    
    
    
    
    //MARK: To show the popup view and hide that popup view
    
    func detailSelectBtnAction(showView:Bool) -> Void
    {
        
        
        //// hide the view
        if showView==false {
            
            self.tabBarController?.tabBar.hidden = false
            self.detailView.hidden = true
            let popUpView = detailView
            //let centre : CGPoint = CGPoint(x: self.view.center.x, y: self.view.center.y)
            let centre : CGPoint = CGPoint(x: (self.tabBarController?.view.center.x)!, y: (self.tabBarController?.view.center.y)!)
            
            popUpView.center = centre
            popUpView.layer.cornerRadius = 0.0
            let trans = CGAffineTransformScale(popUpView.transform, 1.0, 1.0)
            popUpView.transform = trans
            self.view .addSubview(popUpView)
            UIView .animateWithDuration(0.3, delay: 0.0, options:     UIViewAnimationOptions.CurveEaseInOut, animations: {
                
                popUpView.transform = CGAffineTransformScale(popUpView.transform, 0.1, 0.1)
                
                
                }, completion: {
                    (value: Bool) in
                    //popUpView .removeFromSuperview()
                    
                    
                    
                    popUpView.transform = CGAffineTransformIdentity
            })
            
            
        }
            
            ////Show the View
        else
        {
            
            
            
            self.detailView.hidden=false
            self.tabBarController?.tabBar.hidden = true
           
            
            
            
            let popUpView = detailView
            let centre : CGPoint = CGPoint(x: self.view.center.x, y: self.view.center.y)
            //let centre : CGPoint = CGPoint(x: (self.tabBarController?.view.center.x)!, y: (self.tabBarController?.view.center.y)!)
            
            
            popUpView.center = centre
            popUpView.layer.cornerRadius = 0.0
            let trans = CGAffineTransformScale(popUpView.transform, 0.01, 0.01)
            popUpView.transform = trans
            self.view .addSubview(popUpView)
            UIView .animateWithDuration(0.3, delay: 0.0, options:     UIViewAnimationOptions.CurveEaseInOut, animations: {
                
                popUpView.transform = CGAffineTransformScale(popUpView.transform, 100.0, 100.0)//CGAffineTransformIdentity
                
                }, completion: {
                    (value: Bool) in
                    
                    
            })
            
            
            
            
            
            
            self.tabBarController?.view.bringSubviewToFront(detailView)
            
            
            let tapGestureRecognizer = UITapGestureRecognizer()
            tapGestureRecognizer.addTarget(self, action: #selector(mainHomeViewController.tempFunc))
            
            detailView.addGestureRecognizer(tapGestureRecognizer)
            
            
            
            let tapGestureRecognizer2 = UITapGestureRecognizer(target:self, action:#selector(mainHomeViewController.storyImageTapped))
            addToStory.userInteractionEnabled = true
            addToStory.addGestureRecognizer(tapGestureRecognizer2)
            
            self.detailView.bringSubviewToFront(addToStory)
            
            
            
            let tapGestureRecognizer3 = UITapGestureRecognizer(target:self, action:#selector(mainHomeViewController.likeImageTapped))
            likeImage.userInteractionEnabled = true
            likeImage.addGestureRecognizer(tapGestureRecognizer3)
            
            self.detailView.bringSubviewToFront(likeImage)
            
            
            
            let tapGestureRecognizer4 = UITapGestureRecognizer(target:self, action:#selector(mainHomeViewController.bucketImageTapped))
            addToBucket.userInteractionEnabled = true
            addToBucket.addGestureRecognizer(tapGestureRecognizer4)
            
            self.detailView.bringSubviewToFront(addToBucket)
            
            
            let tapGestureRecognizer5 = UITapGestureRecognizer(target:self, action:#selector(mainHomeViewController.deleteImageTapped))
            deleteImage.userInteractionEnabled = true
            deleteImage.addGestureRecognizer(tapGestureRecognizer5)
            
            self.detailView.bringSubviewToFront(deleteImage)
            
            
            
        }
        
    }
    
    
    
    
    
    
    
    
    
    ////////////////////////////////////////////////////////////////////////
    //MARK:-
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        NSURLCache.sharedURLCache().removeAllCachedResponses()
        
        print("MEMORYWARNING AND CLEARING CACHE ")
        
        let imageCache = SDImageCache.sharedImageCache()
        imageCache.clearMemory()
       // imageCache.clearDisk()
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    ////////////////////////////////////////////////////////////////////////
    
   //MARK:-///////////////call the Search api from here to get the photos of the locations////////////////////////
    //MARK:-
    
    func callApi(location:NSString, latitide:NSString, longitude:NSString, type:NSString, country:NSString) -> Void
    {
       
        
        NSUserDefaults.standardUserDefaults().setObject(self.globalLocation, forKey: "selectedLocation")
        NSUserDefaults.standardUserDefaults().setObject(self.globalType, forKey: "selectedLocationType")
        NSUserDefaults.standardUserDefaults().setObject(self.globalCountry, forKey: "selectedLocationCountry")
        
        
        
        storyBool=false
         MBProgressHUD.hideHUDForView(self.view, animated: true)
        
        //hit api here
       
        
        let parameterString = NSString(string:"search_data/\(location)/\(country)/\(latitide)/\(longitude)/50/\(type)") as String

      
            self.dataArray = NSMutableArray()
            self.arrayOfimages1 .removeAllObjects()
            self.userDetailArray .removeAllObjects()
        
                   self.imagesTableView .reloadData()
        
         //  NSOperationQueue.mainQueue().cancelAllOperations() //clear all the queues
       
         // dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {
        dispatch_async(dispatch_get_main_queue(), {
      
        //print(reuseData)
        print(self.globalLocation)
        

        let defaults = NSUserDefaults.standardUserDefaults()
        
        defaults.setBool(true, forKey: "refreshInterest")


        let arrayOfKeys:NSArray = self.reuseData.allKeys
        if (arrayOfKeys.containsObject(self.globalLocation)) {
            self.dataArray = self.reuseData .valueForKey(self.globalLocation as String) as! NSMutableArray
            self.shortData()
        }
    
        else{
            
            let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            loadingNotification.mode = MBProgressHUDMode.Indeterminate
            loadingNotification.label.text = "Loading Friend's Pictures"
            
           // dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {
             apiClass.sharedInstance().getRequest(parameterString, viewController: self)
           // })
        }
        
        
       
        
            //})
        })

        
       
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //MARK:-//////////////////////// get response from server into its delegate/////////////////////
    //MARK:-
    
    func serverResponseArrived(Response:AnyObject)
    {
    
        
        //////////---------- REsponse for the add and delete image in story-----------////////
        if storyBool==true {
            
            jsonResult = NSDictionary()
            jsonResult = Response as! NSDictionary
            
            let success = jsonResult.objectForKey("status") as! NSNumber
            
            if success != 1
            {
                CommonFunctionsClass.sharedInstance().alertViewOpen("Sorry image is not added to story, Please try again", viewController: self)
            }
            
            
        //get response here
            
        }
        
        
            
            
            
        
            
            
            
            
        
    ///////////--------------Response for the Locations-----------//////////////////
        else
        {
            
            jsonResult = NSDictionary()
            jsonResult = Response as! NSDictionary
            
           
            
            
            let success = jsonResult.objectForKey("status") as! NSNumber
            if success == 1
            {
                
                dataArray = jsonResult .valueForKey("data")! as! NSMutableArray
                
                reuseData .setObject(dataArray, forKey: globalLocation)
                
                
                if dataArray.count<1
                {
                    
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                    CommonFunctionsClass.sharedInstance().alertViewOpen("Sorry no content found", viewController: self)
                }
                else
                {
                 self.shortData()
                }
                
                
               
                
            }
            else
            {
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                CommonFunctionsClass.sharedInstance().alertViewOpen("Sorry no content found", viewController: self)
                
            }
            
            
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            //CommonFunctionsClass.sharedInstance().alertViewOpen("Testing here", viewController: self)
            
        }
        
        
        
      
        
        
    }

    
  
    
    
    
    
    
    
    func shortData() -> Void {
        
        
         //dispatch_async(dispatch_get_main_queue(), {
        
        
         self.refreshControl .endRefreshing() // it will showing then will remove
        
         let intrestArray = NSMutableArray()
        
        //  let defaults = NSUserDefaults.standardUserDefaults()
        //                let data4 = NSKeyedArchiver .archivedDataWithRootObject(self.dataArray)
        //
        //                [defaults .setObject(data4, forKey: "IntrestScreenData")]
        
        
        
        // here data have been getting ino the arrays after get from server
        
        for i in 0 ..< self.dataArray.count
        {
            // print(dataArray .objectAtIndex(i))
            self.photos = [self.dataArray .objectAtIndex(i) .valueForKey("photos")! ]
            
            var imagesArray = NSArray()
            imagesArray = self.photos[0] .valueForKey("imageStandard")! as! NSArray//total small images array
            
            
            
            let latArray = self.photos[0] .valueForKey("latitude")! as! NSArray//total latitude array
            let longArray = self.photos[0] .valueForKey("longitude")! as! NSArray//total longitude array
            
            
            
            var imagesLargeArray = NSArray()
            imagesLargeArray = self.photos[0] .valueForKey("imageLarge")! as! NSArray//total images array
            
            
            var locationArray = NSArray()
            locationArray = self.photos[0] .valueForKey("city")! as! NSArray//total city name array
            //print(locationArray.count)
            
            var idArray = NSArray()
            idArray = self.photos[0] .valueForKey("id")! as! NSArray//total image id array
            //print(idArray.count)
            
            var categoryArray = NSArray()
            categoryArray = self.photos[0] .valueForKey("category")! as! NSArray//total catigory array
            //print(categoryArray.count)
            
            var albumArray = NSArray()
            albumArray = self.photos[0] .valueForKey("album_name")! as! NSArray//total albums name array
            //print(albumArray.count)
            
            var descriptionArray = NSArray()
            descriptionArray = self.photos[0] .valueForKey("description")! as! NSArray//total description array
            //print(descriptionArray.count)
            
            var geoTagArray = NSArray()
            geoTagArray = self.photos[0] .valueForKey("location")! as! NSArray//total geotag array
            
            
            var sourceArray = NSArray()
            sourceArray = self.photos[0] .valueForKey("source")! as! NSArray//total source(fb, pyt, checkin) name array
            
            
            var countryArray = NSArray()
            countryArray = self.photos[0] .valueForKey("country")! as! NSArray//total country name array
            
            
            var likeCountArray = NSArray()
            likeCountArray = self.photos[0] .valueForKey("count")! as! NSArray//total likecount array
            
            //  print(likeCountArray)
            
            
            var idLikedUsers = NSArray()
            idLikedUsers = self.photos[0].valueForKey("userLiked")! as! NSArray
            
            
            let mutableDict: NSMutableDictionary = ["location":locationArray, "id":idArray, "category":categoryArray, "albums": albumArray, "description": descriptionArray, "country": countryArray, "largeImage": imagesLargeArray, "geoTag":geoTagArray, "latitude":latArray, "longitude": longArray, "source": sourceArray, "likeCount":likeCountArray, "likedUserId":idLikedUsers,"thumbnails":imagesArray ]
            
            [self.arrayOfimages1 .addObject(mutableDict)]
            
            
            
            
            //////////// user detail get here ////////////
            
            var id = NSString()
            id = self.dataArray .objectAtIndex(i) .valueForKey("_id")! as? NSString ?? ""
            
            //Name of user
            var name = NSString()
            //name = dataArray .objectAtIndex(i) .objectForKey("name")! .objectAtIndex(0) as? NSString ?? ""
            let nameSt:NSArray = (self.dataArray.objectAtIndex(i).objectForKey("name")! as? NSArray)!
            name=""
            if nameSt.count>0 {
                name = nameSt.objectAtIndex(0) as? String ?? ""
            }
            
            
            //Email
            var email = NSString()
            let emailSt:NSArray = (self.dataArray.objectAtIndex(i).objectForKey("email")! as? NSArray)!
            email=""
            if emailSt.count>0 {
                email = emailSt.objectAtIndex(0) as? String ?? ""
                
            }
            
            
            
            var friendsId2 = NSArray()
            
            
            if let friendsId:NSArray = (self.dataArray.objectAtIndex(i).objectForKey("friends") as? NSArray) {
                
                if friendsId.count>0 {
                    friendsId2 = friendsId .objectAtIndex(0) as! NSArray
                }
                
                
                
            }
                
            else{
                friendsId2=[""]
            }
            
            print(friendsId2)
            print(friendsId2.count)
            
            
            var profile = NSString()
            
            // if profile picture is avaliable in the code
            if (self.dataArray .objectAtIndex(i) .objectForKey("picture") != nil)
            {
                
                profile = self.dataArray.objectAtIndex(i) .objectForKey("picture")! .objectAtIndex(0) as? NSString ?? ""
                ////print(profile)
                self.userDetailArray.addObject(["id":id, "email":email, "name":name, "profile":profile ])
            }
            else
            {
                self.userDetailArray.addObject(["id":id, "email":email, "name":name, "profile":"" ])
                //print("no profile picture")
            }
            
            
            
        }
        
        intrestArray .addObject(["userDetail":self.userDetailArray, "images": self.arrayOfimages1])
        
        //save for intrest screen
        
        
        
        self.imagesTableView .reloadData()
        
        
        if countArray.objectForKey("storyCount") != nil {
            if let stCount = countArray.valueForKey("storyCount"){
                
                self.storyListCount.text=String(stCount)
            }
            
        }
        
        
        
        
        if countArray.objectForKey("bucketCount") != nil {
            if let bktCount = countArray.valueForKey("bucketCount"){
                
                bucketListTotalCount=String(bktCount)
            }
            
        }
        
        
        
        
        
        bucketListCount.text = bucketListTotalCount
        
        
       // })
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
///class end
}














    /*
     // MARK: - Navigation
 
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */








////////////MARK:- Extension of collection View ///////////////////////////

/*
extension mainHomeViewController : UITableViewDelegate, UITableViewDataSource {
 
    func tableView(tableView: UITableView,willDisplayCell cell: UITableViewCell,forRowAtIndexPath indexPath: NSIndexPath) {
 
        guard let tableViewCell = cell as? cellClassTableViewCell else { return }
        //here setting the uitableview cell contains collectionview delgate conform to viewcontroller
 
        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row, andForSection: indexPath.section)
 
 
 
    }
 
 
 
    func tableView(tableView: UITableView,
                   didEndDisplayingCell cell: UITableViewCell,
                                        forRowAtIndexPath indexPath: NSIndexPath) {
        
        guard let tableViewCell = cell as? cellClassTableViewCell else { return }
        

 //       tableViewCell.imagesCollectionView.reloadData()
       tableViewCell.contentView.clearsContextBeforeDrawing=true
        
//        tableViewCell.imagesCollectionView.reloadData()
//        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row, andForSection: indexPath.section)
        
       // storedOffsets[indexPath.row] = tableViewCell.collectionViewOffset
    }
    
    
    
}

 */

 
//MARK:-


//MARK:- ///////////////////// Data source and delegates of the collection view in extension/////////////////
//MARK:-

extension mainHomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int   {
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView,numberOfItemsInSection section: Int) -> Int
    {
    return arrayOfimages1[collectionView.tag] .valueForKey("id")! .count
    }
    
    
    
    
    
    func collectionView(collectionView: UICollectionView,cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cellCollectionView",forIndexPath: indexPath)
        
       
//        
//        let queue = NSOperationQueue()
//        
//        let op1 = NSBlockOperation { () -> Void in
//       
//            
//            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
        
       
        
        
        cell.layer.cornerRadius=8
         cell.clipsToBounds=true
        
        
        
        
        
        
        
        if self.arrayOfimages1.count<1 {
            
        }
        else
        {
        
        
        var imageName = NSString()
        var imageName2 = NSString()
        var imageId2 = NSString()
        var imgDesc = NSString()
        
        
        
            //////images in cells
            
            
            
          
            
            let queue = NSOperationQueue()
            
                    let op1 = NSBlockOperation { () -> Void in
            
            
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
            
            
            dispatch_async(dispatch_get_main_queue(), {
                //dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {
                
                var arrImg2 = NSArray()
                //arrImg2 = self.arrayOfimages1[collectionView.tag] .valueForKey("largeImage") as! NSArray
                arrImg2 = self.arrayOfimages1[collectionView.tag] .valueForKey("thumbnails") as! NSArray
                
               
                
                
                let imageName2 = arrImg2[indexPath.row] as! String
                //print(imageName2)
                
                
                ///image of that place
                
//                let locationimage = cell.viewWithTag(7459) as! UIImageView
//                locationimage.layer.cornerRadius = 5
//                locationimage.clipsToBounds = true
//                locationimage.contentMode = .ScaleAspectFill
                
                let url2 = NSURL(string: imageName2 as String)
                
                
                
                
                
               // let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in
                    
                    
               // }
                
                //completion block of the sdwebimageview
              //  locationimage.sd_setImageWithURL(url2, placeholderImage: UIImage(named:"backgroundImage")!, completed: block)
                
                //locationimage.sd_cancelCurrentImageLoad()
                
                
                
                
            })
            
                        })
                        
                        
           
            
            }
            
            
        
            
            
            
             queue.addOperation(op1)
            
            
        
        
           
        
        
        var arrId2 = NSArray()
        arrId2 = self.arrayOfimages1[collectionView.tag] .valueForKey("id") as! NSArray
        
        var arrDesc = NSArray()
        arrDesc = self.arrayOfimages1[collectionView.tag] .valueForKey("description") as! NSArray
        
        
        imageId2 = arrId2[indexPath.row] as? String ?? " "//get id of images
        
        imgDesc = arrDesc[indexPath.row] as? String ?? " "//get description of image
        
        let likeView = cell.viewWithTag(7455)! as UIView
        likeView.alpha = 0
        
            
            
            var countryArr = NSArray()
            countryArr = self.arrayOfimages1[collectionView.tag] .valueForKey("country") as! NSArray
            
            let countryTxt = countryArr[indexPath.row] as? String ?? ""
            
        
        let geoTag = self.arrayOfimages1[collectionView.tag] .valueForKey("geoTag") as! NSArray
        
        
        var location = "\(geoTag[indexPath.row] as? String ?? "")"
        if location == "Not found"{
            location = ""
        }
            
            if location == "" {
                
                location=countryTxt
                
            }
        
        
        let geoTagLbl = cell.viewWithTag(7456)! as! UILabel
        geoTagLbl.text=location as String
        geoTagLbl.lineBreakMode = .ByTruncatingTail
        geoTagLbl.minimumScaleFactor=0.6
        //geoTagLbl.adjustsFontSizeToFitWidth=true
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        var arrCategory = NSArray()
        arrCategory = self.arrayOfimages1[collectionView.tag] .valueForKey("category") as! NSArray
        let newCatRr: NSMutableArray = arrCategory[indexPath.row] as! NSMutableArray
        
        let  newcat2 = NSMutableArray()
        
        for ll in 0..<newCatRr.count {
            
            var stCat = newCatRr.objectAtIndex(ll) as? String ?? ""
            
            
            if stCat == "Random" || stCat == "random" {
                stCat = "Others"
            }
            newcat2 .addObject(stCat)
            
            
        }
        
        //let categ = arrCategory[indexPath.row] .componentsJoinedByString(",")
        let categ = newcat2 .componentsJoinedByString(",")
        
        
        var cityArr = NSArray()
        cityArr = self.arrayOfimages1[collectionView.tag] .valueForKey("location") as! NSArray
        
        var cityName = cityArr[indexPath.row] as? String ?? ""
        
            
            if cityName == ""{
             cityName=countryTxt
            }
            
        // let nameUser = (self.userDetailArray[collectionView.tag] .valueForKey("name") as? String)!
        
        let catglbl = cell.viewWithTag(7461) as! UILabel // category label
        catglbl.text=categ
        
        
       let cityLabel = cell.viewWithTag(7462) as! UILabel
        cityLabel.text = cityName.capitalizedString
        
        
        
        
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        cell.backgroundView = activityIndicatorView
        //self.view.bringSubviewToFront(cell.backgroundView!)
        activityIndicatorView.startAnimating()
        
        
        
        
        
        
        
        ///select view is for show the typr of image facebook, PYT, Checkin
        
        let selectView = cell.viewWithTag(7458)! as! UIImageView
        selectView.hidden=false
        let source = self.arrayOfimages1[collectionView.tag] .valueForKey("source") as! NSArray
        
        selectView.image=UIImage (named: "pytsc")
        
        if source[indexPath.row] as? NSNull != NSNull()  {
            
            
            let sourceStr = source.objectAtIndex(indexPath.row) as? String ?? ""
            if sourceStr == "facebook" {
                
                selectView.image=UIImage (named: "fbsc")
                
            }
            else if sourceStr == "PYT"{
                selectView.image=UIImage (named: "pytsc")
            }
            else{
                selectView.image=UIImage (named: "checkInsc")
            }
            
        }
        
        
        
        
        //MARK:- MANAGE LIKE AND ITS COUNT
        
        dispatch_async(dispatch_get_main_queue(), {
            
            var countLik = NSNumber()
            //MANAGE from the crash
            let likeCountValue = self.arrayOfimages1[collectionView.tag].valueForKey("likeCount") as! NSArray
            if likeCountValue[indexPath.row] as? NSNull != NSNull()  {
                
                countLik = likeCountValue[indexPath.row] as! NSNumber  //as? String ?? "0.0"
                
            }
            else
            {
                countLik=0
            }
            
            
            let likeimg = cell.viewWithTag(7477) as! UIImageView
            let likecountlbl = cell.viewWithTag(7478) as! UILabel
           
            
            
            
            let likedByMe = self.arrayOfimages1[collectionView.tag].valueForKey("likedUserId") as! NSArray
            let likedByMe2 = likedByMe .objectAtIndex(indexPath.row) as! NSArray
            
            //SHOW THE COUNT OF LIKED
            likecountlbl.text=String(countLik)
            likeimg.image=UIImage (named: "like_count")
            
            
            ///////-  Show liked by me-/////
            if likedByMe2.count>0
            {
                if likedByMe2.containsObject(self.uId)
                {
                    
                    
                    if self.likeCount.valueForKey("imageId").containsObject(imageId2) {
                        
                        let indexOfImageId = self.likeCount.valueForKey("imageId") .indexOfObject(imageId2)
                        
                        if self.likeCount.objectAtIndex(indexOfImageId) .valueForKey("like") as! Bool == true {
                            likeimg.image=UIImage (named: "likedCount")
                            let staticCount = self.likeCount.objectAtIndex(indexOfImageId).valueForKey("count") as? NSNumber
                            likecountlbl.text=String(staticCount!)// String(self.addTheLikes(staticCount!))
                            
                            
                            
                        }
                        else{
                            likeimg.image=UIImage (named: "like_count")
                            let staticCount = self.likeCount.objectAtIndex(indexOfImageId).valueForKey("count") as? NSNumber
                            likecountlbl.text=String(staticCount!) //(self.addTheLikes(staticCount!))
                        }
                    }
                        
                        //if not contains the imageId
                    else
                    {
                        self.likeCount .addObject(["imageId":imageId2,"userId":self.uId, "like": true, "count": countLik])
                        print(self.likeCount)
                        likecountlbl.text=String(countLik)
                        likeimg.image=UIImage (named: "likedCount")
                    }
                    
                    
                    
                }
                    
                else
                {
                    if self.likeCount.valueForKey("imageId").containsObject(imageId2) {
                        
                        let indexOfImageId = self.likeCount.valueForKey("imageId") .indexOfObject(imageId2)
                        
                        if self.likeCount.objectAtIndex(indexOfImageId) .valueForKey("like") as! Bool == true {
                            likeimg.image=UIImage (named: "likedCount")
                            let staticCount = self.likeCount.objectAtIndex(indexOfImageId).valueForKey("count") as? NSNumber
                            likecountlbl.text=String(staticCount!)
                            
                        }
                        else{
                            let staticCount = self.likeCount.objectAtIndex(indexOfImageId).valueForKey("count") as? NSNumber
                            likecountlbl.text=String(staticCount!)
                            likeimg.image=UIImage (named: "like_count")
                        }
                    }
                    
                    
                    
                }
                
                
                
            }
            else{
                
                if self.likeCount.valueForKey("imageId").containsObject(imageId2) {
                    
                    let indexOfImageId = self.likeCount.valueForKey("imageId") .indexOfObject(imageId2)
                    
                    if self.likeCount.objectAtIndex(indexOfImageId) .valueForKey("like") as! Bool == true {
                        likeimg.image=UIImage (named: "likedCount")
                        let staticCount = self.likeCount.objectAtIndex(indexOfImageId).valueForKey("count") as? NSNumber
                        likecountlbl.text=String(staticCount!)
                        
                    }
                    else{
                        let staticCount = self.likeCount.objectAtIndex(indexOfImageId).valueForKey("count") as? NSNumber
                        likecountlbl.text=String(staticCount!)
                        likeimg.image=UIImage (named: "like_count")
                    }
                }
                
                
                
            }
            
            
            
            
            
            
            
            
            
            
            
            ////Add gesture in collection view
            
            var text = String()
            text = "\(collectionView.tag) \(indexPath.row)"
            
            /////////Single Tap
            let singleTapGesture = GestureViewClass(target: self, action: #selector(mainHomeViewController.SingleTap(_:)))
            singleTapGesture.numberOfTapsRequired = 1 // Optional for single tap
            singleTapGesture.gestureData=text
            cell.addGestureRecognizer(singleTapGesture)
            
            
            
            //////Double tap gesture
            let gestureDoubleTap = GestureViewClass(target: self, action: #selector(mainHomeViewController.doubleTap(_:)))
            gestureDoubleTap.numberOfTapsRequired=2
            gestureDoubleTap.gestureData=text
            cell.addGestureRecognizer(gestureDoubleTap)
            
            singleTapGesture.requireGestureRecognizerToFail(gestureDoubleTap)
            
            
            
            /////Long Tap Gesture
            cell.tag=1000*collectionView.tag+indexPath.row
            
            // print(cell.tag)
            
            let longView = UIView()
            longView.frame=cell.frame
            longView.tag=1000*collectionView.tag+indexPath.row
            //cell .addSubview(longView)
            
            
            let longTapGest = LongPressGesture(target: self, action: #selector(mainHomeViewController.longTap(_:)))
            // longTapGest.longData=text //String(1000*collectionView.tag+indexPath.row)
            //longTapGest.accessibilityValue=text
            //  longView.addGestureRecognizer(longTapGest)
            cell.addGestureRecognizer(longTapGest)
            
            
            
            
            
            
            
        })
        
        
        /////////------End LIKE ///////////////////
        
        
        
        
        
        
        
        
        
       
        
                    /// for bo
                    let whiteView = cell.viewWithTag(7460)
                    whiteView?.layer.cornerRadius=5
                    whiteView?.clipsToBounds=true
                    
                    
            cell.layer.shouldRasterize = true
            cell.layer.rasterizationScale = UIScreen.mainScreen().scale

                    

              //  }
                
                
                
                
                
                
          //  })
       
        
       // queue.addOperation(op1)
                
                
                
        }
        
                
                
                return cell
    }
    
    
    
    
   
    
    
    
    
    
    
    
    
    
    
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        
        
        //print("collectionviewtag:\(collectionView.tag) +  indexpathrow:\(indexPath.row)")
       
        
        
        
    }
    
    
    
    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath)
    {
        for recognizer in cell.gestureRecognizers ?? [] {
            cell.removeGestureRecognizer(recognizer)
        }
        
        
        
        
        
        
        
    }
    
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView==imagesTableView {
           // print("Table Scrolling")
        }
        else{
           // print("collection Scrolling")
        }
        
        
        
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
     
        
        if scrollView==imagesTableView {
            //print("Table Scrolling")
        }
        else{
            //print("collection Scrolling")
           // SDWebImageManager.sharedManager().cancelAll()
        }
        
    }
    
    
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath){
        
        
        
        var arrImg2 = NSArray()
         arrImg2 = self.arrayOfimages1[collectionView.tag] .valueForKey("thumbnails") as! NSArray
        
        // dispatch_async(dispatch_get_main_queue(), {
        
        
        //arrImg2 = self.arrayOfimages1[collectionView.tag] .valueForKey("largeImage") as! NSArray
       
        
        
        let imageName2 = arrImg2[indexPath.row] as! String
        //print(imageName2)
        
        
        ///image of that place
        
        let locationimage = cell.viewWithTag(7459) as! UIImageView
        locationimage.layer.cornerRadius = 5
        locationimage.clipsToBounds = true
        locationimage.contentMode = .ScaleAspectFill
        
        let url2 = NSURL(string: imageName2 as String)
        
        
        
        
//        let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in
//            
//            
//        }
        
        //completion block of the sdwebimageview
       // locationimage.sd_setImageWithURL(url2, placeholderImage: UIImage(named:"backgroundImage")!, completed: block)
        
            locationimage.sd_setImageWithURL(url2, placeholderImage: UIImage (named: "backgroundImage"))
            
            
        
        
        
            print(indexPath.row)
            print(arrImg2.count)
            
           // })
           
        
        
        
        
        
                if indexPath.row > 0 && indexPath.row < arrImg2.count - 1{
                
                    
                let imageNameBack = arrImg2[indexPath.row - 1] as! String
                let urlBack = NSURL(string: imageNameBack as String)
                    let tempImgView = UIImageView()
                    tempImgView.hidden=true
                    
                    tempImgView .sd_setImageWithURL(urlBack)
                    
                    
                    let imageNameNext = arrImg2[indexPath.row + 1] as! String
                    let urlNext = NSURL(string: imageNameNext as String)
                     tempImgView .sd_setImageWithURL(urlNext)
                    
                    
                    
                    
                }
                
                
                
                
                
          
            
            

            
         

        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let width1 = collectionView.frame.size.width/1.25   //1.8
        
        let height3: CGFloat = self.imagesTableView.rowHeight - 56
        
        return CGSize(width: width1 , height: height3) // The size of one cell
    }
    
    
     func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        // return UIEdgeInsetsMake(0,8,0,8);  // top, left, bottom, right
        return UIEdgeInsetsMake(0, 4, 0, 0)
        // top, left, bottom, right
    }
    
    
   
    
    
   
    

    
    
    
    
    
   
    
    
    
    
    //MARK:-
   //MARK: ////////////////// Function To Manage the count add and subtract of the likes////////////////
    //ADD Count of likes
    func addTheLikes(likeCount:NSNumber) -> Int {
        
        var returnCount = Int()
        
        returnCount = Int(likeCount) + 1
        
        
        return returnCount
        
    }
    
    ////Subtract Count of likes
    func subtractTheLikes(likeCount:NSNumber) -> Int {
        
        var returnCount = Int()
        
        returnCount = Int(likeCount) - 1
        
        return returnCount
        
    }
    
//    /////// Check that image is liked or not
//
//    func checkLikedImage(imgId:NSString) -> Void {
//
//        print(imgId)
//
//
//
//    }
    
    
    
    
    
    
    
    
    
    
   ////////////////////////////////////////////////////////////////////////////
    
    //MARK:-///////////////Manage Gesture in collectionview Long tap , double tap and single tap////////////
    //MARK:-
   
    //MARK: Long Tap
    func longTap(sender: LongPressGesture) {
        
      // dispatch_async(dispatch_get_main_queue(), {
        
        storyBool=true
        
        
        
        if sender.state == .Began
        {
            
            let a:Int? = (sender.view?.tag)! / 1000
            let b:Int? = (sender.view?.tag)! % 1000
            
           // print("table=\(a!), Collect\(b!)")
            
            collectionIndex = b!
            tableIndex = a!
            longTapedView=sender.view!

            var arrId = NSArray()
            arrId = self.arrayOfimages1[a!] .valueForKey("id") as! NSArray
            let imageId = arrId[b!] as! String
            
            
            
            if countArray.objectForKey("storyImages") != nil  {
                
                //let countst = countArray.valueForKey("storyCount") as! NSNumber
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
                 addToBucketLblInPopup.text="Add To Bucket List"
                addToBucket.userInteractionEnabled=true
            if countArray.objectForKey("bucketImages") != nil  {
                
                //let countst = countArray.valueForKey("storyCount") as! NSNumber
                let countBkt = countArray.valueForKey("bucketImages") as! NSArray
                
                if countBkt.count>0 {
                    
                    print(countBkt)
                    if countBkt.containsObject(imageId) {
                        
                        addToBucketLblInPopup.text="Bucketed"
                        addToBucket.userInteractionEnabled=false
                        
                    }
                    
                    
                }
                
                
                
            }
            

            
            
            
            
            
            
            
            
            
            
            
            /////-Delete the uploaded photos from facebook
            
            let source = self.arrayOfimages1[a!] .valueForKey("source") as! NSArray
            
           detailSub5Bottom.constant = -(detailSub4.frame.size.height)
            detailSub4.hidden=true
            
            if source[b!] as? NSNull != NSNull()  {
                
                
                let sourceStr = source.objectAtIndex(b!) as? String ?? ""
                if sourceStr == "PYT" {
                    
                    print(userDetailArray.objectAtIndex(a!).valueForKey("id"))
                    
                    if userDetailArray.objectAtIndex(a!).valueForKey("id") as? String == uId {
                        
                        print("Enter if match the user id")
                        
                        if detailSub5Bottom.constant<9
                        {
                            detailSub5Bottom.constant = 9
                            detailSub4.hidden=false
                        }
                        
                        
                        
                    }
                    
                    
                    
                    
                    
                    ///can delete
                    
                }
               
                
            }
            
            
            
            ////////
            
            
            
            
            
            ////For like unlike
            
            likeLabelPopup.text="Like"
             likeImage.image=UIImage (named: "selectionLike")
            if likeCount.valueForKey("imageId") .containsObject(imageId) {
                
                
                
                let index = self.likeCount.valueForKey("imageId").indexOfObject(imageId)
                
                if self.likeCount.objectAtIndex(index).valueForKey("like") as! Bool == true {
                    likeLabelPopup.text="Unlike"
                    likeImage.image=UIImage (named: "unlikeSelection")
                }
               
            }
            
            
           
            
            
            self.detailSelectBtnAction(true)
        }
        
        
        
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(true, forKey: "refreshStory")
        

        
        
           /*
            
            if sender.state == .Began
            {
                let defaults = NSUserDefaults.standardUserDefaults()
                let name = defaults.stringForKey("userLoginId")
               // if user is not logged in then go to login screen
                if name==""
                {
              
                            self.tabBarController?.tabBar.hidden = true
                    
                            let nxtObj = self.storyboard?.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
                    
                            dispatch_async(dispatch_get_main_queue(), {
                                self.navigationController! .pushViewController(nxtObj, animated: true)
                                self.dismissViewControllerAnimated(true, completion: {})
                            })
                    
                    
                            let defaults = NSUserDefaults.standardUserDefaults()
                            defaults.setObject("", forKey: "userLoginId")
                                               
                    
                }
                    
               // if logged in then do other stuff
                
                else
                {
                
                print("LONGVIEW TAG_ \(sender.view?.tag)")
                
                let a:Int? = (sender.view?.tag)! / 1000
                let b:Int? = (sender.view?.tag)! % 1000
                
                
                
                    collectionIndex = b!
                    tableIndex = a!
                    
                    
                
                print(a)//collectionview tag
                print(b)//indexpath of row
                let viewTaped = sender.view
                print(viewTaped)
                
                let selectView = viewTaped?.viewWithTag(7458)
                
                
                
                
                
                var imageName2 = NSString()
                var imageId = NSString()
                var desc = NSString()
                var categ = NSString()
                var nameUser = NSString()
                var country = NSString()
                var lat = NSNumber()
                var long = NSNumber()
                    
                
                var arrImg2 = NSArray()
                arrImg2 = self.arrayOfimages1[a!] .valueForKey("largeImage") as! NSArray
                
                var arrId = NSArray()
                arrId = self.arrayOfimages1[a!] .valueForKey("id") as! NSArray
                
                var arrDesc = NSArray()
                arrDesc = self.arrayOfimages1[a!] .valueForKey("description") as! NSArray
                
                var arrCategory = NSArray()
                arrCategory = self.arrayOfimages1[a!] .valueForKey("category") as! NSArray
                
                nameUser = (self.userDetailArray[a!] .valueForKey("name") as? String)!
                
                let geoTag = self.arrayOfimages1[a!] .valueForKey("geoTag") as! NSArray
                
                    var arrCountry = NSArray()
                    arrCountry = self.arrayOfimages1[a!].valueForKey("country") as! NSArray
                    country = arrCountry[b!] as! NSString
                
                    //MANAGE from the crash
                    let latArr = self.arrayOfimages1[a!].valueForKey("latitude") as! NSArray
                    if latArr[b!] as? NSNull != NSNull()  {
                        
                        lat = latArr[b!] as! NSNumber  //as? String ?? "0.0"
                        
                        let longArr = self.arrayOfimages1[a!].valueForKey("longitude") as! NSArray
                        long = longArr[b!] as! NSNumber //as? String ?? "0.0"
                    }else{
                        lat=0
                        long=0
                    }
                    
                    
                
                //print(arrCategory)
                
                imageName2 = arrImg2[b!] as! String
                imageId = arrId[b!] as! String
                
                
                if let descc = arrDesc[b!] as? String {
                    desc = descc
                }
                else{
                    desc = "NA"
                }
                
                
                categ = arrCategory[b!] .componentsJoinedByString(",")
                let location = "\(geoTag[b!] as? String ?? "")"
                
                    
                
                if self.selectedCell .valueForKey("id").containsObject(imageId){
                    let index = self.selectedCell.valueForKey("id").indexOfObject(imageId)
                    
                    //10153101414156609
                    let defaults = NSUserDefaults.standardUserDefaults()
                    let uId = defaults .stringForKey("userLoginId")
                    let dataStr = "userId=\(uId)&imageId=\(imageId)&place=\(country.lowercaseString)"
                    
                   print(dataStr)
                    
                    apiClassStory.sharedInstance().postRequestDeleteStory(dataStr, viewController: self)
                    
                    
                  
                    
                    self.selectedCell .removeObjectAtIndex(index)
                    selectView?.hidden = true
                    
                    if self.selectedCell.count<1{
                        
                  
                    }
                    
                    
                    
                }
                    
                else
                {
                    self.selectedCell .addObject(["id": imageId, "imageLink": imageName2, "description": desc, "category":categ, "location":self.globalLocation, "type":self.globalType, "name": nameUser, "geoTag": location, "index":a!, "collectionIndex":b!, "latitude": lat, "long": long])
                    
                    selectView?.hidden = true
                  
                    //self.proceedBtnAction(self)
                    
                   self.detailSelectBtnAction(true)
                    
                    
                    
                    
                    
//                    
//        let profileImage = self.userDetailArray .objectAtIndex(a!) .valueForKey("profile")! as? NSString ?? ""
//                    
//                    
//                    
//                    let defaults = NSUserDefaults.standardUserDefaults()
//                    let uId = defaults .stringForKey("userLoginId")
//                    
//                    let dat: NSDictionary = ["userid": "\(uId)", "id": imageId, "imageLink": imageName2, "location": country.lowercaseString, "source":"facebook", "latitude": lat, "longitude": long, "geoTag":location, "category":categ, "location":"", "description":desc, "userName":nameUser,"type":self.globalType, "profileImage":profileImage ]
//                    
//                    var postDict = NSDictionary()
//                    
//                    postDict = dat
//                    
//                    print("Post parameters to select the images for story--- \(postDict)")
//                    
//                   //add image to story
//                    apiClass.sharedInstance().postRequestWithMultipleImage("", parameters: postDict, viewController: self)
//                    
//
                    
                    
                }
                    
                
                    
                    
                
                
                
            }
            //  })
            

            
        }
        */
        
        
    }
    
    
   
 
    //MARK:- Double Tap
 
   func doubleTap(sender: GestureViewClass) {
 
 
 
    let fullName = sender.gestureData as String
    let fullNameArr = fullName.characters.split{$0 == " "}.map(String.init)
    //separate the string and change into integer
    
    let colViewTag = fullNameArr[0] as String
     let a:Int? = Int(colViewTag)
    
    let indexPath = fullNameArr[1]
    let b:Int? = Int(indexPath)
    
    
    //print(a)
    //print(b)
    
    let viewTaped = sender.view
    let likedView = viewTaped?.viewWithTag(7455)
    
        likedView?.alpha = 0
    
    let likecountlbl = viewTaped?.viewWithTag(7478) as! UILabel
    
   // hide and show the view of like
    
   
    let likeimg = viewTaped?.viewWithTag(7477) as! UIImageView
    
    let likeimglbl = viewTaped?.viewWithTag(7488) as! UILabel
    
    
    
    
    var arrId = NSArray()
    arrId = self.arrayOfimages1[a!] .valueForKey("id") as! NSArray
    let imageId = arrId[b!] as? String ?? ""
    
    
    
    //MANAGE from the crash and get the like count from database
   
    var countLik = NSNumber()
    let likeCountValue = self.arrayOfimages1[a!].valueForKey("likeCount") as! NSArray
    if likeCountValue[b!] as? NSNull != NSNull()  {
        
        countLik = likeCountValue[b!] as! NSNumber  //as? String ?? "0.0"
        
        
    }
    else
    {
        countLik=0
        
    }
    
    
    
    
    
    //MARK: LIKE COUNT MANAGE
    
    
    
    let otherUserId = userDetailArray.objectAtIndex(a!).valueForKey("id") as? String ?? ""
    
    
    print("like image tapped")
    
    likeimglbl.text="You Liked This!!!"
    
    if self.likeCount.count>0 {
        if self.likeCount.valueForKey("imageId") .containsObject(imageId) {
            
            let index = self.likeCount.valueForKey("imageId").indexOfObject(imageId)
            
            if self.likeCount.objectAtIndex(index).valueForKey("like") as! Bool == true {
                
                let staticCount = self.likeCount.objectAtIndex(index).valueForKey("count") as? NSNumber
                likecountlbl.text=String(self.subtractTheLikes(staticCount!))
                
                
                self.likeCount .removeObjectAtIndex(index)
                  likeimglbl.text="You Unliked This!!!"
                self.likeCount .addObject(["userId":uId, "imageId":imageId, "like":false, "count": self.subtractTheLikes(staticCount!)])
                print(self.likeCount.lastObject)
                
                 likedView?.alpha = 1
                
                UIView.animateWithDuration(1.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                    likedView?.alpha = 0
                    }, completion: nil)
                
                
                
                likeimg.image=UIImage (named: "like_count")
                
                let dat: NSDictionary = ["userId": "\(otherUserId)", "photoId":"\(imageId)", "userLiked":"\(uId)", "status":"0"]
                print("Post to like picture---- \(dat)")
                 dispatch_async(dispatch_get_main_queue(), {
                apiClass.sharedInstance().postRequestLikeUnlikeImage(dat, viewController: self)
                })
                
            }
            else
            {
                let staticCount = self.likeCount.objectAtIndex(index).valueForKey("count") as? NSNumber
                likecountlbl.text=String(self.addTheLikes(staticCount!))
                
                self.likeCount .removeObjectAtIndex(index)
                self.likeCount .addObject(["userId":uId, "imageId":imageId, "like":true, "count": self.addTheLikes(staticCount!)])
                
                
                print(self.likeCount.lastObject)
                
                likeimg.image=UIImage (named: "likedCount")
                likedView?.alpha = 1
                let dat: NSDictionary = ["userId": "\(otherUserId)", "photoId":"\(imageId)", "userLiked":"\(uId)", "status":"1"]
                
                
                UIView.animateWithDuration(1.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                    likedView?.alpha = 0
                    }, completion: nil)
                
                print("Post to like picture---- \(dat)")
                 dispatch_async(dispatch_get_main_queue(), {
                apiClass.sharedInstance().postRequestLikeUnlikeImage(dat, viewController: self)
                })
                
            }
        }
            // if not liked already
        else{
            self.likeCount .addObject(["userId":uId, "imageId":imageId, "like":true, "count": self.addTheLikes(countLik)])
            likedView?.alpha = 1
            likeimg.image=UIImage (named: "likedCount")
             likecountlbl.text=String(self.addTheLikes(countLik))
            let dat: NSDictionary = ["userId": "\(otherUserId)", "photoId":"\(imageId)", "userLiked":"\(uId)", "status":"1"]
          
            UIView.animateWithDuration(1.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                likedView?.alpha = 0
                }, completion: nil)
            
            
            print("Post to like picture---- \(dat)")
             dispatch_async(dispatch_get_main_queue(), {
            apiClass.sharedInstance().postRequestLikeUnlikeImage(dat, viewController: self)
            })
        }

    }
    
    else
    
    {
        
        self.likeCount .addObject(["userId":uId, "count":self.addTheLikes(countLik), "like": true, "imageId": imageId])
        likecountlbl.text=String(self.addTheLikes(countLik))
        likeimg.image=UIImage (named: "likedCount")
        likedView?.alpha = 1
        let dat: NSDictionary = ["userId": "\(otherUserId)", "photoId":"\(imageId)", "userLiked":"\(uId)", "status":"1"]
        
        UIView.animateWithDuration(1.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            likedView?.alpha = 0
            }, completion: nil)
        
        print("Post to like picture---- \(dat)")
         dispatch_async(dispatch_get_main_queue(), {
        apiClass.sharedInstance().postRequestLikeUnlikeImage(dat, viewController: self)
         })

    }
    
    
            
    
    
    
//    
//    UIView.animateWithDuration(1.4, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
//        likedView?.alpha = 0
//        }, completion: nil)
    
    
    
    
    
    
    
    }

    
    
    //MARK:- Single tap action
    //MARK:-
    
    func SingleTap(sender: GestureViewClass) {
        
        NSURLCache.sharedURLCache().removeAllCachedResponses()
        
        dispatch_async(dispatch_get_main_queue(), {
        
        let fullName = sender.gestureData as String
        let fullNameArr = fullName.characters.split{$0 == " "}.map(String.init)
        //separate the string and change into integer
        
        let colViewTag = fullNameArr[0] as String
        let a:Int? = Int(colViewTag)
        
        let indexPath = fullNameArr[1]
        let b:Int? = Int(indexPath)
        
        
        print(a)//CollectionView Tag
        print(b)//IndexPath of CollectionView
        
           
        
            /////  Manage the single tap data
        var arrImg = NSArray()//Large image
        var imageName = NSString()//large image string
        
        var arrImg2 = NSArray()
        var imageStandard = NSString()
            
         arrImg = self.arrayOfimages1[a!] .valueForKey("largeImage") as! NSArray
         arrImg2 = self.arrayOfimages1[a!] .valueForKey("thumbnails") as! NSArray
            
            imageStandard = arrImg2[b!] as! String
            imageName = arrImg[b!] as! String
       
       
        
        
        var location = NSString()
        var arrayLocation = NSArray()
        var arrayCountry = NSArray()
        var arrayImageId = NSArray()
        var cityName = NSString()
            
        arrayLocation = self.arrayOfimages1[a!] .valueForKey("location") as! NSArray
        arrayCountry = self.arrayOfimages1[a!] .valueForKey("country") as! NSArray
         arrayImageId = self.arrayOfimages1[a!] .valueForKey("id") as! NSArray
            
            cityName = arrayLocation[b!] as? String ?? ""
            if cityName == ""{
                
             cityName = self.globalLocation
            }
            
            
            
            print("City Name= \(cityName)")
            
            
        let countryName = arrayCountry[b!] as? String ?? "\(self.globalLocation)"
            
            
        let geoTag = self.arrayOfimages1[a!] .valueForKey("geoTag") as! NSArray
            
            
            
            
            
            
            var sendgeoTag = geoTag[b!] as? String ?? ""
         
            let fullName22 = sendgeoTag
            let fullNameArr22 = fullName22.characters.split{$0 == ","}.map(String.init)
           
            if fullNameArr22.count>0{
                sendgeoTag = fullNameArr22[0]
            }
            
            
            
           
           
            // remove the another part of string
            let changeStr:NSString = sendgeoTag
            let ddd = changeStr.stringByReplacingOccurrencesOfString("&", withString: " and ") //replace & with and
            sendgeoTag = ddd
            
            
            
            
            
         location = "\(self.captitalString(geoTag[b!] as? String ?? "")), \(self.captitalString(arrayLocation[b!] as? String ?? "")), \(self.captitalString(arrayCountry[b!] as? String ?? ""))"
            
           
            
            let multipleImgs = NSMutableArray()
            let multipleImgStandard = NSMutableArray()
            
            for i in 0..<geoTag.count{
                
                if( geoTag[b!]  .isEqual(geoTag[i]) ) {
                    
                    if imageName == arrImg[i] as! String{
                        
                    }
                    else
                    {
                    multipleImgs .addObject(arrImg[i] as! String)
                    multipleImgStandard .addObject(arrImg2[i] as! String)
                        }
                }
                
            }
            
            
            
            
            
      
            
        let profileImage = self.userDetailArray .objectAtIndex(a!) .valueForKey("profile")! as! NSString
            
            
            
        
        let arrDes = self.arrayOfimages1[a!] .valueForKey("description") as! NSArray
        let str = arrDes[b!] as? NSString ?? ""
       
        
            
            //imageId
             let imageId = arrayImageId[b!] as! String
            
        
        //print(str)
        ///open new view
        
            var arrCategory = NSArray()
            arrCategory = self.arrayOfimages1[a!] .valueForKey("category") as! NSArray
            
           
          //  print(arrCategory)
            var catType = "Other"
            let source = self.arrayOfimages1[a!] .valueForKey("source") as! NSArray
            
            
            if source[b!] as? NSNull != NSNull()  {
                
                
                let sourceStr = source.objectAtIndex(b!) as? String ?? ""
                if sourceStr == "PYT" {
                    catType = "PYT"
                    
                    }
                    
                    
                    
                    
                    
                    ///can delete
                    
                }
            
            
            
           
            
            
            multipleImgs .insertObject(imageName, atIndex: 0)
            multipleImgStandard .insertObject(imageStandard, atIndex: 0)
            
            
           let name = self.userDetailArray .objectAtIndex(a!) .valueForKey("name") as? String ?? " "
           let arrayData = NSMutableArray()
            
            
            
            //MANAGE from the crash in caseof latitude and longitude
            var lat = NSNumber()
            var long = NSNumber()
            let latArr = self.arrayOfimages1[a!].valueForKey("latitude") as! NSArray
            if latArr[b!] as? NSNull != NSNull()  {
                
                lat = latArr[b!] as! NSNumber  //as? String ?? "0.0"
                
                let longArr = self.arrayOfimages1[a!].valueForKey("longitude") as! NSArray
                long = longArr[b!] as! NSNumber //as? String ?? "0.0"
            }else{
                lat=0
                long=0
            }
            
            
            let catArrSt = arrCategory.objectAtIndex(b!) as! NSArray
            
            let strcat = catArrSt.componentsJoinedByString(",")
        
            
            
            
            
            
            
//             arrayData .addObject(["Description":str, "profileImage": profileImage, "location": location, "locationImage": imageName,"CountryName": countryName, "Venue": self.globalLocation, "geoTag": sendgeoTag, "userName":name, "Type": catType,"imageId":imageId,"latitude": lat, "longitude":long, "multipleImages": multipleImgs, "Category": strcat])

            
            
            
            
            //Likes count
            
            var countLik = NSNumber()
            let likeCountValue = self.arrayOfimages1[a!].valueForKey("likeCount") as! NSArray
            if likeCountValue[b!] as? NSNull != NSNull()  {
                
                countLik = likeCountValue[b!] as! NSNumber  //as? String ?? "0.0"
                
                
            }else
            {
                countLik=0
                
            }
            
            
            
            
            
            
            
             let otherUserId = self.userDetailArray.objectAtIndex(a!).valueForKey("id") as? String ?? ""
            
            
            
            
            var mutableDic = NSMutableDictionary()
            
            if self.likeCount.count>0 {
                if self.likeCount.valueForKey("imageId") .containsObject(imageId) {
                    
                    let index = self.likeCount.valueForKey("imageId").indexOfObject(imageId)
                    
                    if self.likeCount.objectAtIndex(index).valueForKey("like") as! Bool == true {
                        
                        mutableDic = ["Description":str, "profileImage": profileImage, "location": location, "locationImage": imageName,"CountryName": countryName, "Venue": cityName, "geoTag": sendgeoTag, "userName":name, "Type": catType,"imageId":imageId,"latitude": lat, "longitude":long, "multipleImagesLarge": multipleImgs, "Category": strcat, "likeBool":true, "otherUserId":otherUserId, "cityName":cityName, "likeCount": countLik, "standardImage":imageStandard, "multipleImagesStandard": multipleImgStandard ]
                        
                        arrayData .addObject(mutableDic)
                    }
                        
                    else
                    {
                        mutableDic = ["Description":str, "profileImage": profileImage, "location": location, "locationImage": imageName,"CountryName": countryName, "Venue": cityName, "geoTag": sendgeoTag, "userName":name, "Type": catType,"imageId":imageId,"latitude": lat, "longitude":long, "multipleImagesLarge": multipleImgs, "Category": strcat, "likeBool":false, "otherUserId":otherUserId, "cityName":cityName, "likeCount": countLik, "standardImage":imageStandard, "multipleImagesStandard": multipleImgStandard]
                        
                        arrayData .addObject(mutableDic)
                    }
                    
                }
                else{
                    mutableDic = ["Description":str, "profileImage": profileImage, "location": location, "locationImage": imageName,"CountryName": countryName, "Venue": cityName, "geoTag": sendgeoTag, "userName":name, "Type": catType,"imageId":imageId,"latitude": lat, "longitude":long, "multipleImagesLarge": multipleImgs, "Category": strcat, "likeBool":false, "otherUserId":otherUserId, "cityName":cityName, "likeCount": countLik, "standardImage":imageStandard, "multipleImagesStandard": multipleImgStandard]
                    
                    arrayData .addObject(mutableDic)
                }
                
            }
            else
            {
                mutableDic = ["Description":str, "profileImage": profileImage, "location": location, "locationImage": imageName,"CountryName": countryName, "Venue": cityName, "geoTag": sendgeoTag, "userName":name, "Type": catType,"imageId":imageId,"latitude": lat, "longitude":long, "multipleImagesLarge": multipleImgs, "Category": strcat, "likeBool":false, "otherUserId":otherUserId, "cityName":cityName, "likeCount": countLik, "standardImage":imageStandard, "multipleImagesStandard": multipleImgStandard]
                
                arrayData .addObject(mutableDic)
            }
            
            
            
            
            
            
            
            
            //print(arrayData)
            
            
            
            let nxtObj2 = self.storyboard?.instantiateViewControllerWithIdentifier("detailViewController") as! detailViewController
            nxtObj2.arrayWithData=arrayData
             nxtObj2.fromStory=false
            nxtObj2.countLikes=self.likeCount
             nxtObj2.fromInterest = false
            
        // dispatch_async(dispatch_get_main_queue(), {
            
            self.navigationController! .pushViewController(nxtObj2, animated: true)
            
            
           
            
            
            //})
            
            
        
        //self.showView(imageName, profileImg: profileImage, tagBtn: fullName, multipleImages: multipleImgs)

        })
        
        
    }
    
     //MARK:-
    ///// MARK:- create the capital string
    
    func captitalString(nameString:NSString) -> String {
        
        var nameString2 = nameString
        nameString2 = nameString.capitalizedString
        return nameString2 as String
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    ////// not in use Now
    
//    func showView(imageLink:NSString, profileImg:NSString, tagBtn: NSString, multipleImages:NSMutableArray) -> Void {
//        
//        
//        
//          var sdWebImageSource = [InputSource]()
//        
//         dispatch_async(dispatch_get_main_queue(), {
//        
//       
//        
//        let transition:CATransition = CATransition()
//        transition.duration = 0.4
//        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
//        transition.type = kCATransitionPush
//        transition.subtype = kCATransitionFromTop
//       
//        self.detailView!.layer.addAnimation(transition, forKey: kCATransition)
//        
//        self.detailView.hidden = false
//       
//        self.view .bringSubviewToFront(self.detailView)
//       
//        
//        
//            self.tabBarController?.tabBar.userInteractionEnabled=false
//            self.tabBarController?.tabBar.alpha = 0.6
//
//        
//        
//        
//        
//      
//            
//            
//            
//      
//        
//        //combine the collectionView Tag and indexpath.tag
//        
//       let strin = tagBtn as String
//        let fullNameArr = strin.characters.split{$0 == " "}.map(String.init)
//        //separate the string and change into integer
//        
//        let colViewTag = fullNameArr[0] as String
//        let indexPath = fullNameArr[1]
//       
//        //let combineTag = "\(colViewTag)999\(indexPath)"
//        self.tagForBtnCollection = Int(colViewTag)!
//        self.tagForBtnIndex = Int(indexPath)!
//       
//        
//        
//       
//        
//        })
//        
//        
//    }
    
    
    
}






