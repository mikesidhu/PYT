//
//  nearByViewController.swift
//  PYT
//
//  Created by Niteesh on 02/11/16.
//  Copyright © 2016 appsMaven. All rights reserved.
//

import UIKit
import SDWebImage
import ImageSlideshow

class nearByViewController: UIViewController, apiClassDelegate {
    
    
    var photosArray = NSMutableArray()
    var reviewsArray = NSMutableArray()
    var webLinkString = NSString()
    var descriptionString = NSString()
    var hotelImagesArray = NSMutableArray()
    var newDetail = NSDictionary()
    var indexOfZoomImg = Int()
    var Thumbnails = Bool()
    var DirectionSwipe = NSString()
    var country = NSString()
    
    
    @IBOutlet var firstView: UIView!
    
    @IBOutlet var heightofFirstView: NSLayoutConstraint!
    
    @IBOutlet var heightOfThirdView: NSLayoutConstraint!
    @IBOutlet var heightOfSecondView: NSLayoutConstraint!
    
    @IBOutlet var heightOfTableView: NSLayoutConstraint!
    
    @IBOutlet var contentViewHeight: NSLayoutConstraint!
    
    @IBOutlet var headerView: UIView!
    @IBOutlet var headerImage: UIImageView!
    
    @IBOutlet var headerLabel: UILabel!
    
    @IBOutlet var backBtn: UIButton!
    
    
    
    @IBOutlet var scrollViewMain: UIScrollView!
    
    @IBOutlet var titleLabel: UILabel!
    
    
    @IBOutlet var locationName: UITextView!
    @IBOutlet var sliderImage: ImageSlideshow!
    
    @IBOutlet var reviewsTableView: UITableView!
    
    @IBOutlet var imagesCollectionView: UICollectionView!
    @IBOutlet var locationCategory: UITextView!
    
    @IBOutlet var descriptionTxtView: UITextView!
    
    @IBOutlet var showMoreComments: UIButton!
    
    @IBOutlet weak var showMoreDesc: UIButton!
    
    @IBOutlet var firstViewIndicator: UIActivityIndicatorView!
    
    @IBOutlet var secondViewIndicator: UIActivityIndicatorView!
    
    @IBOutlet var secondView: UIView!
    
    
    @IBOutlet var zoomView: UIView!
    
    @IBOutlet var zoomImage: UIImageView!
    
    @IBOutlet weak var zoomScrollView: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.contentViewHeight.constant = 500
        
        self.showMoreComments.hidden=true
        self.showMoreDesc.hidden=true
        
        
        let quary = newDetail .valueForKey("name") as! String
        let location = newDetail .valueForKey("placeName") as! String //"chandigarh"
        let imageLink = newDetail.valueForKey("images") as! String
        let imageId = newDetail.valueForKey("imageId") as! String
        
        let parameter = "https://api.foursquare.com/v2/venues/search?intent=browse&limit=1&client_id=DAKFO3TURLDTUL33JNPRTIGX03NMZM2ACCDWC2HHHZTV2YMT&client_secret=ILF0G3U4DRSC0WDW2EH12SFGTOKIWSKFUIOXV4FFEQOIB34B&v=20140203&near=\(location)&query=\(quary)"
        
        self.datafromFoursquare(parameter)
        
        titleLabel.text=quary
        
        
        //////-------- Gradient background color ----/////////
        
        let layer = CAGradientLayer()
        layer.frame = CGRect(x: 0, y: 0, width: headerView.frame.size.width, height: self.headerView.frame.origin.y+self.headerView.frame.size.height)
        let blueColor = UIColor(red: 0/255, green: 146/255, blue: 198/255, alpha: 1.0).CGColor as CGColorRef
        let purpleColor = UIColor(red: 117/255, green: 42/255, blue: 211/255, alpha: 1.0).CGColor as CGColorRef
        layer.colors = [purpleColor, blueColor]
        layer.startPoint = CGPoint(x: 0.1, y: 0.5)
        layer.endPoint = CGPoint(x: 1.0, y: 0.5)
        layer.locations = [0.25,1.0]
       // self.headerView.layer.addSublayer(layer)
        
        self.headerView .bringSubviewToFront(headerImage)
        self.view .bringSubviewToFront(backBtn)
        
        self.headerView .bringSubviewToFront(headerLabel)
        
        self.headerView.alpha = 0
        self.headerImage.alpha = 0
        
        
        
        
        
        ///add bottom border to image slider
        let bottomBorder = CALayer()
        
        bottomBorder.frame = CGRectMake(0, self.sliderImage.frame.height-1, self.sliderImage.frame.size.width, 3)
        
        bottomBorder.backgroundColor = UIColor .lightGrayColor().CGColor
        
        self.sliderImage.layer .addSublayer(bottomBorder)
        
        
        
        
        var sdWebImageSource = [InputSource]()
        
        self.sliderImage.slideshowInterval = 0
        
        self.sliderImage.pageControlPosition = PageControlPosition.Hidden //PageControlPosition.InsideScrollView
        self.sliderImage.pageControl.currentPageIndicatorTintColor = UIColor.lightGrayColor()
        self.sliderImage.pageControl.pageIndicatorTintColor = UIColor.blackColor()
        self.sliderImage.draggingEnabled=true
        self.sliderImage.circular=false
        self.sliderImage.setCurrentPageForScrollViewPage(0)
        
        self.sliderImage.contentScaleMode = UIViewContentMode.ScaleAspectFill
        // self.slideShow.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.sliderImage.clipsToBounds=true
        
        sdWebImageSource.append(SDWebImageSource(urlString: imageLink as String)!)
        self.sliderImage.setImageInputs(sdWebImageSource )
        
        
        
        
        
        
        
        let singleTapGesture = GestureViewClass(target: self, action: #selector(nearByViewController.openZoomView))
        singleTapGesture.numberOfTapsRequired = 1 // Optional for single tap
        
        sliderImage.addGestureRecognizer(singleTapGesture)
        
        
        
        
        
        let singleTapGesture2 = GestureViewClass(target: self, action: #selector(nearByViewController.closeImageView))
        singleTapGesture.numberOfTapsRequired = 1 // Optional for single tap
        
        zoomView.addGestureRecognizer(singleTapGesture2)
        
        
        
        
        
        //////---- Add gesture on zoom view to swipe left and right
        var swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(nearByViewController.swiped(_:))) // put : at the end of method name
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.zoomView.addGestureRecognizer(swipeRight)
        
        var swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(nearByViewController.swiped(_:))) // put : at the end of method name
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.zoomView.addGestureRecognizer(swipeLeft)

        apiClass.sharedInstance().delegate=self
        
        
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        
       // self.contentViewHeight.constant = 70 + self.heightofFirstView.constant + self.heightOfSecondView.constant + self.heightOfThirdView.constant
        
        
        
        self.view .setNeedsLayout()
        self.view.layoutIfNeeded()
        
        
        
        self.view .bringSubviewToFront(backBtn)
        self.tabBarController?.tabBar.hidden = true
    }
    
    
    
    
    
    
    
    //scrolling detact
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if scrollView == imagesCollectionView {
            
        }
            
        else
        {
            if scrollView.contentOffset.y >= 130.0 {
                
                UIView.animateWithDuration(0.4, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                    self.headerView.alpha = 1
                     self.headerImage.alpha = 1
                    }, completion: nil)
                
                
            }
                
            else{
                
                UIView.animateWithDuration(0.4, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                    self.headerView.alpha = 0
                     self.headerImage.alpha = 0
                    }, completion: nil)
                
            }
            
            
        }
        
        
        
    }
    
    
    
    
    func swiped(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
                
            case UISwipeGestureRecognizerDirection.Right :
                print("User swiped right")
                 DirectionSwipe = "Right"
                // decrease index first
                
                indexOfZoomImg--
                
                // check if index is in range
                
                 if Thumbnails==true {
                if indexOfZoomImg < 0 {
                    
                    indexOfZoomImg = 0
                    
                }
                else{
                    self.changeZoomImage(indexOfZoomImg)
                }
                }
                
                
            case UISwipeGestureRecognizerDirection.Left:
                print("User swiped Left")
                 DirectionSwipe = "Left"
                // increase index first
                
                indexOfZoomImg++
                
                // check if index is in range
                
                if Thumbnails==true {
                    
                    if indexOfZoomImg > hotelImagesArray.count - 1 {
                        indexOfZoomImg = hotelImagesArray.count - 1
                        
                    }
                    else{
                         self.changeZoomImage(indexOfZoomImg)
                    }
                    
                    
                }
                    
             
            default:
                break //stops the code/codes nothing.
                
                
            }
            
        }
        
        
    }
    
    func changeZoomImage(index:Int) -> Void {
        
         self.zoomImage.transform = CGAffineTransformMakeScale(1.0,1.0 )
        
        if DirectionSwipe == "Right" {
            
            CATransaction.begin()
            CATransaction.setAnimationDuration(0.5)
            let transition = CATransition()
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromLeft
            
            zoomImage.layer.addAnimation(transition, forKey: kCATransition)
            zoomImage.layer.addAnimation(transition, forKey: kCATransition)
            
            

        
            if Thumbnails == true {
            let imageName = hotelImagesArray.valueForKey("normal") .objectAtIndex(indexOfZoomImg)
            let url = NSURL(string: imageName as! String)
            
            zoomImage.sd_setImageWithURL(url)
            
            let imageName2 = hotelImagesArray.valueForKey("original") .objectAtIndex(indexOfZoomImg)
            let url2 = NSURL(string: imageName2 as! String)
            let pImage2 = UIImageView()
            pImage2.sd_setImageWithURL(url, placeholderImage: nil)
            
            let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in
            }
            
            //completion block of the sdwebimageview
            zoomImage.sd_setImageWithURL(url2, placeholderImage: pImage2.image, completed: block)

        }
            CATransaction.commit()//moving effect of images
        }
        else if(DirectionSwipe == "Left"){
            
            CATransaction.begin()
            CATransaction.setAnimationDuration(0.5)
            let transition = CATransition()
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromRight
            
            zoomImage.layer.addAnimation(transition, forKey: kCATransition)
            zoomImage.layer.addAnimation(transition, forKey: kCATransition)
            

            if Thumbnails == true {
                let imageName = hotelImagesArray.valueForKey("normal") .objectAtIndex(indexOfZoomImg)
                let url = NSURL(string: imageName as! String)
                
                zoomImage.sd_setImageWithURL(url)
                
                let imageName2 = hotelImagesArray.valueForKey("original") .objectAtIndex(indexOfZoomImg)
                let url2 = NSURL(string: imageName2 as! String)
                let pImage2 = UIImageView()
                pImage2.sd_setImageWithURL(url, placeholderImage: nil)
                
                let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in
                }
                
                //completion block of the sdwebimageview
                zoomImage.sd_setImageWithURL(url2, placeholderImage: pImage2.image, completed: block)
                
            }
            CATransaction.commit()//moving effect of images
        }
        else{
            if Thumbnails == true {
                let imageName = hotelImagesArray.valueForKey("normal") .objectAtIndex(indexOfZoomImg)
                let url = NSURL(string: imageName as! String)
                
                zoomImage.sd_setImageWithURL(url)
                
                let imageName2 = hotelImagesArray.valueForKey("original") .objectAtIndex(indexOfZoomImg)
                let url2 = NSURL(string: imageName2 as! String)
                let pImage2 = UIImageView()
                pImage2.sd_setImageWithURL(url, placeholderImage: nil)
                
                let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in
                }
                
                //completion block of the sdwebimageview
                zoomImage.sd_setImageWithURL(url2, placeholderImage: pImage2.image, completed: block)
                
            }

        }
        
        
        
    }
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    //MARK:- Delegates and datasource of tableView
    //MARK:-
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return reviewsArray.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("CommentsCell")!
        
        
        
        
        let imageName2 = reviewsArray.objectAtIndex(indexPath.row).valueForKey("userPhoto") as! String
        
        let url2 = NSURL(string: imageName2 )
        
        
        
        
        let pImage : UIImage = UIImage(named:"backgroundImage")!
        
        
        
        
        
        
        
        let userProfilePicture = cell.contentView .viewWithTag(111) as! UIImageView
        userProfilePicture.layer.cornerRadius = userProfilePicture.frame.size.width/2
        userProfilePicture.clipsToBounds = true
        
        
        let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in
            
        }
        
        //completion block of the sdwebimageview
        userProfilePicture.sd_setImageWithURL(url2, placeholderImage: pImage, completed: block)
        
        
        
        let userNameLabel = cell.contentView .viewWithTag(112) as! UILabel
        userNameLabel.text = self.reviewsArray.objectAtIndex(indexPath.row).valueForKey("userName") as? String
        userNameLabel.font=UIFont(name: "Roboto-Bold", size: 15)!
        
        let userCommentLabel = cell.contentView .viewWithTag(113) as! UITextView
        userCommentLabel.text = self.reviewsArray.objectAtIndex(indexPath.row).valueForKey("comment") as! String
        userCommentLabel.textColor = UIColor .darkGrayColor()
        
        let commentTimeLabel = cell.contentView .viewWithTag(114) as! UILabel
        commentTimeLabel.text = ""
        
        return cell
        
    }
    
    
    
    
    
    
    
    
    
    
    //MARK:- CollectionView Data source and delegates
    //MARK:-
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int   {
        
        return 1
    }
    
    
    
    
    func collectionView(collectionView: UICollectionView,numberOfItemsInSection section: Int) -> Int {
        
        return  hotelImagesArray.count
        
    }
    
    func collectionView(collectionView: UICollectionView,cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("imagesCell",forIndexPath: indexPath)
        
        
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        cell.backgroundView = activityIndicatorView
        //self.view.bringSubviewToFront(cell.backgroundView!)
        activityIndicatorView.startAnimating()
        
        let nearByimage = cell.viewWithTag(1122) as! UIImageView
        
        
        
        let imageName2 = hotelImagesArray.valueForKey("normal") .objectAtIndex(indexPath.row)
        
        
        let url2 = NSURL(string: imageName2 as! String)
        
        let pImage : UIImage = UIImage(named:"backgroundImage")!
        
        
        let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in
            
        }
        
        //completion block of the sdwebimageview
        nearByimage.sd_setImageWithURL(url2, placeholderImage: pImage, completed: block)
        nearByimage.layer.cornerRadius=5
        nearByimage.clipsToBounds=true
        
        
        cell.backgroundColor=UIColor .clearColor()
        cell.layer.shadowColor = UIColor .lightGrayColor() .CGColor
        cell.layer.shadowOffset = CGSizeMake(0, 2.5)
        cell.layer.shadowOpacity = 1
        cell.layer.shadowRadius = 1.0
        cell.layer.masksToBounds=true
        cell.layer.cornerRadius=5
        
        
        return cell
        
        
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        
         DirectionSwipe = "None"
        Thumbnails=true
        indexOfZoomImg=indexPath.row
        
        zoomView.hidden=false
        self.view .bringSubviewToFront(zoomView)
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        self.zoomView .addSubview(activityIndicatorView)
        
        activityIndicatorView.startAnimating()
        
        zoomView .bringSubviewToFront(activityIndicatorView)
        
        
        self.changeZoomImage(indexOfZoomImg)
        
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
            let width1 = collectionView.frame.size.width/3.50  //1.8
            //  let height2 = collectionView.frame.size.height - 10
            
        
            
           // let height3: CGFloat = width1 - 10
            
            return CGSize(width: width1, height: 80.0) // The size of one cell
            
    }
    
    
    
    
    
    func datafromFoursquare(parameterStringHotels : String)
    {
        //ttp://terminal2.expedia.com:80/x/nlp/results?q=jw%20marriot%20in%20chandigharh&apikey=4PKZ0dIDVwXoTQoPeac9F8681XRwgpyA
        
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
            
            firstViewIndicator .startAnimating()
            var urlString = NSString(string:"\(parameterStringHotels)")
            print("WS URL----->>" + (urlString as String))
            
            //urlString = urlString .stringByReplacingOccurrencesOfString(" ", withString: "%20")
            
            
            let needsLove = urlString
            let safeURL = needsLove.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
            
            let url:NSURL = NSURL(string: safeURL as String)!
            print("Final Url-----> " + (safeURL as String))
            
            let session = NSURLSession.sharedSession()
            
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "GET"
            request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
            let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
                
                NSOperationQueue.mainQueue().addOperationWithBlock
                    {
                        indicatorClass.sharedInstance().hideIndicator()
                        
                        if data == nil
                        {
                            indicatorClass.sharedInstance().hideIndicator()
                            CommonFunctionsClass.sharedInstance().alertViewOpen("Server is not responding", viewController: self)
                            
                            self.firstViewIndicator .removeFromSuperview()
                            
                        }
                        else
                        {
                            
                            let result = NSString(data: data!, encoding:NSASCIIStringEncoding)!
                            
                            // activityIndicatorView .removeFromSuperview()
                            
                            
                            let jsonResult: AnyObject = try! NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.MutableContainers)
                            
                            var resultHotels = NSDictionary()
                            resultHotels = jsonResult as! NSDictionary
                            
                            
                            var hotelDetail = NSDictionary()
                            hotelDetail = resultHotels.valueForKey("response") as! NSDictionary
                            
                            
                            
                            let totalElements = hotelDetail.allKeys.count
                            if totalElements >= 1{
                                
                                var venues = []
                                
                                venues = hotelDetail.valueForKey("venues") as! NSMutableArray
                                
                                if venues.count<1{
                                    
                                    
                                    
                                }
                                else
                                {
                                    
                                    if let venueId = venues[0].valueForKey("id"){
                                        
                                        
                                        dispatch_async(dispatch_get_main_queue(), {
                                            
                                            
                                            self .getPhotosOfHotel(venueId as! String)
                                            
                                        })
                                        
                                    }
                                    
                                    
                                    
                                    
                                    let hotelname = venues[0].valueForKey("name") as? String ?? "NA"
                                    
                                    self.locationName.editable=true
                                    self.locationName.scrollEnabled=false
                                    
                                    self.locationName.text=hotelname
                                    self.locationName.font=UIFont(name: "Roboto-Light", size: 16)!
                                    self.locationName.textColor = UIColor .lightGrayColor()
                                    
                                    let fixedWidth = self.locationName.frame.size.width
                                    self.locationName.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
                                    let newSize = self.locationName.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
                                    var newFrame = self.locationName.frame
                                    newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
                                  
                                    
                                    self.locationName.frame = newFrame
                                    
                                    self.heightofFirstView.constant = 210 + self.locationName.frame.size.height + self.imagesCollectionView.frame.size.height
                                    
                                    self.locationName.editable=false
                                    self.firstView .setNeedsLayout()
                                    
                                    var phoneString = NSString()
                                    var addressstring = NSString()
                                    var countryString = NSString()
                                    var cityString = NSString()
                                    var stateString = NSString()
                                    var checkInString = NSString()
                                    var userCountString = NSString()
                                    var tipString = NSString()
                                    var categoryString = NSString()
                                    
                                    
                                    
                                    if let phoneNo = venues[0].valueForKey("contact")?.valueForKey("phone"){
                                        phoneString = phoneNo as? String ?? "NA"
                                    }
                                    print(venues[0].valueForKey("location"))
                                    
                                    if let address = venues[0].valueForKey("location")?.valueForKey("address")
                                    {
                                        
                                        addressstring = address as? String ?? "NA"
                                        
                                        
                                        if let country = venues[0].valueForKey("location")?.valueForKey("country")
                                        {
                                            
                                            countryString = country as? String ?? "NA"
                                        }
                                        if let city = venues[0].valueForKey("location")?.valueForKey("city")
                                        {
                                            cityString = city as? String ?? "NA"
                                        }
                                        
                                        if let state = venues[0].valueForKey("location")?.valueForKey("state")
                                        {
                                            stateString = state as? String ?? "NA"
                                        }
                                        
                                        if let categ = venues[0].objectForKey("categories")![0]["name"]
                                        {
                                            
                                            categoryString = categ as? String ?? "NA"
                                            
                                            
                                        }
                                        
                                        
                                        
                                    }
                                    
                                    
                                    if let checksIn = venues[0].valueForKey("stats")?.valueForKey("checkinsCount")
                                    {
                                        checkInString = checksIn as? String ?? "NA"
                                        
                                        if let userCount = venues[0].valueForKey("stats")?.valueForKey("usersCount")
                                        {
                                            userCountString = userCount as? String ?? "NA"
                                        }
                                        
                                        if let tipCount = venues[0].valueForKey("stats")?.valueForKey("tipCount")
                                        {
                                            tipString = tipCount as? String ?? "NA"
                                            
                                        }
                                        
                                        
                                    }
                                    
                                    if let urlHotel = venues[0].valueForKey("url")
                                    {
                                        
                                        self.webLinkString=urlHotel as! String
                                        
                                    }
                                    
                                    
                                    self.locationCategory.editable=true
                                    self.locationCategory.text = categoryString as String
                                    self.locationCategory.textColor = UIColor(red:19/255.0, green:201/255.0, blue:195/255.0, alpha: 1.0)
                                    self.locationCategory.font=UIFont(name: "Roboto-Medium", size: 16)!
                                    self.locationCategory.textAlignment = NSTextAlignment.Right
                                    self.locationCategory.clipsToBounds=true
                                    self.locationCategory.editable=true
                                    
                                    
                                    if phoneString==""{
                                        phoneString = "NA"
                                    }
                                    
                                }
                                
                            }
                            
                            self.firstViewIndicator .removeFromSuperview()
                            
                            
                            
                            self.contentViewHeight.constant = 70 + self.heightofFirstView.constant + self.heightOfSecondView.constant + self.heightOfThirdView.constant
                            
                            print(self.contentViewHeight.constant)
                            
                            
                            self.view .setNeedsLayout()
                            self.view.layoutIfNeeded()
                            
                            
                        }
                }
                
            })
            
            task.resume()
        }
        else
        {
            CommonFunctionsClass.sharedInstance().alertViewOpen("Please Check Internet Connection", viewController: self)
        }
    }
    
    
    
    //MARK:- Actions of buttons
    //MARK:-
    
    
    @IBAction func showCommentsAction(sender: AnyObject) {
        
        let nxtObj2 = self.storyboard?.instantiateViewControllerWithIdentifier("commentsViewController") as? commentsViewController
        nxtObj2!.commentsArray=self.reviewsArray
        
        
        self.navigationController! .pushViewController(nxtObj2!, animated: true)
        
    }
    
    
    @IBAction func ShowMoreDesc(sender: AnyObject) {
        
        let nxtObj2 = self.storyboard?.instantiateViewControllerWithIdentifier("DescriptionViewViewController") as? DescriptionViewViewController
        nxtObj2!.descriptionString2=self.descriptionString
        nxtObj2!.title=locationName.text
        
        self.navigationController! .pushViewController(nxtObj2!, animated: true)
        
    }
    
    
    
    
    @IBAction func BackBtnAction(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
        self.dismissViewControllerAnimated(true, completion: {})
        NSURLCache.sharedURLCache().removeAllCachedResponses()
    }
    
    
      
    
    
    
    @IBAction func zoomAction(sender: UIPinchGestureRecognizer) {

        
        
//        self.zoomImage.transform = CGAffineTransformScale(self.zoomImage.transform, sender.scale, sender.scale)
//        
//        sender.scale = 1
        
    }
    
    
    func closeImageView() {
        
        
        zoomView.hidden=true
        
    }
    
    
    
    
    
    func openZoomView() -> Void {
       
        self.zoomScrollView.minimumZoomScale = 1.0
        self.zoomScrollView.maximumZoomScale = 5.0
        
        self.zoomScrollView.zoomScale = 1.0
        
        
        Thumbnails=false
        
        zoomView.hidden=false
        self.view .bringSubviewToFront(zoomView)
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        
        activityIndicatorView.startAnimating()
        
        let imageLink = newDetail.valueForKey("images") as! String
        let url2 = NSURL(string: imageLink as String)
        
        
        
        zoomImage.sd_setImageWithURL(url2)
        
        
        let pImage : UIImage = UIImage(named:"backgroundImage")!
        
        
        let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in
            
        }
        
        //completion block of the sdwebimageview
        zoomImage.sd_setImageWithURL(url2, placeholderImage: pImage, completed: block)
        
        
    }
    
    
    
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView?
    {
        if scrollView==zoomScrollView {
            return self.zoomImage
        }
            
        else{
            return self.view
        }
        
    }
    
    
    
    
    
    
    
    //MARK: - action of add to story
    //MARK:
    @IBAction func addStoryAction(sender: AnyObject) {
        
       // print(arrayWithData[0])
        
        //addStoryBtn.setImage(UIImage (named: "detailStory2"), forState: UIControlState .Normal)
        
        
        
        /*
         print(arrayWithData[0])
         
         let imageId = self.arrayWithData[0] .valueForKey("imageId") as? String ?? ""
         let locationImageStr = self.arrayWithData[0] .valueForKey("locationImage") as? String ?? ""
         let countryName = self.arrayWithData[0] .valueForKey("CountryName") as? String ?? ""
         
         var tagGeo = self.arrayWithData[0] .valueForKey("geoTag") as? String ?? ""
         
         
         let defaults = NSUserDefaults.standardUserDefaults()
         let uId = defaults .stringForKey("userLoginId")
         
         let profileImage = self.arrayWithData[0] .valueForKey("profileImage") as? NSString ?? ""
         
         let lat = self.arrayWithData[0] .valueForKey("latitude") as! NSNumber
         let long = self.arrayWithData[0] .valueForKey("longitude") as! NSNumber
         
         
         
         
         
         
         
         let dat: NSDictionary = ["userid": "\(uId!)", "id": imageId, "imageLink": locationImageStr, "location": countryName, "source":"facebook", "latitude": lat, "longitude": long, "geoTag":tagGeo, "category":self.categoryTxtv.text, "location":"", "description":descriptionTextv.text, "userName":userNameTxtv.text,"type":"", "profileImage":profileImage ]
         
         var postDict = NSDictionary()
         
         postDict = dat
         
         print("Post parameters to select the images for story--- \(postDict)")
         
         
         apiClass.sharedInstance().postRequestWithMultipleImage("", parameters: postDict, viewController: self)
         
         */
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //MARK:- Get the images from the four square api of the hotels
    //MARK:-
    
    func getPhotosOfHotel(idString:NSString) -> Void {
        
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
            
            firstViewIndicator .startAnimating()
            var urlString = NSString(string:"https://api.foursquare.com/v2/venues/\(idString)?client_id=DAKFO3TURLDTUL33JNPRTIGX03NMZM2ACCDWC2HHHZTV2YMT&client_secret=ILF0G3U4DRSC0WDW2EH12SFGTOKIWSKFUIOXV4FFEQOIB34B&v=20140203")
            
            
            
            let needsLove = urlString
            let safeURL = needsLove.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
            
            let url:NSURL = NSURL(string: safeURL as String)!
            print("Final Url-----> " + (safeURL as String))
            
            let session = NSURLSession.sharedSession()
            
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "GET"
            request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
            let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
                
                NSOperationQueue.mainQueue().addOperationWithBlock
                    {
                        indicatorClass.sharedInstance().hideIndicator()
                        
                        if data == nil
                        {
                            indicatorClass.sharedInstance().hideIndicator()
                            CommonFunctionsClass.sharedInstance().alertViewOpen("Server is not responding", viewController: self)
                            self.firstViewIndicator.removeFromSuperview()
                        }
                        else
                        {
                            
                            let result = NSString(data: data!, encoding:NSASCIIStringEncoding)!
                            
                            
                            
                            let jsonResult: AnyObject = try! NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.MutableContainers)
                            
                            var resultHotels = NSDictionary()
                            resultHotels = jsonResult as! NSDictionary
                            
                            
                            
                            var hotelDetail = NSDictionary()
                            hotelDetail = resultHotels.valueForKey("response") as! NSDictionary
                            
                            
                            let totalElements = hotelDetail.allKeys.count
                            if totalElements >= 1{
                                
                                
                                var  venues = hotelDetail.valueForKey("venue") as! NSMutableDictionary
                                
                                
                                print(venues.valueForKey("location")!.valueForKey("country"))
                                self.country = venues.valueForKey("location")!.valueForKey("country") as! String
                                print("---------country-=\(self.country)0-----------------------------")
                                
                                self.descriptionTxtView.text=""
                                
                                self.heightOfSecondView.constant = 0
                                self.secondView.hidden=true
                                self.view .setNeedsLayout()
                                if let desc =  venues.valueForKey("description")
                                {
                                    self.descriptionString=desc as! NSString
                                    self.descriptionTxtView.editable=true
                                    self.descriptionTxtView.text=self.descriptionString as String
                                    self.descriptionTxtView.font=UIFont(name: "Roboto-Bold", size: 12)!
                                    self.descriptionTxtView.textColor = UIColor .lightGrayColor() //UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1.0)
                                    self.descriptionTxtView.editable=false
                                    self.heightOfSecondView.constant = 190
                                    
                                    if desc.length>150
                                    {
                                        self.showMoreDesc.hidden=false
                                    }
                                    
                                    self.secondView.hidden=false
                                    self.view .setNeedsLayout()
                                }
                                
                                
                                
                                if venues.valueForKey("photos")!.valueForKey("count") as! Int == 0 {
                                    
                                }
                                else
                                {
                                    
                                    let photos = venues .valueForKey("photos")! .valueForKey("groups")![0] .valueForKey("items") as! NSMutableArray
                                    
                                    
                                    
                                    
                                    
                                    
                                    dispatch_async(dispatch_get_main_queue(), {
                                        
                                        
                                        for l in 0..<photos.count
                                        {
                                            let str1 = photos[l].valueForKey("prefix") as! String
                                            let str2 = photos[l].valueForKey("suffix") as! String
                                            
                                            let combinedString = "\(str1)200x200\(str2)"
                                            let combinedString2 = "\(str1)original\(str2)"
                                            
                                            
                                            self.hotelImagesArray .addObject(["normal": combinedString, "original": combinedString2])
                                        }
                                        
                                        self.imagesCollectionView .reloadData()
                                        
                                        
                                        
                                    })
                                    
                                    
                                    
                                }
                                
                                
                                
                                
                                ////----- Get reviews
                                if venues.valueForKey("tips")!.valueForKey("count") as! Int == 0 {
                                    
                                    self.reviewsTableView.rowHeight=0
                                }
                                    
                                else
                                {
                                    var itemsArray = NSMutableArray()
                                    
                                    itemsArray = venues.valueForKey("tips")!.valueForKey("groups")?.objectAtIndex(0) .valueForKey("items") as! NSMutableArray
                                    
                                    
                                    for j in 0..<itemsArray.count{
                                        
                                        
                                        let text = itemsArray.objectAtIndex(j).valueForKey("text") as! String
                                        
                                        
                                        let prefix = itemsArray.objectAtIndex(j) .valueForKey("user")?.valueForKey("photo")!.valueForKey("prefix") as? String ?? ""
                                        
                                        
                                        let suffix = itemsArray.objectAtIndex(j) .valueForKey("user")?.valueForKey("photo")!.valueForKey("suffix") as? String ?? ""
                                        
                                        let combinePhoto = "\(prefix)300x300\(suffix)"
                                        
                                        
                                        
                                        
                                        let firstName = itemsArray.objectAtIndex(j) .valueForKey("user")? .valueForKey("firstName") as? String ?? ""
                                        
                                        
                                        let lastName = itemsArray.objectAtIndex(j) .valueForKey("user")? .valueForKey("lastName") as? String ?? ""
                                        
                                        
                                        let combineName = "\(firstName) \(lastName)"
                                        
                                        
                                        self.reviewsArray .addObject(["userPhoto": combinePhoto, "userName": combineName, "comment": text])
                                        
                                        
                                        
                                    }
                                    
                                    self.reviewsTableView.reloadData()
                                    
                                    self.heightOfTableView.constant=self.reviewsTableView.rowHeight*2
                                    if self.reviewsArray.count<2{
                                        self.heightOfTableView.constant=self.reviewsTableView.rowHeight * CGFloat(self.reviewsArray.count)
                                    }
                                    
                                    self.heightOfThirdView.constant = 0
                                    self.heightOfThirdView.constant=self.heightOfTableView.constant + 88
                                    
                                }
                                
                                
                                
                                
                                
                                
                                
                                
                                
                            }
                            
                            self.firstViewIndicator .removeFromSuperview()
                            self.secondViewIndicator.removeFromSuperview()
                            
                            
                            if self.reviewsArray.count>0{
                                
                                self.showMoreComments.hidden=false
                            }
                            
                            
                            self.contentViewHeight.constant = 70 + self.heightofFirstView.constant + self.heightOfSecondView.constant + self.heightOfThirdView.constant
                            
                            print(self.contentViewHeight.constant)
                            
                            
                            self.view .setNeedsLayout()
                            
                            
                        }
                }
                
            })
            
            task.resume()
        }
        else
        {
            CommonFunctionsClass.sharedInstance().alertViewOpen("Please Check Internet Connection", viewController: self)
        }
        
        
        
    }
    
    
    
    
    
    
    
    
    //MARK:- Response from the storyApi
    //MARK:-
    
    func serverResponseArrived(Response:AnyObject)
    {
        
        
        //////////---------- REsponse for the add and delete image in story-----------////////
        
        
        
        jsonResult = NSDictionary()
        jsonResult = Response as! NSDictionary
        
        let success = jsonResult.objectForKey("status") as! NSNumber
        
        if success != 1
        {
            
            CommonFunctionsClass.sharedInstance().alertViewOpen("Sorry image is not added to story, Please try again", viewController: self)
        }
        
        
        
        
        
    }
    
    
    
    

    
    
    
    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
         NSURLCache.sharedURLCache().removeAllCachedResponses()
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
