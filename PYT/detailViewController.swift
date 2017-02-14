//
//  detailViewController.swift
//  PYT
//
//  Created by Niteesh on 25/10/16.
//  Copyright © 2016 appsMaven. All rights reserved.
//

import UIKit
import SDWebImage
import ImageSlideshow
import MBProgressHUD

class detailViewController: UIViewController, apiClassDelegate {
    
    
    
    @IBOutlet var contentViewHeight: NSLayoutConstraint!
    
    @IBOutlet var heightOfFirstView: NSLayoutConstraint!//1st View of scroll
    
    
    
    @IBOutlet var heightOfSecondView: NSLayoutConstraint! //2nd View of scroll
    
    
    @IBOutlet var heightOfThirdView: NSLayoutConstraint!
    
    @IBOutlet var heightOfTableView: NSLayoutConstraint!
    
    
    
    @IBOutlet var firstView: UIView!//contains slide images and user info
    @IBOutlet var secondView: UIView!//contaion description view
    
    @IBOutlet weak var topspaceOfThumbnailCollectionView: NSLayoutConstraint!
    
    @IBOutlet var thirdView: UIView!//contains reviews table view 
    
    
    @IBOutlet var forthView: UIView!//contains near by collection view
    
    @IBOutlet weak var ThumbnailsView: UIView!//Contaims thumbnails collection view
    
    
    @IBOutlet var userNameHeight: NSLayoutConstraint!
    
    @IBOutlet var locationHeight: NSLayoutConstraint!
    
    
    
    @IBOutlet weak var commentButton: UIButton!
    
    
    //zoomView
    
    @IBOutlet var zoomView: UIView!
    @IBOutlet var zoomimageView: UIImageView!
    @IBOutlet weak var zoomIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var zoomScrollView: UIScrollView!
    
    
    
    
    
    @IBOutlet var bottomView: UIView!
    
    @IBOutlet weak var bottomView2: UIView!
   
    
    
    
    
    
    @IBOutlet var detailTable: UITableView!
    @IBOutlet var collectionViewImages: UICollectionView!
    
    @IBOutlet var webLinkBtnOutlet: UIButton!
    
    
    
    @IBOutlet var addCommentOutlet: UIButton!
    
    
    
    @IBOutlet var collectionViewThumbnails: UICollectionView!
    
    
    
    @IBOutlet weak var collectionHeightThumbnails: NSLayoutConstraint!
    
    @IBOutlet weak var morePictureLabel: UILabel!
    @IBOutlet weak var collectionContainView: NSLayoutConstraint!
    
    // @IBOutlet var locationImage: UIImageView!
    @IBOutlet var slideShow: ImageSlideshow!
    
    
    @IBOutlet var profilePicImage: UIImageView!
    
    @IBOutlet var borderView: UIImageView!
    
    
    @IBOutlet var userNameTxtv: UITextView!
    @IBOutlet var locationTxtv: UITextView!
    @IBOutlet var categoryTxtv: UITextView!

    @IBOutlet var categoryViewHeight: NSLayoutConstraint!
    
    
    
    @IBOutlet var descriptionTextv: UITextView!
    @IBOutlet var showMoreDescription: UIButton!
    
    
    
    @IBOutlet var timingsTextv: UITextView!
    
    
    @IBOutlet var showMoreComments: UIButton!
    
    
    @IBOutlet var headerView: UIView!
    @IBOutlet var headerImageView: UIImageView!
    
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var BackBtn: UIButton!
    //@IBOutlet var addStoryBtn: UIButton!
    
    
    //bottom tab
    @IBOutlet var stImg: UIImageView!
    @IBOutlet var likeImg: UIImageView!
    @IBOutlet var bucketImg: UIImageView!
     @IBOutlet var deleteImg: UIImageView!
    
    
    var firstTime = true
    var fromStory = Bool()
    
    
    
    
    
    
    var arrayWithData = NSMutableArray()
    var webLinkString = NSString()
    var hotelImagesArray = NSMutableArray()
    var descriptionString = NSString()
    var nearByPlacesArray = NSMutableArray()
    var reviewsArray = NSMutableArray()
    var zoomImagesArray = NSMutableArray()
    var indexOfZoomImg = Int()
    var Thumbnails = Bool()
    var DirectionSwipe = NSString()
    var countLikes = NSMutableArray()
    var fromInterest = Bool()
    var LAT = NSNumber()
    var LONG = NSNumber()
    
    
    
    
    
    ////// Indicators ////
    
    @IBOutlet var forthIndicator: UIActivityIndicatorView!
    
    @IBOutlet var secondIndicator: UIActivityIndicatorView!
    
    @IBOutlet var firstIndicator: UIActivityIndicatorView!
    
    
    
    
    
    //Api's manage
    var task1 = NSURLSessionDataTask?()
    var task2 = NSURLSessionDataTask?()
    var task3 = NSURLSessionDataTask?()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //contentViewHeight.constant=200
        
       
        print(arrayWithData)
        
        
        
        
        let profileImage = self.arrayWithData[0] .valueForKey("profileImage") as? NSString ?? ""
        let url = NSURL(string: profileImage as String)
        
        LAT = self.arrayWithData[0] .valueForKey("latitude") as! NSNumber
        LONG = self.arrayWithData[0] .valueForKey("longitude") as! NSNumber
        
        profilePicImage.sd_setImageWithURL(url, placeholderImage: UIImage (named: "logo"))
        profilePicImage.layer.cornerRadius=profilePicImage.frame.size.width/2
        profilePicImage.clipsToBounds=true
        
      
        let locationImageStandard = self.arrayWithData[0] .valueForKey("standardImage") as! NSString
       // let urlStand = NSURL(string: locationImageStr as String)
        
        var multiImg = NSMutableArray()
        multiImg = self.arrayWithData[0].valueForKey("multipleImagesLarge")as! NSMutableArray
        
        var multiImgStandard = NSMutableArray()
        multiImgStandard = self.arrayWithData[0].valueForKey("multipleImagesStandard")as! NSMutableArray
        
        
        
        
        
        self.slideImages(multiImgStandard, imageLink: locationImageStandard)
        
        
        
        
        
        let NearLoc = "\(self.arrayWithData[0] .valueForKey("Venue") as! NSString)"
        //, \(self.arrayWithData[0] .valueForKey("CountryName") as! NSString)"
        headerLabel.text=NearLoc as String
        
        var tagGeo = self.arrayWithData[0] .valueForKey("geoTag") as! String
        

        
        
        
        if tagGeo==" " {
            tagGeo=NearLoc as String
        }
        
        
        
        

            var parameter = ""
        
        if LAT == 0 {
           parameter = "https://api.foursquare.com/v2/venues/search?intent=browse&limit=1&client_id=DAKFO3TURLDTUL33JNPRTIGX03NMZM2ACCDWC2HHHZTV2YMT&client_secret=ILF0G3U4DRSC0WDW2EH12SFGTOKIWSKFUIOXV4FFEQOIB34B&v=20140203&near=\(NearLoc)&query=\(tagGeo)"
        }
        else
        {
           parameter = "https://api.foursquare.com/v2/venues/search?intent=browse&limit=1&client_id=DAKFO3TURLDTUL33JNPRTIGX03NMZM2ACCDWC2HHHZTV2YMT&client_secret=ILF0G3U4DRSC0WDW2EH12SFGTOKIWSKFUIOXV4FFEQOIB34B&v=20140203&query=\(tagGeo)&ll=\(String(self.LAT)),\(String(self.LONG))&radius=1500"
        }
        
        
        
        
       
            
            self.datafromFoursquare(parameter)
        
        
        
        /// user name textview ///
        self.userNameTxtv.editable=true
        self.userNameTxtv.scrollEnabled=false
        self.userNameTxtv.text = self.arrayWithData[0].valueForKey("userName") as! String
        self.userNameTxtv.font=UIFont(name: "Roboto-Regular", size: 20)!
        let fixedWidth = self.userNameTxtv.frame.size.width
        self.userNameTxtv.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
        let newSize = self.userNameTxtv.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
        var newFrame = self.userNameTxtv.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        self.userNameTxtv.frame = newFrame;
        userNameHeight.constant = self.userNameTxtv.frame.size.height - 8
        self.userNameTxtv.editable=false
        
        
        
        ///// zoom images
        zoomView.hidden=true
        let singleTapGesture = GestureViewClass(target: self, action: #selector(detailViewController.openZoomView))
        singleTapGesture.numberOfTapsRequired = 1 // Optional for single tap
        slideShow.addGestureRecognizer(singleTapGesture)
        
        /// clos ethe zoom view
        let singleTapGesture2 = GestureViewClass(target: self, action: #selector(detailViewController.closeImageView))
        singleTapGesture.numberOfTapsRequired = 1 // Optional for single tap
        zoomView.addGestureRecognizer(singleTapGesture2)
        
        
        
        
        
        //////---- Add gesture on zoom view to swipe left and right on zoom view
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(detailViewController.swiped(_:))) // put : at the end of method name
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.zoomView.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(detailViewController.swiped(_:))) // put : at the end of method name
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.zoomView.addGestureRecognizer(swipeLeft)
        
        
        
        
        
         firstIndicator .startAnimating()
        secondIndicator .startAnimating()
        forthIndicator .startAnimating()
        
        self.webLinkBtnOutlet.hidden=true
        
    
        apiClass.sharedInstance().delegate=self //delegate for response api
        
      
        
        
        //manage for Like and unlike
        let like = self.arrayWithData[0] .valueForKey("likeBool") as! Bool
        if like {
            likeImg.image = UIImage (named: "detailLike2")
        }
        else
        {
            likeImg.image=UIImage (named: "detailLike")
        }
        
        
        
        
       
        
         let imageId = self.arrayWithData[0] .valueForKey("imageId") as? String ?? ""
        
        var countst = NSArray()
        
        if countArray.objectForKey("storyCount") != nil {
            if let stCount = countArray.valueForKey("storyCount"){
                  countst = countArray.valueForKey("storyImages") as! NSArray
            }
        }
       
       stImg.image=UIImage.init(named: "detailStory")
        if countst.count>0 {
            
            print(countst)
            if countst.containsObject(imageId) {
                stImg.image=UIImage.init(named: "detailStory2")
            }
            
        }
        
        
        
        //bucket count
        
         var countBkt = NSArray()
        
        if countArray.objectForKey("bucketCount") != nil {
            if let bktCount = countArray.valueForKey("bucketCount"){
                countBkt = countArray.valueForKey("bucketImages") as! NSArray
            }
        }
        
        
        bucketImg.image=UIImage.init(named: "detailBucket")
        if countBkt.count>0
        {
            
            print(countBkt)
            if countBkt.containsObject(imageId) {
                bucketImg.image=UIImage.init(named: "detailBucket2")
            }
            
        }
        
        
        
        
        
        
        
        
        
        
        
        ////category
        
        var type = self.arrayWithData[0] .valueForKey("Category") as? String ?? " "
        
        //// temporary change the category random to Others
        let newCatRr: NSArray = type .componentsSeparatedByString(",")
        
        let  newcat2 = NSMutableArray()
        
        for ll in 0..<newCatRr.count {
            
            var stCat = newCatRr.objectAtIndex(ll) as? String ?? ""
            print(stCat)
            
            if stCat == "Random" || stCat == "random" {
                stCat = "Others"
            }
            newcat2 .addObject(stCat)
        }
        
        
        type = newcat2.componentsJoinedByString(",")
        
        
        
        
        self.categoryTxtv.editable=true
        self.categoryTxtv.text = type //?.componentsJoinedByString(",")  //categoryString as String
        self.categoryTxtv.textColor = UIColor .blackColor() //(red:19/255.0, green:201/255.0, blue:195/255.0, alpha: 1.0)
        self.categoryTxtv.font=UIFont(name: "Roboto-Medium", size: 14)!
        self.categoryTxtv.textAlignment = NSTextAlignment.Left
        self.categoryTxtv.clipsToBounds=true
        
        self.categoryTxtv.editable=false
        
        
        
        print(self.heightOfFirstView.constant)
        
        

        var hotelname = self.arrayWithData[0] .valueForKey("geoTag") as! String
        if hotelname == ""{
            hotelname = self.arrayWithData[0].valueForKey("cityName") as! String
            if hotelname == ""{
                hotelname = self.arrayWithData[0].valueForKey("CountryName") as! String
            }
            
            
        }
        
        
        self.locationTxtv.editable=true
        self.locationTxtv.scrollEnabled=false
        
        self.locationTxtv.text=hotelname
        self.locationTxtv.font=UIFont(name: "Roboto-Light", size: 15)!
        self.locationTxtv.textColor = UIColor .lightGrayColor()
        self.locationTxtv.textAlignment=NSTextAlignment .Right
        print(self.locationTxtv.frame)
        self.locationTxtv.editable=false
        
        
        
        
        
        
        ////MANAGE the images to delete of pyt
        
        bottomView.hidden=true
        bottomView2.hidden=false
        
        
        
        let photoType = self.arrayWithData[0] .valueForKey("Type") as? String ?? ""
        let otherUserId = self.arrayWithData[0] .valueForKey("otherUserId") as? String ?? ""
        let defaults = NSUserDefaults.standardUserDefaults()
        let uId = defaults .stringForKey("userLoginId")
        
        if photoType == "PYT" {
            
            if otherUserId == uId! {
                
                print("Enter if match the user id")
                
                bottomView.hidden=false
                bottomView2.hidden=true
                
                
            }
            
            
        }
        
        
        
        

        
        
        
        
        
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(detailViewController.loadDeletedCell(_:)),name:"loadDeleteDetail", object: nil)
        
        
    }
    
    
    func loadDeletedCell(notification: NSNotification) {
        
        
       print("Delete image done")
        
        self.BackAction(self)
        
        
        
    }
    
    
    
    
    
    
    override func viewWillAppear(animated: Bool)
    {
        NSURLCache.sharedURLCache().removeAllCachedResponses()
        
        if firstTime==false {
            
        }else
        {
            
            
            
            
            
            addCommentOutlet.layer.cornerRadius=addCommentOutlet.frame.size.height/2
            addCommentOutlet.clipsToBounds=true
            
            self.view .setNeedsLayout()
            
            
            
            
            /////-------- Gradient background color ----/////////
            
            let layer = CAGradientLayer()
            layer.frame = CGRect(x: 0, y: 0, width: headerView.frame.size.width, height: self.headerView.frame.origin.y+self.headerView.frame.size.height)
            let blueColor = UIColor(red: 0/255, green: 146/255, blue: 198/255, alpha: 1.0).CGColor as CGColorRef
            let purpleColor = UIColor(red: 117/255, green: 42/255, blue: 211/255, alpha: 1.0).CGColor as CGColorRef
            layer.colors = [purpleColor, blueColor]
            layer.startPoint = CGPoint(x: 0.1, y: 0.5)
            layer.endPoint = CGPoint(x: 1.0, y: 0.5)
            layer.locations = [0.25,1.0]
            //self.headerView.layer.addSublayer(layer)
            
            
            
            ///// header view with animated effect
            
            self.view .bringSubviewToFront(BackBtn)
            self.headerView .bringSubviewToFront(headerImageView)
            self.headerView .bringSubviewToFront(headerLabel)
            self.headerView.alpha = 0
            
            
            
            
            
            
            
            
            //// add border to profile picture///
            borderView.layer.cornerRadius=borderView.frame.size.width/2
            borderView.clipsToBounds=true
            //self.profilePicImage.bringSubviewToFront(borderView)
            
            firstTime=false
         
            
        
    
            ///// ///////--------UiView contains the collection View--------////////
            
            let photosCollectView = self.view.viewWithTag(701010)
           photosCollectView!.layer.cornerRadius=5
            photosCollectView!.clipsToBounds=true
            photosCollectView!.layer.shadowColor = UIColor .init(colorLiteralRed: 215/255, green: 215/255, blue: 215/255, alpha: 1).CGColor
            photosCollectView!.layer.shadowOffset = CGSizeMake(0, 2.0)
            photosCollectView!.layer.shadowOpacity = 1
            photosCollectView!.layer.shadowRadius = 1.0
           photosCollectView!.layer.masksToBounds=false
            
            
            let shadowPath = UIBezierPath(rect: (photosCollectView?.bounds)!)
            layer.masksToBounds = false
            layer.shadowColor = UIColor.blackColor().CGColor
            layer.shadowOffset = CGSizeMake(0.0, 5.0)
            layer.shadowOpacity = 0.5
            layer.shadowPath = shadowPath.CGPath

            
            
            
            
            
            secondView!.layer.cornerRadius=5
            secondView!.clipsToBounds=true
            secondView!.layer.shadowColor = UIColor .init(colorLiteralRed: 215/255, green: 215/255, blue: 215/255, alpha: 1).CGColor
            secondView!.layer.shadowOffset = CGSizeMake(0, 2.0)
            secondView!.layer.shadowOpacity = 1
            secondView!.layer.shadowRadius = 1.5
            secondView!.layer.masksToBounds=false
            
            thirdView!.layer.cornerRadius=5
            thirdView!.clipsToBounds=true
            thirdView!.layer.shadowColor = UIColor .init(colorLiteralRed: 215/255, green: 215/255, blue: 215/255, alpha: 1).CGColor
            thirdView!.layer.shadowOffset = CGSizeMake(0, 2.0)
            thirdView!.layer.shadowOpacity = 1
            thirdView!.layer.shadowRadius = 1.5
            thirdView!.layer.masksToBounds=false
            
            
            
            forthView!.layer.cornerRadius=5
            forthView!.clipsToBounds=true
            forthView!.layer.shadowColor = UIColor .init(colorLiteralRed: 215/255, green: 215/255, blue: 215/255, alpha: 1).CGColor
            forthView!.layer.shadowOffset = CGSizeMake(0, 2.0)
            forthView!.layer.shadowOpacity = 1
            forthView!.layer.shadowRadius = 1.5
            forthView!.layer.masksToBounds=false
            
            
            
            self.webLinkBtnOutlet.layer.borderWidth=1.0
            self.webLinkBtnOutlet.layer.borderColor=UIColor .blackColor().CGColor
            self.webLinkBtnOutlet.layer.cornerRadius=3
            self.webLinkBtnOutlet.clipsToBounds=true
            
            
            self.commentButton.layer.borderWidth=1.0
            self.commentButton.layer.borderColor=UIColor .blackColor().CGColor
            self.commentButton.layer.cornerRadius=3
            self.commentButton.clipsToBounds=true
            
            
            
        }
        
        
        
        
        
        if fromStory==true
        {
            bottomView.hidden=true
            bottomView2.hidden=true
        }
        
        
        self.view .bringSubviewToFront(BackBtn)
         
        
        self.tabBarController?.tabBar.hidden = true
        showMoreDescription.userInteractionEnabled=false
        
    }
    
    
    
    
    
    
    override func viewWillDisappear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = false
    }
    
    
    
    
    override func viewDidAppear(animated: Bool) {
        
        //self.showMoreComments.hidden=false
        if self.reviewsArray.count<1 {
            self.heightOfThirdView.constant = 100
            //self.showMoreComments.hidden=true
        }
        
        
        
        
        
        
        
       
            super.viewDidAppear(animated)
            
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    //MARK:- Slide Images of the image slider 
    //MARK:
    func slideImages(multipleImages:NSMutableArray, imageLink:NSString) -> Void {
        
        var sdWebImageSource = [InputSource]()
        
        self.slideShow.slideshowInterval = 0
        self.slideShow.pageControlPosition = PageControlPosition.Hidden //PageControlPosition.InsideScrollView
        self.slideShow.pageControl.currentPageIndicatorTintColor = UIColor.lightGrayColor()
        
        
        self.slideShow.pageControl.pageIndicatorTintColor = UIColor.blackColor()
        
        self.slideShow.draggingEnabled=true
        self.slideShow.circular=false
        self.slideShow.setCurrentPageForScrollViewPage(0)
        
        self.slideShow.contentScaleMode = UIViewContentMode.ScaleAspectFill
        // self.slideShow.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.slideShow.clipsToBounds=true
        
        sdWebImageSource.append(SDWebImageSource(urlString: imageLink as String)!)
        self.slideShow.setImageInputs(sdWebImageSource )
        
        
      //  dispatch_async(dispatch_get_main_queue(), {

      //  dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {
       // sleep(uint(0.5))

            for j in 0..<multipleImages.count{
                
                let imgLink = multipleImages[j] as! String
                if imgLink == imageLink
                {
                    //Do nothing
                }
                else
                {
                    sdWebImageSource.append(SDWebImageSource(urlString: imgLink as String)!)
                }
            }
            
            self.slideShow.setImageInputs(sdWebImageSource )
            
       // })
        
        
      
        
    }
    
    
    
    
    
    
    
    //MARK:-
    //MARK:- scrolling detect for animating header view
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if scrollView == collectionViewImages || scrollView == collectionViewThumbnails {
            
        }
            
        else
        {
            if scrollView.contentOffset.y >= 150.0 {
                
                UIView.animateWithDuration(0.4, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                    self.headerView.alpha = 1
                    self.headerImageView.alpha=1
                    }, completion: nil)
                
                
            }
                
            else{
                
                UIView.animateWithDuration(0.4, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                    self.headerView.alpha = 0
                    self.headerImageView.alpha=0
                    }, completion: nil)
                
            }
            
            
        }
        
        
        
    }
    
    
    
    
    ////////////////////////////////////////////////////////////////////
    
    //MARK:-
    //MARK:-///////////// Zoom Image Pinch gesture, swipe gesture/////////////
    //MARK:-
    
    @IBAction func zoomImage(sender: UIPinchGestureRecognizer) {
        
//        self.zoomimageView.transform = CGAffineTransformScale(self.zoomimageView.transform, sender.scale, sender.scale)
//        
//       
//        print(sender.scale)
//        sender.scale = 1
        
    }
    
    /// swipe gesture to left and light ///////////
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
                        
                    }else{
                        self.changeZoomImage(indexOfZoomImg)
                    }
                    
                }
                
                
                else{
                if indexOfZoomImg < 0 {
                    
                    indexOfZoomImg = 0
                    
                }else{
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
                        
                    }else{
                         self.changeZoomImage(indexOfZoomImg)
                    }
                    
                    
                }
                    
                else{
                    
                    if indexOfZoomImg > zoomImagesArray.count - 1 {
                        
                        indexOfZoomImg = zoomImagesArray.count - 1
                        
                    }else{
                         self.changeZoomImage(indexOfZoomImg)
                    }
                }
                
                
                
                
                
               
                
                
                
            default:
                break //stops the code/codes nothing.
                
                
            }
            
        }
        
        
    }

    //Change the image in zoomed view 
    
    func changeZoomImage(index:Int) -> Void {
        
        
//        zoomScrollView.contentMode=UIViewContentMode .ScaleAspectFit
//        zoomimageView .sizeToFit()
//        zoomScrollView.contentSize=CGSizeMake(zoomimageView.frame.size.width , zoomimageView.frame.size.height)
        
        
         self.zoomimageView.transform = CGAffineTransformMakeScale(1.0,1.0 )
        if DirectionSwipe == "Right" {
            
            CATransaction.begin()
            CATransaction.setAnimationDuration(0.5)
            let transition = CATransition()
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromLeft
            
            zoomimageView.layer.addAnimation(transition, forKey: kCATransition)
            zoomimageView.layer.addAnimation(transition, forKey: kCATransition)
            
            
            

            
            
            if Thumbnails == true {
                
                let imageName = hotelImagesArray.valueForKey("normal") .objectAtIndex(indexOfZoomImg)
                let url = NSURL(string: imageName as! String)
                self.zoomIndicator.startAnimating()
                self.zoomIndicator.hidden=false
                zoomimageView.sd_setImageWithURL(url)
                
                let imageName2 = hotelImagesArray.valueForKey("original") .objectAtIndex(indexOfZoomImg)
                let url2 = NSURL(string: imageName2 as! String)
                let pImage2 = UIImageView()
                pImage2.sd_setImageWithURL(url, placeholderImage: nil)
                
                let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in
                
                    self.zoomIndicator.stopAnimating()
                    self.zoomIndicator.hidden=true
                    
                }
                
                //completion block of the sdwebimageview
                zoomimageView.sd_setImageWithURL(url2, placeholderImage: pImage2.image, completed: block)
                
            }
                
            else
            {
                var zoomImageString = NSString()
                zoomImageString = zoomImagesArray .objectAtIndex(index) as! NSString
                
                
                let url2 = NSURL(string: zoomImageString as String)
               
                
                zoomimageView.sd_setImageWithURL(url2)
                
                
                let pImage : UIImage = UIImage(named:"backgroundImage")!
                zoomIndicator.startAnimating()
                 self.zoomIndicator.hidden=false
                let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in
                    
                    self.zoomIndicator.stopAnimating()
                    self.zoomIndicator.hidden=true
                    
                }
                
                //completion block of the sdwebimageview
                zoomimageView.sd_setImageWithURL(url2, placeholderImage: pImage, completed: block)
            }

            CATransaction.commit()//moving effect of images
            
            
        }
        
        else if(DirectionSwipe == "Left"){
            
            CATransaction.begin()
            CATransaction.setAnimationDuration(0.5)
            let transition = CATransition()
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromRight
            
            zoomimageView.layer.addAnimation(transition, forKey: kCATransition)
            zoomimageView.layer.addAnimation(transition, forKey: kCATransition)

            
            
            if Thumbnails == true {
        
                let imageName = hotelImagesArray.valueForKey("normal") .objectAtIndex(indexOfZoomImg)
                let url = NSURL(string: imageName as! String)
                
                zoomimageView.sd_setImageWithURL(url)
                
                let imageName2 = hotelImagesArray.valueForKey("original") .objectAtIndex(indexOfZoomImg)
                let url2 = NSURL(string: imageName2 as! String)
                let pImage2 = UIImageView()
                pImage2.sd_setImageWithURL(url, placeholderImage: nil)
                self.zoomIndicator.startAnimating()
                self.zoomIndicator.hidden=false
                let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in
                    self.zoomIndicator.stopAnimating()
                    self.zoomIndicator.hidden=true
                }
                
                //completion block of the sdwebimageview
                zoomimageView.sd_setImageWithURL(url2, placeholderImage: pImage2.image, completed: block)
                
                
                
                
            }
                
            else
            {
                var zoomImageString = NSString()
                zoomImageString = zoomImagesArray .objectAtIndex(index) as! NSString
                
                
                let url2 = NSURL(string: zoomImageString as String)
                
                
                
                zoomimageView.sd_setImageWithURL(url2)
                
                
                let pImage : UIImage = UIImage(named:"backgroundImage")!
                 self.zoomIndicator.startAnimating()
                 self.zoomIndicator.hidden=false
                let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in
                    self.zoomIndicator.stopAnimating()
                     self.zoomIndicator.hidden=true
                }
                
                //completion block of the sdwebimageview
                zoomimageView.sd_setImageWithURL(url2, placeholderImage: pImage, completed: block)
            }
            CATransaction.commit()//moving effect of images
            
        }
        
        else
        {
            
            if Thumbnails == true
            {
                let imageName = hotelImagesArray.valueForKey("normal") .objectAtIndex(indexOfZoomImg)
                let url = NSURL(string: imageName as! String)
                
                self.zoomIndicator.startAnimating()
                self.zoomIndicator.hidden=false
                zoomimageView.sd_setImageWithURL(url)
                
                let imageName2 = hotelImagesArray.valueForKey("original") .objectAtIndex(indexOfZoomImg)
                let url2 = NSURL(string: imageName2 as! String)
                let pImage2 = UIImageView()
                pImage2.sd_setImageWithURL(url, placeholderImage: nil)
                
                let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in
                    
                    self.zoomIndicator.stopAnimating()
                    self.zoomIndicator.hidden=true
                    
                }
                
                //completion block of the sdwebimageview
                zoomimageView.sd_setImageWithURL(url2, placeholderImage: pImage2.image, completed: block)
                
            }
                
            else
            {
                var zoomImageString = NSString()
                zoomImageString = zoomImagesArray .objectAtIndex(index) as! NSString
                let url2 = NSURL(string: zoomImageString as String)
                //print(slideShow.currentSlideshowItem?.imageView.image)
                
               // zoomimageView.sd_setImageWithURL(url2)
               // let pImage : UIImage = UIImage(named:"backgroundImage")!
                 self.zoomIndicator.startAnimating()
                 self.zoomIndicator.hidden=false
                
                let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in
                    self.zoomIndicator.stopAnimating()
                    self.zoomIndicator.hidden=true
                }
                
                var slidImg:UIImage = UIImage (named: "backgroundImage")!
                
              //  print(slideShow.currentSlideshowItem?.imageView.image)
                if slideShow.currentSlideshowItem?.imageView.image==nil {
                    
                    
                }
                else{
                    slidImg = (slideShow.currentSlideshowItem?.imageView.image!)!
                }
                
                //completion block of the sdwebimageview
                zoomimageView.sd_setImageWithURL(url2, placeholderImage: slidImg, completed: block)
            }
            
        }
        
        


        
        
        
    }
    
    
    
    
    
    ////close the zoomed image view
    func closeImageView()
    {
        
        zoomView.hidden=true
        
    }
    
    
    ///////////////----- open the zoom image view
    
    
    func openZoomView() -> Void {
        
        self.zoomScrollView.minimumZoomScale = 1.0
        self.zoomScrollView.maximumZoomScale = 5.0
        
        self.zoomScrollView.zoomScale = 1.0
       // zoomScrollView.contentSize=CGSizeMake(zoomScrollView.frame.size.width + 50 , zoomScrollView.frame.size.height + 50)
        
        
        
//        self.zoomimageView.transform = CGAffineTransformMakeScale(1.0,1.0 )
        
      
        
       
        Thumbnails = false
        DirectionSwipe = "None"
        
        var multiImg = NSMutableArray()
        multiImg = self.arrayWithData[0].valueForKey("multipleImagesLarge")as! NSMutableArray
        
        
        
        zoomView.hidden=false
        self.view .bringSubviewToFront(zoomView)
       
        
        zoomIndicator.startAnimating()
         self.zoomIndicator.hidden=false
        
        var locationImageStr = ""
        
        
        
       // print(multiImg)
        //print(slideShow.currentItemIndex)
        
        
        if slideShow.currentItemIndex==0 {
            locationImageStr = multiImg.objectAtIndex(slideShow.currentItemIndex) as! String
        }
        else{
            locationImageStr = multiImg.objectAtIndex(slideShow.currentItemIndex) as! String
        }
        
        zoomImagesArray .removeAllObjects()
        zoomImagesArray .addObject(locationImageStr)
        
        indexOfZoomImg = 0
        
       
        
        
        for i in 0..<multiImg.count {
            
            let locationImageStr2 = multiImg.objectAtIndex(i) as! String
            // if zoomImagesArray .containsObject(locationImageStr2) {
            //do nothing
            // }
            // else{
            zoomImagesArray .addObject(locationImageStr2)
            // }
            
        }
        
        
        
        let copy = zoomImagesArray
        
        var index = copy.count - 1
        for object: AnyObject in (copy as NSArray).reverseObjectEnumerator() {
            if (zoomImagesArray as NSArray).indexOfObject(object, inRange: NSMakeRange(0, index)) != NSNotFound {
                zoomImagesArray.removeObjectAtIndex(index)
            }
            index -= 1
        }
        
         self.changeZoomImage(indexOfZoomImg)
         //print(zoomImagesArray)
        
        
    }
    
    
    
    
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView?
    {
        if scrollView==zoomScrollView {
            return self.zoomimageView
        }
        
        else{
            return self.view
        }
        
    }
    
    
    
    
    
    
    
    
    //////////////////////////////////////////////////////////////////////////////
    
    //MARK:- ////////Actions of buttons ////////
    //MARK:

    
    
    //MARK: Back Button Action
    @IBAction func BackAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {})
        
        
        
    
        if task1 != nil {
            
            if task1!.state == NSURLSessionTaskState.Running {
                task1!.cancel()
                print("\n\n Task 1 cancel\n\n")
            }
            
            if task2 != nil {
                
                if task2!.state == NSURLSessionTaskState.Running {
                    task2!.cancel()
                    print("\n\n Task 2 cancel\n\n")
                }
                
            }
            
            if task3 != nil {
                
                if task3!.state == NSURLSessionTaskState.Running {
                    task3!.cancel()
                    print("\n\n Task 3 cancel\n\n")
                }
                
            }
            
//            deinit{
//                
//                print("View controller is removed from memory")
//                
//            }
            self.navigationController?.popViewControllerAnimated(true)
        }
       
        
        
        
        
        
       
        
        
       // self.dismissViewControllerAnimated(true, completion: {})
        NSURLCache.sharedURLCache().removeAllCachedResponses()
        
        
    }
    
    
    
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
    
    print("enter to cancel this")
    
    
    }
    
    
    
    
    
    
   //MARK: - action of add to story
    @IBAction func addStoryAction(sender: AnyObject) {
   
        
        print(arrayWithData[0])
        
        //
        
        let imageId = self.arrayWithData[0] .valueForKey("imageId") as? String ?? ""
        let locationImageStr = self.arrayWithData[0] .valueForKey("locationImage") as? String ?? ""
        let countryName = self.arrayWithData[0] .valueForKey("CountryName") as? String ?? ""
        let imageThumbnail = self.arrayWithData[0] .valueForKey("standardImage") as? String ?? ""
        
        let tagGeo = self.arrayWithData[0] .valueForKey("geoTag") as? String ?? ""
        
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let uId = defaults .stringForKey("userLoginId")
        
        let profileImage = self.arrayWithData[0] .valueForKey("profileImage") as? NSString ?? ""
        
        
        let lat = self.arrayWithData[0] .valueForKey("latitude") as! NSNumber
        let long = self.arrayWithData[0] .valueForKey("longitude") as! NSNumber
        
        let cityName = self.arrayWithData[0] .valueForKey("cityName") as? String ?? ""
        
        let source = self.arrayWithData[0] .valueForKey("Type") as? String ?? ""
        
        
        
        if stImg.image==UIImage (named: "detailStory2") {
            stImg.image=UIImage.init(named: "detailStory")
            
            
            let dataStr = "userId=\(uId!)&imageId=\(imageId)&place=\(countryName)&cityName=\(cityName)"
            
            print(dataStr)
            
            apiClassStory.sharedInstance().postRequestDeleteStory(dataStr, viewController: self)
            
        }
            
        else
        {
            stImg.image=UIImage.init(named: "detailStory2")
            
            let dat: NSDictionary = ["userid": "\(uId!)", "id": imageId, "imageLink": locationImageStr, "location": countryName, "source":"facebook", "latitude": lat, "longitude": long, "geoTag":tagGeo, "category":self.categoryTxtv.text, "description":descriptionTextv.text, "userName":userNameTxtv.text,"type":source, "profileImage":profileImage, "cityName": cityName, "imageThumb": imageThumbnail ]
            
            var postDict = NSDictionary()
            
            postDict = dat
            
            print("Post parameters to select the images for story--- \(dat)")
            
            
            apiClass.sharedInstance().postRequestWithMultipleImage("", parameters: postDict, viewController: self)
            
          
        }
        
        
    }
   
    
    
    
    
    
    
    
    //MARK:- Like Button action
    
    @IBAction func likeBtnAction(sender: AnyObject) {
        
        
        let nxtObjMain = self.storyboard?.instantiateViewControllerWithIdentifier("mainHomeViewController") as! mainHomeViewController
        
        print(countLikes)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let uId = defaults .stringForKey("userLoginId")
        
        let otherUserId = self.arrayWithData[0] .valueForKey("otherUserId") as? String ?? ""
        let imageId = self.arrayWithData[0] .valueForKey("imageId") as? String ?? ""
        
        
        let countBack = self.arrayWithData[0].valueForKey("likeCount") as? NSNumber
        
        
        
        if countLikes.count>0 {
            if countLikes.valueForKey("imageId") .containsObject(imageId) {
                
                let index = self.countLikes.valueForKey("imageId").indexOfObject(imageId)
                
                if countLikes.objectAtIndex(index).valueForKey("like") as! Bool == true {
                    
                    let staticCount = countLikes.objectAtIndex(index).valueForKey("count") as? NSNumber
                    
                    countLikes .removeObjectAtIndex(index)
                    
                    countLikes .addObject(["userId":uId!, "imageId":imageId, "like":false, "count": nxtObjMain.subtractTheLikes(staticCount!)])
                    
                    
                    
                    
                   likeImg.image=UIImage (named: "detailLike")
                    
                    let dat: NSDictionary = ["userId": "\(otherUserId)", "photoId":"\(imageId)", "userLiked":"\(uId!)", "status":"0"]
                    print("Post to like picture---- \(dat)")
                    dispatch_async(dispatch_get_main_queue(), {
                        apiClass.sharedInstance().postRequestLikeUnlikeImage(dat, viewController: self)
                    })
                    
                }
                else
                {
                    let staticCount = countLikes.objectAtIndex(index).valueForKey("count") as? NSNumber
                   
                    
                    countLikes .removeObjectAtIndex(index)
                    countLikes .addObject(["userId":uId!, "imageId":imageId, "like":true, "count": nxtObjMain.addTheLikes(staticCount!)])
                    
                    
                 
                    
                 likeImg.image=UIImage (named: "detailLike2")
                    let dat: NSDictionary = ["userId": "\(otherUserId)", "photoId":"\(imageId)", "userLiked":"\(uId!)", "status":"1"]
                    
                    
                    print("Post to like picture---- \(dat)")
                    dispatch_async(dispatch_get_main_queue(), {
                        apiClass.sharedInstance().postRequestLikeUnlikeImage(dat, viewController: self)
                    })
                    
                }
            }
                // if not liked already
            else{
                countLikes .addObject(["userId":uId!, "imageId":imageId, "like":true, "count": nxtObjMain.addTheLikes(countBack!)])
              
                 likeImg.image=UIImage (named: "detailLike2")
                let dat: NSDictionary = ["userId": "\(otherUserId)", "photoId":"\(imageId)", "userLiked":"\(uId!)", "status":"1"]
                
                
                print("Post to like picture---- \(dat)")
                dispatch_async(dispatch_get_main_queue(), {
                    apiClass.sharedInstance().postRequestLikeUnlikeImage(dat, viewController: self)
                })
            }
            
        }
            
        else
            
        {
            
            countLikes.addObject(["userId":uId!, "count":nxtObjMain.addTheLikes(countBack!), "like": true, "imageId": imageId])
           likeImg.image=UIImage (named: "detailLike2")
            
            let dat: NSDictionary = ["userId": "\(otherUserId)", "photoId":"\(imageId)", "userLiked":"\(uId!)", "status":"1"]
            
            
            print("Post to like picture---- \(dat)")
            dispatch_async(dispatch_get_main_queue(), {
                apiClass.sharedInstance().postRequestLikeUnlikeImage(dat, viewController: self)
            })
        }

        
        
        
        
        
        if fromInterest {
        let nxtObjInterest = self.storyboard?.instantiateViewControllerWithIdentifier("intrestViewController") as! intrestViewController
            
            nxtObjInterest.likeCount = countLikes
            NSNotificationCenter.defaultCenter().postNotificationName("loadInterest", object: nil)
        }
        else
        {
        nxtObjMain.likeCount=countLikes
        
         NSNotificationCenter.defaultCenter().postNotificationName("load", object: nil)
        }
        
        
//        
//        
//            if likeImg.image == UIImage (named: "detailLike2") {
//                likeImg.image=UIImage (named: "detailLike")
//                self.callLikePostRequest("0")
//            }
//            else{
//                likeImg.image=UIImage (named: "detailLike2")
//                self.callLikePostRequest("1")
//            }
        
        
        
        
      
        
        
        
        
    }
    
    
    ////// call the api with status code for like or unlike 0 for unlike and 1 for like /////
    
    func callLikePostRequest(status: NSString) -> Void {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let uId = defaults .stringForKey("userLoginId")
        
        let otherUserId = self.arrayWithData[0] .valueForKey("otherUserId") as? String ?? ""
        let imageId = self.arrayWithData[0] .valueForKey("imageId") as? String ?? ""
        
        let dat: NSDictionary = ["userId": "\(otherUserId)", "photoId":"\(imageId)", "userLiked":"\(uId!)", "status":status]
        
        
        print("Post to like picture---- \(dat)")
        
        apiClass.sharedInstance().postRequestLikeUnlikeImage(dat, viewController: self)
        
        //reload the data in first main view controller
        
        dispatch_async(dispatch_get_main_queue(), {
            
            
            
        NSNotificationCenter.defaultCenter().postNotificationName("load", object: nil)
        })
    }
    
    
    
    
    
    
    
    
    
    //MARK:- Add to bucket list action
    
    @IBAction func addToBucketAction(sender: AnyObject) {

        
        let imageId = self.arrayWithData[0] .valueForKey("imageId") as? String ?? ""
        let locationImageStr = self.arrayWithData[0] .valueForKey("locationImage") as? String ?? ""
        let countryName = self.arrayWithData[0] .valueForKey("CountryName") as? String ?? ""
        let imageThumbnail = self.arrayWithData[0] .valueForKey("standardImage") as? String ?? ""
        
        let tagGeo = self.arrayWithData[0] .valueForKey("geoTag") as? String ?? ""
        
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let uId = defaults .stringForKey("userLoginId")
        
        let profileImage = self.arrayWithData[0] .valueForKey("profileImage") as? NSString ?? ""
        
        
        let lat = self.arrayWithData[0] .valueForKey("latitude") as! NSNumber
        let long = self.arrayWithData[0] .valueForKey("longitude") as! NSNumber
        
        let cityName = self.arrayWithData[0] .valueForKey("cityName") as? String ?? ""
        
        
        
        if bucketImg.image==UIImage (named: "detailBucket2") {
           // bucketImg.image=UIImage (named: "detailBucket")
            
            //Delete from here
            
        }
            
        else
        {
            bucketImg.image=UIImage (named: "detailBucket2")
            
            let parameterString = "city=\(cityName)&country=\(countryName)&userId=\(uId!)&imageId=\(imageId)"
            print("parameter of add t0 bucket=\(parameterString)")
            
            
            //add image to bucket
            bucketListApiClass.sharedInstance().postRequestForAddBucket(parameterString, viewController: self)
            
            
            
            
            
        }
        
        
    }
    
    
    
    
    
    
    //MARK:-
    //MARK:- Delete image Action
    
    
    @IBAction func deleteImageAction(sender: AnyObject) {
       
        
        
        
        
        
        
        // Create the alert controller
        let alertController = UIAlertController(title: "Pyt", message: "Are you sure to delete this image?", preferredStyle: .Alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            
            print("delete image tapped")
            
            
            
            let defaults = NSUserDefaults.standardUserDefaults()
            let uId = defaults .stringForKey("userLoginId")
            
            let imageUrl = self.arrayWithData[0] .valueForKey("locationImage") as! NSString
            
            let imageId = self.arrayWithData[0] .valueForKey("imageId") as? String ?? ""
            
            
            let parameterString = "userId=\(uId!)&photoId=\(imageId)&imageUrl=\(imageUrl)"
            print(parameterString)
            
            MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            apiClass.sharedInstance().postRequestDeleteImagePytFromDetail(parameterString, viewController: self)
            
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
   
    
    
    
    
    
    
    
    //MARK:-
    //MARK:- WEB Link action to open the url of the location on safari
    
    @IBAction func webLinkAction(sender: AnyObject) {
        
        print(webLinkString)
        
        UIApplication.sharedApplication().openURL(NSURL(string: webLinkString as String)!)
        
    }
    
    
    
    
    
    
    
    //MARK: Show whole description on the next page
    
    @IBAction func showDescriptionAction(sender: AnyObject)
    {
        let nxtObj2 = self.storyboard?.instantiateViewControllerWithIdentifier("DescriptionViewViewController") as? DescriptionViewViewController
        nxtObj2!.descriptionString2=self.descriptionString
        nxtObj2!.title=locationTxtv.text
        
        self.navigationController! .pushViewController(nxtObj2!, animated: true)
        
        
    }
    
    
    
    
    //MARK: Show all comments on the new screen
    
    @IBAction func showCommentsAction(sender: AnyObject)
    {
        let nxtObj2 = self.storyboard?.instantiateViewControllerWithIdentifier("commentsViewController") as? commentsViewController
        nxtObj2!.commentsArray=self.reviewsArray
        
        
        self.navigationController! .pushViewController(nxtObj2!, animated: true)
        
    }
    
    
    
    
    
    
    ///////////////////////////////////////////////////////////////////////////////////
    
    //MARK:- Delegates and datasource of tableView
    //MARK:-
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if reviewsArray.count>0 {
            return 1
        }
        else{
        return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("CommentsCell")!
        
        let imageName2 = reviewsArray.objectAtIndex(indexPath.row).valueForKey("userPhoto") as? String ?? ""
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
        userCommentLabel.textContainerInset = UIEdgeInsetsMake(0, -3, 0, 0)
        
        
        
        let commentTimeLabel = cell.contentView .viewWithTag(114) as! UILabel
        commentTimeLabel.text = ""
        
        return cell
        
    }
    
    
    
    
    
    
    
    //MARK:- CollectionView Data source and delegates
    //MARK:-
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    
    
    
    func collectionView(collectionView: UICollectionView,numberOfItemsInSection section: Int) -> Int
    {
        if collectionView == collectionViewThumbnails
        {
            return hotelImagesArray.count
        }
        else
        {
            return nearByPlacesArray.count
        }
    }
    
    
    
    func collectionView(collectionView: UICollectionView,cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        //Location Images collectionview
        if collectionView == collectionViewThumbnails
        {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cellImages",forIndexPath: indexPath)
            
            let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
            cell.backgroundView = activityIndicatorView
            //self.view.bringSubviewToFront(cell.backgroundView!)
            activityIndicatorView.startAnimating()

            
            
            let locationimage2 = cell.viewWithTag(11111) as! UIImageView
            let imageName2 = hotelImagesArray.valueForKey("normal") .objectAtIndex(indexPath.row)
            let url2 = NSURL(string: imageName2 as! String)
            let pImage : UIImage = UIImage(named:"backgroundImage")!
            
            
            let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in
                
                activityIndicatorView .removeFromSuperview()
            }
            
            //completion block of the sdwebimageview
            locationimage2.contentMode = .ScaleAspectFill
            locationimage2.sd_setImageWithURL(url2, placeholderImage: pImage, completed: block)
            locationimage2.layer.cornerRadius=5
            locationimage2.clipsToBounds=true
            
            
            
            
            
            
            
            
            cell.backgroundColor=UIColor .clearColor()
            cell.layer.shadowColor = UIColor .lightGrayColor() .CGColor
            cell.layer.shadowOffset = CGSizeMake(0, 2.5)
            cell.layer.shadowOpacity = 1
            cell.layer.shadowRadius = 1.0
            cell.layer.masksToBounds=true
            cell.layer.cornerRadius=5
            
            
            return cell
        }
            
         
            
        //Near by places collection view
            
        else
        {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("imagesCell",forIndexPath: indexPath)
            
            let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
            cell.backgroundView = activityIndicatorView
            //self.view.bringSubviewToFront(cell.backgroundView!)
            activityIndicatorView.startAnimating()
            
            
            let nearByimage = cell.viewWithTag(11112) as! UIImageView
            let imageName2 = nearByPlacesArray.valueForKey("images") .objectAtIndex(indexPath.row)
            let url2 = NSURL(string: imageName2 as! String)
            let pImage : UIImage = UIImage(named:"backgroundImage")!
            
            let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in
                activityIndicatorView.stopAnimating()
                activityIndicatorView.removeFromSuperview()
            }
            //completion block of the sdwebimageview
            
            nearByimage.sd_setImageWithURL(url2, placeholderImage: pImage, completed: block)
            nearByimage.layer.cornerRadius=5
            nearByimage.clipsToBounds=true
            
            
            
            
            
            
            cell.backgroundColor=UIColor .clearColor()
            //cell.layer.shadowColor = UIColor .lightGrayColor() .CGColor
           // cell.layer.shadowOffset = CGSizeMake(0, 2)
            //cell.layer.shadowOpacity = 1
            //cell.layer.shadowRadius = 1.0
            
            
            
            
            //label for near by places name
            let labelName = cell.viewWithTag(11113) as! UILabel
            labelName.adjustsFontSizeToFitWidth = true
            labelName.numberOfLines=0
            labelName.text=nearByPlacesArray.objectAtIndex(indexPath.row).valueForKey("name") as? String
            
            
            return cell
            
        }
    }
    
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        if collectionView == collectionViewThumbnails
        {
            
            self.zoomScrollView.minimumZoomScale = 1.0
            self.zoomScrollView.maximumZoomScale = 5.0
            
            self.zoomScrollView.zoomScale = 1.0
            
            Thumbnails = true
              self.zoomimageView.transform = CGAffineTransformMakeScale(1.0,1.0 )
            DirectionSwipe = "None"
            zoomView.hidden=false
            indexOfZoomImg=indexPath.row
            
            
            self.view .bringSubviewToFront(zoomView)
          zoomIndicator.startAnimating()
            zoomIndicator.hidden=false
            
            
            
            
            self.changeZoomImage(indexOfZoomImg)
            
            
        }
            
            
        ////////----- near by places
            
        else
        {
            let nxtObj2 = self.storyboard?.instantiateViewControllerWithIdentifier("nearByViewController") as? nearByViewController
            
            let detail = self.nearByPlacesArray.objectAtIndex(indexPath.row)
          //  print(detail)
            
            nxtObj2!.newDetail = detail as! NSDictionary
            
            self.navigationController! .pushViewController(nxtObj2!, animated: true)

        }
        
    }
    
    
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        
        if collectionView == collectionViewImages {
            
            
            let width1 = collectionView.frame.size.width/3.50  //1.8
            //  let height2 = collectionView.frame.size.height - 10
            
            let perCent = 8000/width1
            
            let height3: CGFloat = perCent + 38 //width1-perCent
            
            return CGSize(width: width1, height: 95) // The size of one cell
            
        }
            
        else
        {
            let width1 = collectionView.frame.size.width/3.50  //1.8
            //  let height2 = collectionView.frame.size.height - 10
            
           
            
            return CGSize(width: width1, height: 75.0) // The size of one cell
        }
    }
    
    
    
    
    
    
    
    
    ////////////////////////////////////////////////////////////////////////////////
    
    //MARK:- Get detail from foursquare api
    //MARK:-
    
    
    func datafromFoursquare(parameterStringHotels : String)
    {
        //ttp://terminal2.expedia.com:80/x/nlp/results?q=jw%20marriot%20in%20chandigharh&apikey=4PKZ0dIDVwXoTQoPeac9F8681XRwgpyA
        
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
            
            
            
            let urlString = NSString(string:"\(parameterStringHotels)")
            print("WS URL----->>" + (urlString as String))
            
            //urlString = urlString .stringByReplacingOccurrencesOfString(" ", withString: "%20")
            
            
            let finalStr = urlString
            let safeURL = finalStr.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
            
            let url:NSURL = NSURL(string: safeURL as String)!
            print("Final Url-----> " + (safeURL as String))
            
            let session = NSURLSession.sharedSession()
            
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "GET"
            request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
             task1 = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
                
                NSOperationQueue.mainQueue().addOperationWithBlock
                    {
                         print("data from foursquare ")
                        
                        self.firstIndicator .removeFromSuperview()
                        self.secondIndicator .removeFromSuperview()
                        
                        if data == nil
                        {
                          
                           // CommonFunctionsClass.sharedInstance().alertViewOpen("Server is not responding", viewController: self)
                            
                        }
                        else
                        {
                           
                            self.descriptionTextv.editable=true
                            self.heightOfSecondView.constant = 0
                            self.webLinkBtnOutlet.hidden=true
                            self.showMoreDescription.hidden=true
                            
                            
                            
                            let result = NSString(data: data!, encoding:NSASCIIStringEncoding)!
                            
                            
                            
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
                                    
                                    
                                    var hotelname = self.arrayWithData[0] .valueForKey("geoTag") as! String
                                    if hotelname == ""{
                                     hotelname = self.arrayWithData[0].valueForKey("cityName") as! String
                                   if hotelname == ""{
                                     hotelname = self.arrayWithData[0].valueForKey("CountryName") as! String
                                        }
                                        
                                    
                                    }
                                    
                                    /*
                                    self.locationTxtv.editable=true
                                    self.locationTxtv.scrollEnabled=false
                                    
                                    self.locationTxtv.text=hotelname
                                    self.locationTxtv.font=UIFont(name: "Roboto-Light", size: 15)!
                                    self.locationTxtv.textColor = UIColor .lightGrayColor()
                                    self.locationTxtv.textAlignment=NSTextAlignment .Right
                                    print(self.locationTxtv.frame)
                                   // let fixedWidth = self.locationTxtv.frame.size.width
                                    
                                    //let newSize = self.locationTxtv.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
                                   // var newFrame = self.locationTxtv.frame
                                   // newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
                                    //self.locationTxtv.frame = newFrame
                                    
                                    
                                    // self.locationTxtv.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
                                    self.locationTxtv.editable=false
                                   // print(self.locationTxtv.frame)
                                    
                                    
                                    
                                    
                                    
                                
                                    
//                                    
//                                    var type = self.arrayWithData[0] .valueForKey("Category") as? String ?? " "
//                                    
//                                    //// temporary change the category random to Others
//                                    let newCatRr: NSArray = type .componentsSeparatedByString(",")
//                                    
//                                    let  newcat2 = NSMutableArray()
//                                    
//                                    for ll in 0..<newCatRr.count {
//                                        
//                                        var stCat = newCatRr.objectAtIndex(ll) as? String ?? ""
//                                        print(stCat)
//                                        
//                                        if stCat == "Random" || stCat == "random" {
//                                            stCat = "Others"
//                                        }
//                                        newcat2 .addObject(stCat)
//                                    }
//                                    
//                                    
//                                    type = newcat2.componentsJoinedByString(",")
//                                    
//                                    
//                                    
//                                    
//                                    self.categoryTxtv.editable=true
//                                    self.categoryTxtv.text = type //?.componentsJoinedByString(",")  //categoryString as String
//                                    self.categoryTxtv.textColor = UIColor .blackColor() //(red:19/255.0, green:201/255.0, blue:195/255.0, alpha: 1.0)
//                                    self.categoryTxtv.font=UIFont(name: "Roboto-Medium", size: 14)!
//                                    self.categoryTxtv.textAlignment = NSTextAlignment.Left
//                                    self.categoryTxtv.clipsToBounds=true
//                                    
//                                 
//                                    self.categoryTxtv.editable=false
                                    
                                    */
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    //self.updateFirstView()
                                    
                                    
                                   // self.topspaceOfThumbnailCollectionView.constant = -9
                                    self.collectionHeightThumbnails.constant=0
                                    self.collectionContainView.constant=0
                                    self.morePictureLabel.hidden=true
                                    
                                    
                                   //No Venue found
                                    
                                    let NearLoc = "\(self.arrayWithData[0] .valueForKey("Venue") as! NSString),\(self.arrayWithData[0] .valueForKey("CountryName") as! NSString)"
                                    
                                    //self .nearByPlaces(NearLoc)
                                    self .nearByPlaces("\(String(self.LAT))", long: "\(String(self.LONG))", radius: "100")
                                    
                                    
                                    
                                    let descStRing = self.arrayWithData[0] .valueForKey("Description") as? String ?? ""
//                                    if descStRing == ""
//                                    {
//                                        
//                                    }
//                                    else
//                                    {
                                    
                                        self.descriptionString=descStRing
                                        self.descriptionTextv.editable=true
                                        //self.descriptionTextv.text=self.locationTxtv.text //self.descriptionString as String
                                        self.descriptionTextv.font=UIFont(name: "Roboto-Bold", size: 12)!
                                        self.descriptionTextv.textColor = UIColor .lightGrayColor() //UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1.0)
                                        
                                        //self.descriptionTextv.frame.size.height=55
                                        self.descriptionTextv.editable=false
                                        self.heightOfSecondView.constant = self.heightDescription(descStRing) //130
                                        self.showMoreDescription.hidden=true
                                        if self.descriptionString.length>250{
                                            self.heightOfSecondView.constant = 200
                                            self.showMoreDescription.userInteractionEnabled=true
                                            self.showMoreDescription.hidden=false
                                        }
                                        
                                   // }

                                    
                                    
                                    
                                    
                                    
                                    
                                }
                                else
                                {
                                    
                                    
                                    print(venues[0].valueForKey("location"))
                                let locationDict: NSDictionary = venues[0].valueForKey("location") as! NSDictionary
                                    
                                    let latFS = locationDict["lat"] != nil
                                
                                    let longFS = locationDict["lng"] != nil
                                
                                    
                                    if latFS == true && longFS == true {
                                        
                                        if self.LAT == 0{
                                            print("Latitude is 0")
                                            let locLat = locationDict["lat"] as! NSNumber
                                            let locLong = locationDict["lat"] as! NSNumber
                                            
                                            self.LAT = locLat
                                            self.LONG = locLong
                                            
                                        }
                                        
                                        
                                        
                                    }
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    if let venueId = venues[0].valueForKey("id"){
                                        
                                    
                                            
                                            self .getPhotosOfHotel(venueId as! String)
                                            
                                        
                                    }
                                    else{
                                        
                                        let NearLoc = "\(self.arrayWithData[0] .valueForKey("Venue") as! NSString),\(self.arrayWithData[0] .valueForKey("CountryName") as! NSString)"
                                        
                                        //self .nearByPlaces(NearLoc)
                                        self .nearByPlaces("\(String(self.LAT))", long: "\(String(self.LONG))", radius: "100")
                                    }
                                    
                                    
                                    
                                    var hotelname = self.arrayWithData[0] .valueForKey("geoTag") as! String
                                    if hotelname == ""{
                                        hotelname = self.arrayWithData[0].valueForKey("cityName") as! String
                                        if hotelname == ""{
                                            hotelname = self.arrayWithData[0].valueForKey("CountryName") as! String
                                            
                                            if hotelname == "" {
                                            hotelname = venues[0].valueForKey("name") as? String ?? ""
                                                
                                            }
                                            
                                            
                                        }
                                        
                                        
                                        
                                    }
                                    
                                    
                                    self.locationTxtv.editable=true
                                    self.locationTxtv.scrollEnabled=false
                                    
                                    self.locationTxtv.text=hotelname
                                    self.locationTxtv.font=UIFont(name: "Roboto-Light", size: 15)!
                                    self.locationTxtv.textColor = UIColor .lightGrayColor()
                                    self.locationTxtv.textAlignment=NSTextAlignment .Right
                                    print(self.locationTxtv.frame)
                                    
                                    self.locationTxtv.editable=false
                                    
                                    
                                    
                                    
//                                    let hotelname = venues[0].valueForKey("name") as? String ?? "NA"
                                    
                                   // print(self.locationTxtv.frame)
                                   // let fixedWidth = self.locationTxtv.frame.size.width
                                    
                                    //let newSize = self.locationTxtv.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
                                   // var newFrame = self.locationTxtv.frame
                                   // newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
                                  //  self.locationTxtv.frame = newFrame
                                    
                                    
                                   // self.locationTxtv.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    //print(self.locationTxtv.frame)
                                   //self.locationTxtv.updateConstraints()
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
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
                                  //  print(venues[0].valueForKey("location"))
                                    
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
                                        
                                        if let categ = venues[0].objectForKey("Category")?.objectAtIndex(0) .valueForKey("name")
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
                                        self.webLinkBtnOutlet.hidden=false
                                        
                                        self.webLinkString=urlHotel as! String
                                        
                                    }
                                    
                                    
                                    
                                    
                                    if phoneString==""{
                                        phoneString = "NA"
                                    }
                                    
                                }
                                
                            }
                            else
                            {
                               // self.topspaceOfThumbnailCollectionView.constant = -9
                                self.collectionHeightThumbnails.constant=0
                                self.collectionContainView.constant=0
                                self.morePictureLabel.hidden=true
                                self.showMoreDescription.hidden=false
                                self.showMoreDescription.userInteractionEnabled=true
                                let NearLoc = "\(self.arrayWithData[0] .valueForKey("Venue") as! NSString),\(self.arrayWithData[0] .valueForKey("CountryName") as! NSString)"
                                //self .nearByPlaces(NearLoc)
                                self .nearByPlaces("\(String(self.LAT))", long: "\(String(self.LONG))", radius: "100")
                            }
                            
                            
                          //  self.updateFirstView()
                            
                            
                        }
                }
                
            })
            
            task1!.resume()
        }
        else
        {
            CommonFunctionsClass.sharedInstance().alertViewOpen("Please Check Internet Connection", viewController: self)
        }
        
        
        
        
        
        if self.arrayWithData[0].valueForKey("Type") as! String == "PYT"
        {
        
            let combinePhoto = self.arrayWithData[0].valueForKey("profileImage") as? String ?? ""
            let combineName = self.arrayWithData[0].valueForKey("userName") as? String ?? ""
           let descriptionAsComment = self.arrayWithData[0].valueForKey("Description") as? String ?? ""
            
            if descriptionAsComment == "" || descriptionAsComment == "Enter description here.." {
                
            }
            else{
                self.reviewsArray .addObject(["userPhoto": combinePhoto, "userName": combineName, "comment": descriptionAsComment])
                self.heightOfTableView.constant=self.detailTable.rowHeight
                self.showMoreComments.hidden = true
                self.heightOfThirdView.constant=self.heightOfTableView.constant + 100
            }
            
            
        }
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    //MARK:- Update the first view when got data from the api//
    func updateFirstView() -> Void {
        
        
       // dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {
         // dispatch_async(dispatch_get_main_queue(), {
        
        print("Location Height------\(self.locationTxtv.frame.size.height)")
        print(self.collectionHeightThumbnails.constant)
        
         self.categoryViewHeight.constant = 120
      //  self.topspaceOfThumbnailCollectionView.constant = -9
        if self.locationTxtv.frame.size.height > self.profilePicImage.frame.size.height
        {
            
             print(self.categoryViewHeight.constant)
            
            
            
            //self.categoryViewHeight.constant = 55 + self.locationTxtv.frame.size.height
            
            
            print(self.categoryViewHeight.constant)
            
            //self.locationTxtv.frame.size.height
           
            //
            
            print("First time height===========")
            
        }
        else
        {
           // self.heightOfFirstView.constant = 240 + self.collectionHeightThumbnails.constant + self.categoryViewHeight.constant
            print("Second time height===========")
        }
        
        print(self.heightOfFirstView.constant)
        
       // })
        
        

        
        
        
    }
    
    
    
    
    
    ////////////////////////////////////////////////////////////////////////////////////
    
    
    
    //MARK: Mange description height
    func heightDescription(string: NSString) -> CGFloat {
        
        let fixedWidth = self.descriptionTextv.frame.size.width
        
        let newSize = self.descriptionTextv.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
        var newFrame = self.descriptionTextv.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        
        if string == "" {
            return 0
        }
        else{
        return newFrame.height + 100
        }
    }
    
    
    
    //MARK:- Get the images from the four square api of the hotels
    //MARK:-
    
    func getPhotosOfHotel(idString:NSString) -> Void {
        
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
            
           
            var urlString = NSString(string:"https://api.foursquare.com/v2/venues/\(idString)?client_id=DAKFO3TURLDTUL33JNPRTIGX03NMZM2ACCDWC2HHHZTV2YMT&client_secret=ILF0G3U4DRSC0WDW2EH12SFGTOKIWSKFUIOXV4FFEQOIB34B&v=20140203")
            
            
            
            let needsLove = urlString
            let safeURL = needsLove.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
            
            let url:NSURL = NSURL(string: safeURL as String)!
            print("Final Url-----> " + (safeURL as String))
            
            let session = NSURLSession.sharedSession()
            
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "GET"
            request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
            task2 = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
                
                NSOperationQueue.mainQueue().addOperationWithBlock
                    {
                        let NearLoc = "\(self.arrayWithData[0] .valueForKey("Venue") as! NSString),\(self.arrayWithData[0] .valueForKey("CountryName") as! NSString)"
                       
                       // self .nearByPlaces(NearLoc)
                         self .nearByPlaces("\(String(self.LAT))", long: "\(String(self.LONG))", radius: "100")
                        
                        
                        
                        
                        print("Photos from foursquare ")
                        
                        indicatorClass.sharedInstance().hideIndicator()
                        self.firstIndicator.removeFromSuperview()
                        if data == nil
                        {
                            indicatorClass.sharedInstance().hideIndicator()
                            //CommonFunctionsClass.sharedInstance().alertViewOpen("Server is not responding", viewController: self)
                            self.firstIndicator.removeFromSuperview()
                        }
                        else
                        {
                            
                           // let result = NSString(data: data!, encoding:NSASCIIStringEncoding)!
                            
                           // dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {
                            
                            let jsonResult: AnyObject = try! NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.MutableContainers)
                            
                            var resultHotels = NSDictionary()
                            resultHotels = jsonResult as! NSDictionary
                            
                            
                            
                            var hotelDetail = NSDictionary()
                            hotelDetail = resultHotels.valueForKey("response") as! NSDictionary
                            
                            
                            let totalElements = hotelDetail.allKeys.count
                            if totalElements >= 1{
                                
                                
                                
                                
                                let  venues = hotelDetail.valueForKey("venue") as! NSMutableDictionary
                                
                                self.descriptionTextv.text=""
                                
                                
                                
                                let descStRing = self.arrayWithData[0] .valueForKey("Description") as? String ?? ""
                                
                               // if descStRing == ""
                               // {
                                    
                                    if let desc =  venues.valueForKey("description")
                                    {
                                        self.descriptionString=desc as! NSString
                                        self.descriptionTextv.editable=true
                                        self.descriptionTextv.text=self.descriptionString as String
                                        self.descriptionTextv.font=UIFont(name: "Roboto-Bold", size: 12)!
                                        self.descriptionTextv.textColor = UIColor .lightGrayColor() //UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1.0)
                                        self.descriptionTextv.editable=false
                                        self.heightOfSecondView.constant = 195
                                        
                                        
                                        self.secondView.hidden=false
                                        self.view .setNeedsLayout()
                                        
                                        self.showMoreDescription.hidden=true
                                        if self.descriptionString.length>250{
                                            
                                            self.showMoreDescription.userInteractionEnabled=true
                                            self.showMoreDescription.hidden=false
                                        }
                                        
                                        
                                    }
                                    else
                                    {
                                        //self.descriptionString=self.locationTxtv.text
                                        self.descriptionTextv.editable=true
                                        self.descriptionTextv.text=self.descriptionString as? String ?? ""
                                        self.descriptionTextv.font=UIFont(name: "Roboto-Bold", size: 12)!
                                        self.descriptionTextv.textColor = UIColor .lightGrayColor() //UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1.0)
                                        
                                       // self.descriptionTextv.frame.size.height=55
                                        self.descriptionTextv.editable=false
                                        self.heightOfSecondView.constant = self.heightDescription("") //130
                                        self.showMoreDescription.hidden=true
                                        
                                    }
                                    
                                    
                                    
                               
                                
                               
                                
                                
                                
                                
                                
                                
                                if venues.valueForKey("photos")!.valueForKey("count") as! Int == 0 {
                                    
                                    
                                    self.collectionHeightThumbnails.constant=0
                                    self.collectionContainView.constant=0
                                    self.morePictureLabel.hidden=true
                                    //self.topspaceOfThumbnailCollectionView.constant = -9
                                    
                                }
                                else
                                {
                                    //self.topspaceOfThumbnailCollectionView.constant = -9
                                    self.collectionHeightThumbnails.constant=80
//                                    let photos = venues .valueForKey("photos")! .valueForKey("groups")![0] .valueForKey("items") as? NSMutableArray

                                    let photos = venues .valueForKey("photos")! .objectForKey("groups")?.objectAtIndex(0).valueForKey("items") as? NSMutableArray
                                    
                                    self.collectionContainView.constant=120
                                    self.morePictureLabel.hidden=false
                                    
                                    
                                    
                                    
                                   
                                        
                                        
                                        for l in 0..<photos!.count
                                        {
                                            let str1 = photos![l].valueForKey("prefix") as? String ?? ""
                                            let str2 = photos![l].valueForKey("suffix") as? String ?? ""
                                            
                                            let combinedString = "\(str1)200x200\(str2)"
                                            let combinedString2 = "\(str1)original\(str2)"
                                            
                                            
                                            self.hotelImagesArray .addObject(["normal": combinedString, "original": combinedString2])
                                        }
                                    
                                    
                                    
                                        self.collectionViewThumbnails .reloadData()
                                        
                                        
                                
                                    
                                    
                                    
                                }
                                
                                self.heightOfFirstView.constant = 330 //240 +
                                
                                
                                
                                ////----- Get reviews
                                if venues.valueForKey("tips")!.valueForKey("count") as! Int == 0 {
                                    
                                    self.detailTable.rowHeight=0
                                    
                                    
                                    
                                }
                                    
                                else
                                {
                                    var itemsArray = NSMutableArray()
                                    
                                    itemsArray = venues.valueForKey("tips")!.valueForKey("groups")?.objectAtIndex(0) .valueForKey("items") as! NSMutableArray
                                    
                                    
                                    for j in 0..<itemsArray.count{
                                        
                                        
                                        let text = itemsArray.objectAtIndex(j).valueForKey("text") as! String
                                        
                                        
                                        let prefix = itemsArray.objectAtIndex(j) .valueForKey("user")?.valueForKey("photo")?.valueForKey("prefix") as? String ?? ""
                                        
                                        
                                        let suffix = itemsArray.objectAtIndex(j) .valueForKey("user")?.valueForKey("photo")?.valueForKey("suffix") as? String ?? ""
                                        
                                        let combinePhoto = "\(prefix)300x300\(suffix)"
                                        
                                        
                                        
                                        
                                        let firstName = itemsArray.objectAtIndex(j) .valueForKey("user")? .valueForKey("firstName") as? String ?? ""
                                        
                                        
                                        let lastName = itemsArray.objectAtIndex(j) .valueForKey("user")? .valueForKey("lastName") as? String ?? ""
                                        
                                        
                                        let combineName = "\(firstName) \(lastName)"
                                        
                                        
                                        self.reviewsArray .addObject(["userPhoto": combinePhoto, "userName": combineName, "comment": text])
                                        
                                        
                                        
                                    }
                                    
                                    
                                 
                                }
                                
                                
                                
                                
                                
                            }
                            
                            
                            self.firstIndicator .removeFromSuperview()
                            self.secondIndicator.removeFromSuperview()
                            
                           // self.detailTable.estimatedRowHeight = 80.0
                            self.detailTable.rowHeight = 100 //UITableViewAutomaticDimension
                            self.detailTable.reloadData()
                            self.showMoreComments.hidden=false//show if more than 2
                            self.heightOfTableView.constant=self.detailTable.rowHeight
                           
          /// Manage the height of reviews View here
                            
                            
                            self.heightOfThirdView.constant = 100
                            if self.reviewsArray.count==1
                            {
                                
                                self.heightOfTableView.constant=self.detailTable.rowHeight
                                self.showMoreComments.hidden = true
                            self.heightOfThirdView.constant=self.heightOfTableView.constant + 100
                            
                            }
                            else if self.reviewsArray.count<1{
                                self.heightOfThirdView.constant = 100
                                self.showMoreComments.hidden = true
                            }
                            else if self.reviewsArray.count>1{
                                
                                self.heightOfTableView.constant=self.detailTable.rowHeight * 1
                                self.showMoreComments.hidden = false
                                 self.heightOfThirdView.constant=self.heightOfTableView.constant + 100

                            }
                            
                            
                            
                            
                            
                        
                        
                            
                            
                        }
               
                        
                }
               

                
                
                
                
            })
            
            task2!.resume()
        }
        else
        {
            CommonFunctionsClass.sharedInstance().alertViewOpen("Please Check Internet Connection", viewController: self)
        }
        
        
        
    }
    
   
    
    
    
    
    
    
    
    
    
    
    /////////////////////////////////////////////////////////////////////
    
    
    //MARK:- Near by places from foursquare api
    //MARK:-
    
    
//    func nearByPlaces(placeName:NSString) -> Void
//    {

    func nearByPlaces(lat:NSString, long: NSString, radius: NSString) -> Void
    {
    
       
        
       let placeName:NSString = arrayWithData[0] .valueForKey("Venue") as! NSString
        
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
            
            
            let urlString = NSString(string:"https://api.foursquare.com/v2/venues/explore/?ll=\(lat as String),\(long as String)&venuePhotos=1&radius=\(radius as String)&client_id=DAKFO3TURLDTUL33JNPRTIGX03NMZM2ACCDWC2HHHZTV2YMT&client_secret=ILF0G3U4DRSC0WDW2EH12SFGTOKIWSKFUIOXV4FFEQOIB34B&v=20140203")
            
           
            //Older Url
//            let urlString = NSString(string:"https://api.foursquare.com/v2/venues/explore/?near=\(placeName)&venuePhotos=1&client_id=DAKFO3TURLDTUL33JNPRTIGX03NMZM2ACCDWC2HHHZTV2YMT&client_secret=ILF0G3U4DRSC0WDW2EH12SFGTOKIWSKFUIOXV4FFEQOIB34B&v=20140203")
            
            
            let needsLove = urlString
            let safeURL = needsLove.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
            
            let url:NSURL = NSURL(string: safeURL as String)!
            print("Final Url-----> " + (safeURL as String))
            
            let session = NSURLSession.sharedSession()
            
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "GET"
            request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
            task3 = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
                
                NSOperationQueue.mainQueue().addOperationWithBlock
                    {
                        
                        print("Near by ")
                        
                        indicatorClass.sharedInstance().hideIndicator()
                        self.forthIndicator .removeFromSuperview()
                        if data == nil
                        {
                            indicatorClass.sharedInstance().hideIndicator()
                           // CommonFunctionsClass.sharedInstance().alertViewOpen("Server is not responding", viewController: self)
                            self.forthIndicator .removeFromSuperview()
                        }
                        else
                        {
                            
                            //dispatch_async(dispatch_get_main_queue(), {
                                
                            
                            let result = NSString(data: data!, encoding:NSASCIIStringEncoding)!
                            
                            
                            let jsonResult: AnyObject = try! NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.MutableContainers)
                            
                            var resultHotels = NSDictionary()
                            resultHotels = jsonResult as! NSDictionary
                            
                            var groupsArray = NSMutableArray()
                            
                            if let res = resultHotels.valueForKey("response")!.valueForKey("groups") as? NSMutableArray {
                                print("comes here")
                                groupsArray = resultHotels.valueForKey("response")!.valueForKey("groups") as! NSMutableArray
                                if groupsArray.count>0{
                                    
                                    var itemsArray = NSMutableArray()
                                    itemsArray = groupsArray .objectAtIndex(0).valueForKey("items") as! NSMutableArray
                                    
                                    for i in 0..<itemsArray.count{
                                        
                                        
                                        if (itemsArray.objectAtIndex(i).valueForKey("venue")?.valueForKey("photos")?.valueForKey("count"))! as! NSObject == 0{
                                            
                                            print("Entered if empty")
                                            
                                        }
                                        else
                                        {
                                            let nameOfVenue = itemsArray.objectAtIndex(i).valueForKey("venue")?.valueForKey("name") as! String
                                            
                                            
                                            let address = itemsArray.objectAtIndex(i).valueForKey("venue")?.valueForKey("location")?.valueForKey("formattedAddress")
                                            
                                            
                                            let prefix = itemsArray.objectAtIndex(i).valueForKey("venue")?.valueForKey("photos")?.valueForKey("groups")?.objectAtIndex(0).valueForKey("items")?.objectAtIndex(0) .valueForKey("prefix") as? String ?? ""
                                            
                                            
                                            
                                            let suffix = itemsArray.objectAtIndex(i).valueForKey("venue")?.valueForKey("photos")?.valueForKey("groups")?.objectAtIndex(0).valueForKey("items")?.objectAtIndex(0) .valueForKey("suffix") as? String ?? ""
                                            
                                            
                                            let combineString = "\(prefix)400x400\(suffix)"
                                            
                                            let pictureId = itemsArray.objectAtIndex(i).valueForKey("venue")?.valueForKey("photos")?.valueForKey("groups")?.objectAtIndex(0).valueForKey("items")?.objectAtIndex(0) .valueForKey("id") as? String ?? ""
                                            
                                            
                                            
                                            self.nearByPlacesArray .addObject(["images": combineString, "name":nameOfVenue, "placeName": placeName, "imageId": pictureId])
                                        }
                                        
                                    }
                                    
                                    
                                    
                                    
                                    if self.nearByPlacesArray.count<1{
                                        
                                        if radius == "100"
                                        {
                                             self .nearByPlaces("\(String(self.LAT))", long: "\(String(self.LONG))", radius: "1000")
                                        }
                                        else
                                        {
                                            self.forthIndicator .removeFromSuperview()
                                            self.collectionViewImages.reloadData()
                                            
                                            
                                            self.updateFirstView()
                                            
                                            self.contentViewHeight.constant = 210 + self.heightOfFirstView.constant + self.heightOfSecondView.constant + self.heightOfThirdView.constant + self.collectionContainView.constant
                                            self.view .setNeedsLayout()
                                            self.view .layoutIfNeeded()
                                        }
                                        
                                        
                                    }
                                    else{
                                        self.forthIndicator .removeFromSuperview()
                                        self.collectionViewImages.reloadData()
                                        
                                        
                                        self.updateFirstView()
                                        
                                        self.contentViewHeight.constant = 210 + self.heightOfFirstView.constant + self.heightOfSecondView.constant + self.heightOfThirdView.constant + self.collectionContainView.constant
                                        self.view .setNeedsLayout()
                                        self.view .layoutIfNeeded()
                                    }
                                    
                                    
                                    
                                    
                                    
                                }
                                else{
                                    
                                    self.updateFirstView()
                                    
                                    self.contentViewHeight.constant = 210 + self.heightOfFirstView.constant + self.heightOfSecondView.constant + self.heightOfThirdView.constant + self.collectionContainView.constant
                                    self.view .setNeedsLayout()
                                    self.view .layoutIfNeeded()
                                    
                                    
                                }
                                
                                
                                
                                
                            }
                            else
                            {
                                
                                self.updateFirstView()
                                
                                self.contentViewHeight.constant = 0 + self.heightOfFirstView.constant + self.heightOfSecondView.constant + self.heightOfThirdView.constant + self.collectionContainView.constant
                                
                                self.view .setNeedsLayout()
                                self.view .layoutIfNeeded()

                                
                                
                            }
                            
                        
                       // })
                        }
                }
                
            })
            
            task3!.resume()
        }
        else
        {
            CommonFunctionsClass.sharedInstance().alertViewOpen("Please Check Internet Connection", viewController: self)
            forthIndicator .removeFromSuperview()
        }
        
        
    }
    
    
    
    
    
    
    /////////////////////////////////////////////////////////////////////////////////////
    
    //MARK:- ///////// Response from the storyApi /////////
    //MARK:-
    
    func serverResponseArrived(Response:AnyObject)
    {
        
        
        //////////---------- REsponse for the add and delete image in story-----------////////
        
      
            
            jsonResult = NSDictionary()
            jsonResult = Response as! NSDictionary
            
            let success = jsonResult.objectForKey("status") as! NSNumber
            
            if success != 1{
                
                CommonFunctionsClass.sharedInstance().alertViewOpen("Sorry image is not added to story, Please try again", viewController: self)
            }
            
            
        
            
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    /*
     //MARK:- Get Reviews of hotel from expedia
     func getExpediaReviews(hotelId:NSString) -> Void
     
     {
     
     
     let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
     
     if isConnectedInternet
     {
     self.forthIndicator .startAnimating()
     
     
     
     let urlString = NSString(string:"http://terminal2.expedia.com/x/reviews/hotels?hotelId=\(hotelId)&apikey=j1HSvBLIZwndOcC6NmcTzbVnKJsYKLLb")
     
     
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
     self.forthIndicator .removeFromSuperview()
     }
     else
     {
     
     let result = NSString(data: data!, encoding:NSASCIIStringEncoding)!
     
     
     let jsonResult: AnyObject = try! NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.MutableContainers)
     
     var resultHotels = NSDictionary()
     resultHotels = jsonResult as! NSDictionary
     
     
     var reviewArr = NSMutableArray()
     reviewArr = resultHotels.valueForKey("reviewDetails")!.valueForKey("reviewCollection")?.valueForKey("review") as! NSMutableArray
     if reviewArr.count>0{
     
     
     
     for i in 0..<reviewArr.count{
     
     let userName = reviewArr .objectAtIndex(i).valueForKey("userDisplayName") as? String ?? "NA"
     
     let comment = reviewArr .objectAtIndex(i).valueForKey("reviewText") as? String ?? "NA"
     
     let photo = ""
     
     
     
     self.reviewsArray .addObject(["userPhoto": photo, "userName": userName, "comment": comment])
     
     }
     
     self.detailTable .reloadData()
     self.heightOfTableView.constant=self.detailTable.rowHeight*2
     self.heightOfThirdView.constant=self.heightOfTableView.constant + 80
     
     
     }
     
     else
     {
     
     self.detailTable.rowHeight=0
     
     }
     
     
     }
     }
     // self.forthIndicator .removeFromSuperview()
     
     })
     
     task.resume()
     }
     else
     {
     CommonFunctionsClass.sharedInstance().alertViewOpen("Please Check Internet Connection", viewController: self)
     }
     
     
     }
     
     */
    
    
    
    
    
    
    
    //MARK: ADD comment section
    //MARK:
    
    @IBAction func AddCommentAction(sender: AnyObject) {
    
    
        let nxtObj2 = self.storyboard?.instantiateViewControllerWithIdentifier("AddCommentViewController") as? AddCommentViewController
        let locationImageStr = self.arrayWithData[0] .valueForKey("locationImage") as? String ?? ""
        
        nxtObj2!.imgUrl=locationImageStr
        
        
        self.navigationController! .pushViewController(nxtObj2!, animated: true)
    
    }
    
    
    
    
    
    
    //
    
    
    
    
    
    
    
    
    
    
    
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
