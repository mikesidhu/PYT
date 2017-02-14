//
//  storyViewcontrollerViewController.swift
//  PYT
//
//  Created by Niteesh on 22/11/16.
//  Copyright © 2016 appsMaven. All rights reserved.
//

import UIKit
import GoogleMaps
import HMSegmentedControl
import SDWebImage
import MBProgressHUD

class storyViewcontrollerViewController: UIViewController, apiClassStoryDelegate, GMSMapViewDelegate {

    
    @IBOutlet var storyTableView: UITableView!
    
    @IBOutlet var heightOfSegmentControl: NSLayoutConstraint!
   
    
    //data variables
    var segmentArray = NSMutableArray()
    var storyArray = NSMutableArray()
    var segmentIndex = Int()
    var tableIndex = Int()
    var selectedArray = NSMutableArray()
    var selectedIdArray = NSMutableArray()
    
    
    @IBOutlet var topMapView: UIView!
    
    @IBOutlet var heightOfScrollContent: NSLayoutConstraint! //height of content of scrollview
    @IBOutlet var segmentControl: HMSegmentedControl!
    
    
    @IBOutlet var headerLabel: UILabel!
   
    @IBOutlet var bookingBtnOutlet: UIButton!
    
    @IBOutlet var mapView: GMSMapView!
    
    @IBOutlet var selectedCountLabel: UILabel!
    var refreshControl: UIRefreshControl!
    
    
    @IBOutlet var bucketBtn: UIButton!
    @IBOutlet var bucketCount: UILabel!
    
    
    @IBOutlet var storyNameLabel: UILabel!
    
    @IBOutlet weak var storyAllDeleteOutlet: UIButton!
    
    @IBOutlet var storyCountLabel: UILabel!
    @IBOutlet var selectAllBtnOutlet: UIButton!
    
    
    
    //detail
    @IBOutlet var detailView: UIView!
    @IBOutlet var proceedImage: UIImageView!
    @IBOutlet var addToBucket: UIImageView!
    
    
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden=true //hide the navigationBar
         self.tabBarController?.tabBar.hidden = true
        
       
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        segmentIndex=0
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(true, forKey: "refreshStory")
        
        apiClassStory.sharedInstance().delegate=self
        
        storyTableView.scrollEnabled=false
     
        
        
        self.mapView.delegate=self
        
        
        
        
        //adjust height of rows automatically
        storyTableView.estimatedRowHeight =  225.0
        
        
        mapView.layer.cornerRadius=0
        mapView.clipsToBounds=true
        heightOfScrollContent.constant = 0
        selectAllBtnOutlet.setTitle("", forState: UIControlState .Normal)
        self.storyTableView.reloadData()
        
        let firstLaunch = defaults.boolForKey("refreshStory")
        
        if firstLaunch {
            print("refresh")
            
            
            
            //106337066460748 tanvMam
            let defaults = NSUserDefaults.standardUserDefaults()
            let uId = defaults .stringForKey("userLoginId")
            
            let parameter = "userId=\(uId!)"//901838803278630
            
            MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            apiClassStory.sharedInstance().postRequestForGetStory(parameter, viewController: self)
            //postRequestForGetStory
        }
        else{
            print("not refresh")
            
        }
        
        
        
        
        
//        ////Attributed string---///

        
        self.storyCountLabel.attributedText = attributedTextClass().setAttributeRobotBold("0", text1Size: 12, text2: " Selected", text2Size: 12) //attributedString1
        
        
        bucketCount.layer.cornerRadius=bucketCount.frame.size.width/2
        bucketCount.clipsToBounds=true
        bucketCount.text = bucketListTotalCount
        
        bookingBtnOutlet.layer.cornerRadius=bookingBtnOutlet.frame.size.height/2
        bookingBtnOutlet.layer.borderColor = UIColor (colorLiteralRed: 162/255, green: 200/255, blue: 138/255, alpha: 1).CGColor
        bookingBtnOutlet.layer.borderWidth = 1.5
        bookingBtnOutlet.clipsToBounds=true
        

        
        self.showBooking()
        
        
       // self.attributeInStoryCount(0)
        
        
    }
    
    
    
    func refresh(sender:AnyObject)
    {
        // Code to refresh table view
        
        refreshControl.endRefreshing()
        let defaults = NSUserDefaults.standardUserDefaults()
        let uId = defaults .stringForKey("userLoginId")
        
        let parameter = "userId=\(uId!)"//901838803278630
        apiClassStory.sharedInstance().postRequestForGetStory(parameter, viewController: self)
        
        }
    
    
    
    
    
    
    
    
    
    /////////////////////////////////////////////////////////////////
    
    //MARK:- Manage the Segment Control
    //MARK:-
    
    func manageSegment() -> Void
    {
       selectAllBtnOutlet.setTitle("Select All", forState: UIControlState .Normal)
        print(segmentIndex)
        
        heightOfSegmentControl.constant=35
        
        if segmentArray.count<1 {
            segmentControl = HMSegmentedControl()
            
        }
        else
        {
        
        let title2 = segmentArray as Array
        segmentControl.sectionTitles = title2 as! [String]
        let viewWidth = CGRectGetWidth(self.view.frame);
        
        
        segmentControl.sectionTitles = title2 as! [String]
        segmentControl.autoresizingMask = [.FlexibleRightMargin, .FlexibleWidth]
        segmentControl.frame = CGRectMake(0, 64, viewWidth, 34)
        
        segmentControl.segmentEdgeInset = UIEdgeInsetsMake(0, 5, 0, 5)
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
        
        self.view .bringSubviewToFront(segmentControl)
       segmentControl.addTarget(self, action: #selector(storyViewcontrollerViewController.changeSegment(_:)), forControlEvents: .ValueChanged)
     
       
       // self.view .layoutIfNeeded()
            
            
            if segmentIndex<=segmentArray.count {
                if segmentArray.count==1 {
                    segmentIndex=0
                }
                
                 segmentControl.setSelectedSegmentIndex(UInt(segmentIndex), animated: true)
                
            }
            else
            {
                segmentControl.setSelectedSegmentIndex(0, animated: true)
                
                segmentIndex=0
            }
            
           
        
        if storyArray.count>0 {
             heightOfScrollContent.constant=storyTableView.rowHeight * CGFloat(storyArray.objectAtIndex(segmentIndex).count) + 235
             self.storyTableView .reloadData()
        }
        
        
            
//            let locationNameString = "\(segmentArray.objectAtIndex(segmentIndex))" as? String ?? ""
            
            

            
            storyNameLabel.attributedText=attributedTextClass().setAttributeRobotBold("Delete", text1Size: 12, text2: " Story", text2Size: 12)
            
        }
        

        
    }
    

    
    
    
    ////////////////////////////////
    
//MARK:- Change segment Action
//MARK:-
    
    func changeSegment(segmentedControl: HMSegmentedControl) -> Void {
        
        
     
        
        headerLabel.text = segmentArray.objectAtIndex(segmentedControl.selectedSegmentIndex) as? String
        
        
        selectedArray .removeAllObjects()
        self.attributeInStoryCount(selectedArray.count)
        
        let headerText = segmentArray .objectAtIndex(segmentedControl.selectedSegmentIndex)
        
        
        let index = segmentArray .indexOfObject(headerText)
        if (index != NSNotFound) {
            
            segmentIndex = index
            heightOfScrollContent.constant=storyTableView.rowHeight * CGFloat(storyArray.objectAtIndex(segmentIndex).count) + 235
            self.view .layoutIfNeeded()
            
        
            if storyArray.count>0 {
                mapView .clear()
                
                self.storyTableView.reloadData()
                
            }
        }
        
        
        
      //  let locationNameString = "\(segmentArray.objectAtIndex(segmentIndex))" as? String ?? ""
    
        
        
       // self.storyNameLabel.attributedText = attributedTextClass().setAttributeRobotLight(locationNameString, text1Size: 12, text2: " Story", text2Size: 12)
        storyNameLabel.attributedText=attributedTextClass().setAttributeRobotBold("Delete", text1Size: 12, text2: " Story", text2Size: 12)

        
        
        
    }
    
    
    
    
    
    //MARK:- Buttons actions
    //MARK:-
    
    
    
    //MARK:- Back Button Action
    
    @IBAction func backBtnAction(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
        self.dismissViewControllerAnimated(true, completion: {})
        NSURLCache.sharedURLCache().removeAllCachedResponses()
        
        
    }
    
    
    
    //MARK:- All Stories Delete Button
    //MARK:- 
    
    
    @IBAction func AllStoryDelete(sender: AnyObject) {
    
    //imageCount .imageIds,userId,country
    
        
       
        let dataArray = storyArray.objectAtIndex(segmentIndex)
        
       
            
            selectedArray .removeAllObjects()
           
        
            
            for i in 0..<dataArray.count {
                
                self .selectImage(i)
                
            }
        
        
        
        
        
        
        // Create the alert controller
        let alertController = UIAlertController(title: "Pyt", message: "Are you sure to delete whole story ?", preferredStyle: .Alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
            UIAlertAction in
           
            MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            
            
            let imageId = self.storyArray.objectAtIndex(self.segmentIndex).valueForKey("imageId")
            
            print(imageId)
            
            let idArr=imageId as! NSArray
            
            print(idArr)
            
            print(idArr.count)
            
            
            
            
            
            
            
            let country = self.segmentArray.objectAtIndex(self.segmentIndex) as? String ?? ""
            
            //        //10153101414156609
            let defaults = NSUserDefaults.standardUserDefaults()
            let uId = defaults .stringForKey("userLoginId")
            
            
            
            let dataStr = "userId=\(uId!)&country=\(country)&imageCount=\(self.selectedArray.count)&imageIds=\(idArr.componentsJoinedByString(","))"
            //
            print("sdt=\(dataStr)+AAA")
            
            apiClassStory.sharedInstance().postRequestDeleteAllStory(dataStr, arrayId: idArr, viewController: self)
            
            
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
                    
                    let parameter = "userId=\(uId!)"//901838803278630
                    apiClassStory.sharedInstance().postRequestForGetStory(parameter, viewController: self)
                }
            })
            
            self.selectedArray .removeAllObjects()
            
            self.attributeInStoryCount(self.selectedArray.count)
            

            
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
            
            
            self.selectedArray .removeAllObjects()
            self.storyTableView .reloadData()
            
        }
        
        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        self.presentViewController(alertController, animated: true, completion: nil)
        
        
                    
        
        
        
        
    }
    
    
    
    
    
    
    /////////////////////////////////////////////////////////////////
    
    //MARK:- Get the scrolling of tableView
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
       print(scrollView.contentOffset.y)
        
    }
    
    
    
    
    func serverResponseArrivedStory(response: AnyObject) -> Void {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(false, forKey: "refreshStory")
        
        jsonResult = NSDictionary()
        
         jsonResult = response as! NSDictionary
        
        
      //  print(jsonResult)
        
        let sucess = jsonResult.valueForKey("status") as! NSNumber
        
        if sucess == 1 {
            
            
            storyArray.removeAllObjects()
            segmentArray.removeAllObjects()
            
//            storyArray=NSMutableArray()
//            segmentArray=NSMutableArray()
            
            let dataDict = jsonResult.valueForKey("data") as! NSDictionary
            
            let dataArray = dataDict.valueForKey("story") as! NSMutableArray
            
            
            
            
            for i in 0..<dataArray.count {
                
//                print(dataArray[i].valueForKey("place"))
                
                var cityArr = NSMutableArray()
                
                cityArr = dataArray[i].valueForKey("city") as! NSMutableArray
                
                 var photosArray = NSMutableArray()
               // print(cityArr)
                for j in 0..<cityArr.count {
                    
                    let dat = cityArr[j].valueForKey("data") as! NSMutableArray
                    
                    for k in 0..<dat.count {
                       
                        photosArray .addObject(dat[k])
                        
                        
                    }
                    
                    
                }
                
                

                
                if (dataArray[i].valueForKey("country") != nil) {
                    
                    
                    let capSt = dataArray[i].valueForKey("country")! as? String ?? ""

                    
                    segmentArray .addObject(capSt.capitalizedString)//dataArray[i].valueForKey("country")!)
                    
                    let images = NSMutableArray()
                    for j in 0..<photosArray.count {
                        
                       // print(photosArray.objectAtIndex(j))
                        images .addObject(photosArray[j])// multiple segments
                        //storyArray .addObject(photosArray[j])
                    }
                    storyArray .addObject(images)//multiple segments

                    
                    
                }
                
                
                
                
                
              
                
            }
            
            
           
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
                
                //if self.segmentArray.count>0{
                self.manageSegment()
                 MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                //}
                
            }
               
                
                
            if storyArray.count<0 {
                
            
            if storyArray.objectAtIndex(0).count<1 {
                
                heightOfScrollContent.constant = 0
//                CommonFunctionsClass.sharedInstance().alertViewOpen("No Story Yet, To add story just Long press on the images", viewController: self)
//                 MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
//                // storyTableView.rowHeight * CGFloat(storyArray.objectAtIndex(segmentIndex).count) + 235
//                self.view .layoutIfNeeded()
                
                
                self.heightOfScrollContent.constant = 0
                self.heightOfSegmentControl.constant = 0
                self.view .layoutIfNeeded()
                
                let Alert = UIAlertController(title: "PYT", message: "No Story Yet, To add story just Long press on the images", preferredStyle: UIAlertControllerStyle.Alert)
                Alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                    
                   
                    
                    self.backBtnAction(self)
                    
                }))
                
                
                self.presentViewController(Alert, animated: true, completion: nil)
                
                
                
                
                
            }
            else{
                
            }
//                CommonFunctionsClass.sharedInstance().alertViewOpen("No Story Yet, To add story just Long press on the images", viewController: self)
//                 MBProgressHUD.hideAllHUDsForView(self.view, animated: true)

                self.heightOfScrollContent.constant = 0
                self.heightOfSegmentControl.constant = 0
                self.view .layoutIfNeeded()
                let Alert = UIAlertController(title: "PYT", message: "No Story Yet, To add story just Long press on the images", preferredStyle: UIAlertControllerStyle.Alert)
                Alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                    
                    
                    self.backBtnAction(self)
                    
                }))
            self.presentViewController(Alert, animated: true, completion: nil)
            
            }
            
            
            
            
        }
        else
        {
            
            
//            CommonFunctionsClass.sharedInstance().alertViewOpen("No Story Yet, To add story just Long press on the images", viewController: self)
//            heightOfScrollContent.constant = 0
//            heightOfSegmentControl.constant = 0
//            self.view .layoutIfNeeded()
//             MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
//            

             MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            self.heightOfScrollContent.constant = 0
            self.heightOfSegmentControl.constant = 0
            self.view .layoutIfNeeded()
            let Alert = UIAlertController(title: "PYT", message: "No Story Yet, To add story just Long press on the images", preferredStyle: UIAlertControllerStyle.Alert)
            Alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                
                
                self.backBtnAction(self)
                
            }))
            self.presentViewController(Alert, animated: true, completion: nil)
            
            
        }
       
        
    
       
       
        
        
        
    }
    
    
    
    
    
    
    
    
    
    /////////////////////////////////////////////////////////////////
    //MARK:-delegate and datasource of tableView
    //MARK:-
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        // #warning Incomplete implementation, return the number of sections
        
        
            return 1
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if storyArray.count>0 {
            return storyArray.objectAtIndex(segmentIndex).count
        }
        else{
            return 0
        }
        
        
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
       
            let cell:StoryTableViewCell = tableView.dequeueReusableCellWithIdentifier("storycell") as! StoryTableViewCell
           
        
        let dataArray = storyArray.objectAtIndex(segmentIndex)
        
        
       // print(dataArray .objectAtIndex(indexPath.row))
        
        
        let imgId = dataArray.objectAtIndex(indexPath.row).valueForKey("imageId") //as? String ?? ""
        
        
       // cell.rightHalfView.hidden=true
       // cell.checkMarkBtn.hidden=true
        
        cell.rightHalfView.alpha = 0.6
        cell.deleteBtn.alpha = 0.6
        cell.checkMarkBtn.alpha = 0.6
        cell.leftHalfView.alpha = 0.6
        //print(selectedArray)
        
        if selectedArray.count>0 {
            if selectedArray.valueForKey("imageId") .containsObject(imgId!) {
                
                cell.rightHalfView.alpha = 1
                cell.checkMarkBtn.alpha = 1
            }
        }
        
        
        
        
        
        
        
        
        
                cell.layer.cornerRadius=0
                cell.clipsToBounds=true
        
        
        cell.mainView.layer.cornerRadius=5
        cell.mainView.clipsToBounds=true
        
        
        cell.detailBtn.layer.cornerRadius=12
        cell.detailBtn.clipsToBounds=true
        cell.detailBtn.tag=indexPath.row
        cell.detailBtn.setTitle("Bucket", forState: UIControlState .Normal)
        cell.detailBtn .addTarget(self, action: #selector(storyViewcontrollerViewController.detailOfImage(_:)), forControlEvents: UIControlEvents .TouchUpInside)
        

        
        
        
        //cell.deleteBtn.layer.cornerRadius=cell.deleteBtn.frame.size.width/2
        //cell.deleteBtn.clipsToBounds=true
        cell.deleteBtn.layer.shadowColor=UIColor .blackColor().CGColor
        
        
        cell.checkMarkBtn.layer.cornerRadius=cell.checkMarkBtn.frame.size.width/2
        cell.checkMarkBtn.tag=indexPath.row

        
          let pImage : UIImage = UIImage(named:"backgroundImage")! //placeholder image
        
        let category=dataArray.objectAtIndex(indexPath.row).valueForKey("category") as? String ?? ""
        let location = dataArray.objectAtIndex(indexPath.row).valueForKey("location") as? String ?? " "
        
         cell.museumName.text="Museum Name"//category
        
        var geoTagName=dataArray.objectAtIndex(indexPath.row).valueForKey("geoTag") as? String ?? " "
       
        var attributedString2 = NSMutableAttributedString()
        
        ////Attributed string---///
        
        //  mutableAttributedString.addAttribute((kCTForegroundColorAttributeName as! String), value: (UIColor.blueColor().CGColor as! AnyObject), range: boldRange)
        
        
       
        
        let segAttributeslabel: NSDictionary = [
            NSForegroundColorAttributeName: UIColor.init(colorLiteralRed: 35.0/255, green: 52.0/255, blue: 71.0/255, alpha: 1.0).CGColor,
            NSFontAttributeName: UIFont(name:"Roboto-Bold", size: 8.0)!
        ]
        
        let segAttributeslabel2: NSDictionary = [
            NSForegroundColorAttributeName: UIColor.init(colorLiteralRed: 35.0/255, green: 52.0/255, blue: 71.0/255, alpha: 1.0).CGColor,
            NSFontAttributeName: UIFont(name:"Roboto-Light", size: 9.0)!
        ]
        
        
        
        
        
        if geoTagName=="" {
            
              attributedString2 = NSMutableAttributedString(string:" \(location)", attributes:segAttributeslabel2 as? [String : AnyObject])
            
            geoTagName=location
        }
        else{
              attributedString2 = NSMutableAttributedString(string:"\(geoTagName),\(location)", attributes:segAttributeslabel2 as? [String : AnyObject])
        }
        
        
         cell.museumName.text=geoTagName
        
        
        
        
       
        
        let attributedString1 = NSMutableAttributedString(string:"Location:  ", attributes:segAttributeslabel as? [String : AnyObject])
        
       
        
        attributedString1.appendAttributedString(attributedString2)
       // attributedString1.appendAttributedString(attributedString3)

        cell.locLabel.attributedText = attributedString1

        
        
        
       
        
        
        
        
        
        let storyImage = dataArray .objectAtIndex(indexPath.row) .valueForKey("imageThumb") as? NSString ?? "" //Thumbnail
       // let storyImage = dataArray .objectAtIndex(indexPath.row) .valueForKey("imageUrl") as? NSString ?? ""
        let url = NSURL(string: storyImage as String)
        
        
                        let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in
                            //print(self)
        
                        }
        
                    cell.locationImage.sd_setImageWithURL(url, placeholderImage: pImage, completed: block)

        //cell.locationImage.image=UIImage (named: "img5")
        cell.locationImage.contentMode = .ScaleAspectFill
            cell.locationImage.clipsToBounds=true
        cell.deleteBtn.addTarget(self
            , action: #selector(storyViewcontrollerViewController.deleteStoryBtn(_:)), forControlEvents: UIControlEvents .TouchUpInside)
        
        cell.checkMarkBtn.addTarget(self, action: #selector(storyViewcontrollerViewController.checkMArk(_:)), forControlEvents: UIControlEvents .TouchUpInside)
        
        
        
        let geoTag = dataArray.objectAtIndex(indexPath.row).valueForKey("geoTag") as? String ?? ""
        
        
        
        cell.deleteBtn.tag = indexPath.row
        
        

        
//        
//        let lat = dataArray.objectAtIndex(indexPath.row).valueForKey("latitude") as? String ?? ""
//        let long = dataArray.objectAtIndex(indexPath.row).valueForKey("longitude") as? String ?? ""
//        
//        if indexPath.row==0 {
//            let camera = GMSCameraPosition.cameraWithLatitude(CDouble(lat)!, longitude: CDouble(long)!, zoom: 9)
//            mapView.camera = camera
//        }
//       
//            mapView.myLocationEnabled = false
//       
//            var position = CLLocationCoordinate2DMake(Double(lat)!,Double(long)!)
//            let marker = GMSMarker(position: position)
//            marker.title=geoTag
//            marker.map=mapView
//           marker.icon=UIImage (named: "blueMarker")
        
        
        //////----LOng Tap
        
       // cell.tag=1000*self.segmentControl.selectedSegmentIndex+indexPath.row
        
    // cell.tag=indexPath.row
        
       // let longTapGest = UILongPressGestureRecognizer(target: self, action: #selector(intrestViewController.longTap(_:)))
        
       // cell.addGestureRecognizer(longTapGest)
        
        if indexPath.row==dataArray.count-1 {
            self.setPinsInMap()
        }
        
        
        
        return cell
        
        
        
        
    }
    
    
    /////MARK: Set Pins in map according to distance  ie show all the pins inside map
    //MARK:
    
    
    func setPinsInMap() -> Void {
        
         mapView.myLocationEnabled = false
        let dataArray = storyArray.objectAtIndex(segmentIndex)
        
       // print(dataArray.valueForKey("latitude"))
        let path = GMSMutablePath()
        
        for i in 0..<dataArray.count {
            
            let latTemp = Double (dataArray.objectAtIndex(i).valueForKey("latitude") as? String ?? "")
            let longTemp = Double(dataArray.objectAtIndex(i).valueForKey("longitude") as? String ?? "")
            let geoTag = dataArray.objectAtIndex(i).valueForKey("geoTag") as? String ?? ""
            
            
            if latTemp==0 {
                
            }
            else
            {
                // let latTemp =  dict["latitude"] as! Double
                //let longTemp =  dict["longitude"] as! Double
                
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: latTemp!, longitude: longTemp!)
                marker.title = geoTag
                marker.appearAnimation = kGMSMarkerAnimationNone
                marker.map=mapView
                marker.icon=UIImage (named: "blueMarker")
                //path.addCoordinate(CLLocationCoordinate2DMake(latTemp!, longTemp!))
            
            
                ////additional
                let position = CLLocationCoordinate2DMake(latTemp!, longTemp!)
                path .addCoordinate(position)
            
            }
            
    
        
        }

        
        let mapBounds = GMSCoordinateBounds(path: path)
       let cameraUpdate = GMSCameraUpdate.fitBounds(mapBounds, withPadding: 20)
        // let cameraUpdate = GMSCameraUpdate.fitBounds(mapBounds) //GMSCameraUpdate.fit(mapBounds)
        self.mapView.moveCamera(cameraUpdate)
        
//        let bounds = GMSCoordinateBounds(path: path)
//       self.mapView!.animateWithCameraUpdate(GMSCameraUpdate.fitBounds(bounds, withPadding: 50.0))
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    }
    
    
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    
        
        let dataArray = storyArray.objectAtIndex(segmentIndex)
        
        print(dataArray .objectAtIndex(indexPath.row))
        
        let arrayData=NSMutableArray()
        
        
        
        let profileStr = dataArray.objectAtIndex(indexPath.row).valueForKey("profilePic") as? String ?? ""
        let location =  dataArray.objectAtIndex(indexPath.row).valueForKey("location") as? String ?? ""
        let imageUrl = dataArray.objectAtIndex(indexPath.row).valueForKey("imageUrl") as? String ?? ""
        let imageThumb = dataArray.objectAtIndex(indexPath.row).valueForKey("imageThumb") as? String ?? ""
        let geoTag = dataArray.objectAtIndex(indexPath.row).valueForKey("geoTag") as? String ?? ""
        
        let category = dataArray.objectAtIndex(indexPath.row).valueForKey("category") as? String ?? ""
        let userName = dataArray.objectAtIndex(indexPath.row).valueForKey("userName") as? String ?? ""
        let descrip = dataArray.objectAtIndex(indexPath.row).valueForKey("description") as? String ?? ""
        var cityName = dataArray.objectAtIndex(indexPath.row).valueForKey("cityName") as? String ?? ""
        let latitude = dataArray.objectAtIndex(indexPath.row).valueForKey("latitude") as? String ?? ""
        let longitude = dataArray.objectAtIndex(indexPath.row).valueForKey("longitude") as? String ?? ""
        
        
        
        if cityName=="" {
            cityName=location
            }
        
        
        
        var lat = NSNumber()
        var long  = NSNumber()
        
        lat = NSNumber(float:(latitude as NSString).floatValue)
        long =  NSNumber(float:(longitude as NSString).floatValue)
        
        
        let multiImgArr = NSMutableArray()
        multiImgArr .addObject(imageUrl)
        
        //"standardImage":arrImgStand, "multipleImagesStandard": multiImgStandArr
        
        arrayData .addObject(["Description":descrip, "profileImage": profileStr, "location": location, "locationImage": imageUrl, "Venue": cityName, "cityName":cityName , "CountryName": location, "geoTag": geoTag,"imageId":"","latitude":lat, "longitude":long, "userName":userName, "Type": "Other", "multipleImagesLarge": multiImgArr, "Category": category, "likeBool":false, "standardImage":imageThumb, "multipleImagesStandard": multiImgArr])
        
        
        let nxtObj2 = self.storyboard?.instantiateViewControllerWithIdentifier("detailViewController") as! detailViewController
        nxtObj2.arrayWithData=arrayData
        nxtObj2.fromStory = true

        dispatch_async(dispatch_get_main_queue(), {
            
            self.navigationController! .pushViewController(nxtObj2, animated: true)
            
            self.dismissViewControllerAnimated(true, completion: {})
            
            self.tabBarController?.tabBar.hidden = true
            
            
        })
        
        

        
        
        
    }
    
    
    
    
    
    ///////////------ End of table View Delegates and Data source ---------///////////////
    
    
    
    ////////////------ MArker info window custom
    
    func mapView(mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let infoWindow = UIView()
        infoWindow.frame=CGRectMake(0, 0, 150, 30)
        infoWindow.backgroundColor=UIColor .whiteColor()
        infoWindow.layer.cornerRadius=5
        infoWindow.clipsToBounds=true
        
        let labelBack = UILabel()
         labelBack.backgroundColor=UIColor (colorLiteralRed: 32.0/255.0, green: 47.0/255.0, blue: 65.0/255.0, alpha: 1.0)
        labelBack.frame=CGRectMake(0, 0, 30, 30)
        infoWindow .addSubview(labelBack)
        
        let imageIcon = UIImageView()
        imageIcon.backgroundColor=UIColor .clearColor() //UIColor (colorLiteralRed: 32.0/255.0, green: 47.0/255.0, blue: 65.0/255.0, alpha: 0.8)
        imageIcon.frame=CGRectMake(4, 4, 22, 22)
        imageIcon.image=UIImage (named: "whiteMarkerIcon")
        infoWindow .addSubview(imageIcon)
        
        
        
        let titleLabel = UILabel()
        titleLabel.text=marker.title
        titleLabel.font=UIFont(name: "Roboto-Regular", size: 12)!
        titleLabel.frame=CGRectMake(imageIcon.frame.origin.x + 31, 0, 80, 30)
        titleLabel.textColor=UIColor.blackColor()
        infoWindow .addSubview(titleLabel)
    
            
            
        //infoWindow.label.text = "\(marker.position.latitude) \(marker.position.longitude)"
        return infoWindow
    }
    
    
    
    
    
    //LOng Tap
    
    func longTap(sender: UILongPressGestureRecognizer)-> Void {
        
        
        if sender.state == .Began
        {
            
           print(sender.view?.tag)
            tableIndex=(sender.view?.tag)!
            self.detailSelectBtnAction(true)
            
        }
    }
    
    
    
    
    
    func detailSelectBtnAction(showView:Bool) -> Void
    {
        
        
        //// hide the view
        if showView==false {
            
            
            let popUpView2 = detailView
            let centre : CGPoint = CGPoint(x: self.view.center.x, y: self.view.center.y)
            
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
                    self.detailView.hidden = true
                    popUpView2.transform = CGAffineTransformIdentity
            })
            
            
            
            
            
        }
            
            ////Show the View
        else
        {
            
            
            
            
            self.detailView.hidden=false
            
            
            let popUpView2 = detailView
            let centre : CGPoint = CGPoint(x: self.view.center.x, y: self.view.center.y)
            
            popUpView2.center = centre
            popUpView2.layer.cornerRadius = 0.0
            let trans = CGAffineTransformScale(popUpView2.transform, 0.01, 0.01)
            popUpView2.transform = trans
            self.view .addSubview(popUpView2)
            UIView .animateWithDuration(0.3, delay: 0.0, options:     UIViewAnimationOptions.CurveEaseInOut, animations: {
                
                popUpView2.transform = CGAffineTransformScale(popUpView2.transform, 100.0, 100.0)//CGAffineTransformIdentity
                
                }, completion: {
                    (value: Bool) in
                    
                    //                    self.likeImage.hidden=false
                    //                    //sencod image
                    //                    let popUpView2 = self.likeImage
                    //                    let centre2 : CGPoint = CGPoint(x: self.detailView.center.x, y: self.detailView.center.y)
                    //
                    //                    popUpView2.center = centre2
                    //                    popUpView2.layer.cornerRadius = 0.0
                    //                    let trans2 = CGAffineTransformScale(popUpView2.transform, 0.01, 0.01)
                    //                    popUpView2.transform = trans2
                    //                    self.view .addSubview(popUpView2)
                    //                    UIView .animateWithDuration(0.3, delay: 0.0, options:     UIViewAnimationOptions.CurveEaseInOut, animations: {
                    //
                    //                        popUpView2.transform = CGAffineTransformScale(popUpView2.transform, 1.0, 1.0)
                    //
                    //                        }, completion: {
                    //                            (value: Bool) in
                    //
                    //                            self.addToBucket.hidden=false
                    //                            //third image
                    //                            let popUpView3 = self.addToBucket
                    //                            let centre3 : CGPoint = CGPoint(x: self.detailView.center.x, y: self.detailView.center.y)
                    //
                    //                            popUpView3.center = centre3
                    //                            popUpView3.layer.cornerRadius = 0.0
                    //                            let trans3 = CGAffineTransformScale(popUpView2.transform, 0.01, 0.01)
                    //                            popUpView3.transform = trans3
                    //                            self.detailSubView .addSubview(popUpView3)
                    //                            UIView .animateWithDuration(0.3, delay: 0.0, options:     UIViewAnimationOptions.CurveEaseInOut, animations: {
                    //
                    //                                popUpView3.transform = CGAffineTransformScale(popUpView3.transform, 100.0, 100.0)
                    //
                    //                                }, completion: {
                    //                                    (value: Bool) in
                    //
                    //                            })
                    //                            ///------ third End---////
                    //
                    //
                    //                    })
                    //
                    //                     ///------Second End----/////
                    //
                    //
                    
            })
            ///------first End----/////
            
            
            
            
            
            
            
            
            let tapGestureRecognizer = UITapGestureRecognizer()
            tapGestureRecognizer.addTarget(self, action: #selector(storyViewcontrollerViewController.tempFunc))
            
            detailView.addGestureRecognizer(tapGestureRecognizer)
            
            
            
            let tapGestureRecognizer2 = UITapGestureRecognizer(target:self, action:#selector(storyViewcontrollerViewController.selectImageTapped))
            proceedImage.userInteractionEnabled = true
            proceedImage.addGestureRecognizer(tapGestureRecognizer2)
            
            self.detailView.bringSubviewToFront(proceedImage)
            
            
            
            
            
            let tapGestureRecognizer4 = UITapGestureRecognizer(target:self, action:#selector(storyViewcontrollerViewController.bucketImageTapped))
            addToBucket.userInteractionEnabled = true
            addToBucket.addGestureRecognizer(tapGestureRecognizer4)
            
            self.detailView.bringSubviewToFront(addToBucket)
            
            
            
          
        }
        
        
        
        
    }
    
    
    
    
    //MARK:- show the booking button
    func showBooking() -> Void {
        
        bookingBtnOutlet.hidden=true
        
        if selectedArray.count>0 {
            
            bookingBtnOutlet.hidden=false
            
        }
        
        
        
    }
    
    
    @IBAction func bookingAction(sender: AnyObject) {
    
    
        
        
        let nxtObj2 = self.storyboard?.instantiateViewControllerWithIdentifier("BookingViewController") as! BookingViewController
        nxtObj2.arrayOfStories = selectedArray
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let uId = defaults .stringForKey("userLoginId")
      
        
        var sendDataToServer = NSDictionary()
        sendDataToServer=["userId":uId!, "booking":selectedArray]
        apiClassStory.sharedInstance().postRequestAddBooking("", parameters: sendDataToServer, viewController: self)
        
        
        dispatch_async(dispatch_get_main_queue(), {
            
            self.navigationController! .pushViewController(nxtObj2, animated: true)
            
            self.dismissViewControllerAnimated(true, completion: {})
            
            self.tabBarController?.tabBar.hidden = true
            
            
        })
        
    
    }
    
    
    
    //MARK:- Bucket Button Action
    
    @IBAction func bucketButtonAction(sender: AnyObject) {
        
        let nxtObj = self.storyboard?.instantiateViewControllerWithIdentifier("BucketListViewController") as! BucketListViewController
        
        
        self.navigationController! .pushViewController(nxtObj, animated: true)
    }
    
    
    
    
    
    
    //MARK:- Tap gesture functions to manage the popup view
    
    ///Temp function to
    func tempFunc() -> Void {
        
        self .detailSelectBtnAction(false)
        
    }
    
    ///story image tapped
    func selectImageTapped()
    {
        self .selectImage(tableIndex)
        
        self.storyTableView.reloadData()
        self.showBooking()

        
        
        
        self.tempFunc()
        
    }
    
    
    
    ///bucket image tapped
    func bucketImageTapped()
    {
        // Your action
        
        print("bucket image tapped")
        self.tempFunc()
    }
    
    
    
    
    
    func checkMArk(sender:UIButton) -> Void {
        
        
        self.selectImage(sender.tag)
        
        storyTableView .reloadData()
        
        
        
    }
    
    
    
    
    
    
    
    func selectImage(indexOfImg: Int) -> Void {
        
        let dataArray = storyArray.objectAtIndex(segmentIndex)
        
        
        print(indexOfImg)
        let imgId = dataArray.objectAtIndex(indexOfImg).valueForKey("imageId")
        
        if selectedArray.valueForKey("imageId") .containsObject(imgId!) {
            
            let indexId = selectedArray.valueForKey("imageId") .indexOfObject(imgId!)
            selectedIdArray.removeObjectAtIndex(indexId)
            selectedArray.removeObjectAtIndex(indexId)
        }
        else
        {
            
            selectedArray .addObject(dataArray.objectAtIndex(indexOfImg))
            selectedIdArray .addObject(imgId!)
        }
        
//        if selectedArray.count>=1 {
//            
//            bookingBtnOutlet.hidden=false
//        }
//        else
//        {
//            bookingBtnOutlet.hidden=true
//        }

        self.attributeInStoryCount(selectedArray.count)
        
        
        
        print(selectedIdArray)
        
        
        
    }
    
    
    
    
    
    
    
    
    func detailOfImage(sender:UIButton) -> Void {
        
        print(sender.tag)
        
//        let dataArray = storyArray.objectAtIndex(segmentIndex)
//        
//        print(dataArray .objectAtIndex(sender.tag))
//        
//        let arrayData=NSMutableArray()
//        
//        
//        
//        let profileStr = dataArray.objectAtIndex(sender.tag).valueForKey("profilePic") as? String ?? ""
//        let location =  dataArray.objectAtIndex(sender.tag).valueForKey("location") as? String ?? ""
//        let imageUrl = dataArray.objectAtIndex(sender.tag).valueForKey("imageUrl") as? String ?? ""
//        let geoTag = dataArray.objectAtIndex(sender.tag).valueForKey("geoTag") as? String ?? ""
//        
//        let category = dataArray.objectAtIndex(sender.tag).valueForKey("category") as? String ?? ""
//        let userName = dataArray.objectAtIndex(sender.tag).valueForKey("userName") as? String ?? ""
//        
//        
//        
//        let multiImgArr = NSMutableArray()
//        multiImgArr .addObject(imageUrl)
//        
//        
//         arrayData .addObject(["Description":"", "profileImage": profileStr, "location": location, "locationImage": imageUrl, "Venue": location, "CountryName": location, "geoTag": geoTag,"imageId":"","latitude":0, "longitude":0, "userName":userName, "Type": "Other", "multipleImages": multiImgArr, "Category": category])
//        
//         
//         let nxtObj2 = self.storyboard?.instantiateViewControllerWithIdentifier("detailViewController") as! detailViewController
//         nxtObj2.arrayWithData=arrayData
//         
//         dispatch_async(dispatch_get_main_queue(), {
//         
//         self.navigationController! .pushViewController(nxtObj2, animated: true)
//         
//            self.dismissViewControllerAnimated(true, completion: {})
//            
//            self.tabBarController?.tabBar.hidden = true
//            
//            
//         })
//
//        
        
        
        
        
    }
    
    
    
    
    func deleteStoryBtn(sender:UIButton) -> Void {
        
        print(sender.tag)
        
        
        
       MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        
        let imageId = self.storyArray.objectAtIndex(segmentIndex).objectAtIndex(sender.tag).valueForKey("imageId")
        
        let cityName = self.storyArray.objectAtIndex(segmentIndex).objectAtIndex(sender.tag).valueForKey("cityName") as? String ?? ""
//        
        let place = self.segmentArray.objectAtIndex(segmentIndex) as? String ?? ""
        
//        //10153101414156609
        let defaults = NSUserDefaults.standardUserDefaults()
        let uId = defaults .stringForKey("userLoginId")
        
        let dataStr = "userId=\(uId!)&imageId=\(imageId!)&place=\(place)&cityName=\(cityName)"
//        
       // print(dataStr)
//        
        apiClassStory.sharedInstance().postRequestDeleteStory(dataStr, viewController: self)

       
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
            
            let parameter = "userId=\(uId!)"//901838803278630
            apiClassStory.sharedInstance().postRequestForGetStory(parameter, viewController: self)
        }
            })
       selectedArray .removeAllObjects()
        
        self.attributeInStoryCount(selectedArray.count)
        
    }
    
    
    
    
    
    
    //MARK:- Select All Button
    
    
    @IBAction func selectAllAction(sender: AnyObject) {
    
        
    let dataArray = storyArray.objectAtIndex(segmentIndex)
        
        if selectedArray.count==dataArray.count {
            
            selectedArray .removeAllObjects()
            storyTableView .reloadData()
        }
        else
        {
            selectedArray .removeAllObjects()
            
            for i in 0..<dataArray.count {
                
                self .selectImage(i)
                
            }
            storyTableView .reloadData()
            
            
        }
        
        self.attributeInStoryCount(selectedArray.count)
        
      
        
    
    }
    
    
    func attributeInStoryCount(count:Int) -> Void {
        
        
        self.selectedCountLabel.attributedText = attributedTextClass().setAttributeRobotLight(String(count), text1Size: 12, text2: " Selected", text2Size: 12)
        
        
        
        
        
         selectAllBtnOutlet.setTitle("Select All", forState: UIControlState .Normal)
         let locationNameString = "\(segmentArray.objectAtIndex(segmentIndex))" as? String ?? ""
       // storyNameLabel.attributedText=attributedTextClass().setAttributeRobotBold("\(locationNameString)", text1Size: 12, text2: " Story", text2Size: 12)
        
        storyNameLabel.attributedText=attributedTextClass().setAttributeRobotBold("Delete", text1Size: 12, text2: " Story", text2Size: 12)
        
        
        if selectedArray.count==storyArray.objectAtIndex(segmentIndex).count {
             selectAllBtnOutlet.setTitle("Unselect All", forState: UIControlState .Normal)
        
//            storyNameLabel.attributedText=attributedTextClass().setAttributeRobotBold("Clear \(locationNameString)", text1Size: 12, text2: " Story", text2Size: 12)

            storyNameLabel.attributedText=attributedTextClass().setAttributeRobotBold("Delete", text1Size: 12, text2: " Story", text2Size: 12)
            
            
        }
        
        
       
        
        
          self.showBooking()
        
    }
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
