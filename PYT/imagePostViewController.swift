//
//  imagePostViewController.swift
//  PYT
//
//  Created by Niteesh on 18/10/16.
//  Copyright © 2016 appsMaven. All rights reserved.
//

import UIKit
import GooglePlaces
import SwiftyJSON
import MBProgressHUD
import DKImagePickerController


import AWSS3
import AWSCore
import Photos




class imagePostViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextViewDelegate,UITextFieldDelegate, apiClassDelegate {

    
    
    ////Upload s3
    //WARNING: To run this sample correctly, you must set the following constants.
    let S3BucketName: String = "testpyt"
    let S3DownloadKeyName: String = "S3DownloadKeyName" // an image in the specified S3 Bucket
    let S3UploadKeyName: String = "iqtBkg8alWc0rdsXXoxF6aMc9VJPWROfDDOj3TOd"
    
    
    
    
    
    @IBOutlet var imageToPost: UIButton!
    @IBOutlet var geoTagLbl: UILabel!
    @IBOutlet var descriptionTF: UILabel!
    @IBOutlet var categoriesTF: UILabel!
    @IBOutlet var postBtn: UIButton!
    
    
    var imageData = NSData()
    var isCamera = Bool()
    
    //Thumbnails collection View
    @IBOutlet var SelectedImagesCollectionView: UICollectionView!
    
    @IBOutlet var heightOfCollectionView: NSLayoutConstraint!
    
    
    @IBOutlet weak var topSpaceLabelCount: NSLayoutConstraint!
    
    
      //  @IBOutlet var postBtn: UIButton!
    
    
    //clearBtn
    @IBOutlet weak var clearButtonOutlet: UIButton!
    
    
    //Description View
    @IBOutlet var descriptionView: UIView!
    @IBOutlet var descriptionTV: UITextView!
    
    
    
    //Categories View
    @IBOutlet var categoriesView: UIView!
    @IBOutlet var categoriesTable: UITableView!
    
    var tagsArr: NSMutableArray = [] //["Adventure", "Beaches","City Tours", "Cruises", "Culture","Entertainment","Food","History", "Sports","Mountains", "Museum" , "Nightlife", "Relaxation" , "Restaurants", "Road Trips", "Shopping"]
    var categoriesSelected = String()
    var checked = NSMutableArray()
    var multipleImagesArray = NSMutableArray()
    var originalArray = NSMutableArray()
    var thumbnailArray = NSMutableArray()
    var boolCount = Int()
    
    
    
    //GeoTag View
    @IBOutlet var geoTagView: UIView!
    @IBOutlet var searchTF_GTV: UITextField!
    @IBOutlet var searchTF_GTVback: UIImageView!
    @IBOutlet var searchLocationsTable: UITableView!
    var locationsArr = NSMutableArray()
    var locationStr = String()
    
    
    
    //Image Picker
    let imagePicker = UIImagePickerController()
    var pickerController = DKImagePickerController()
    
    
    //Geo Tag Search
    var placesClient: GMSPlacesClient?
    var searchString = String()
    
    //reverse api
    var locationString = NSString()
    var locationType = NSString()
    var locationCountry = NSString()
    var locationLongitude = NSString()
    var locationLatitude = NSString()
    var locationcity = NSString()
    var locationState = NSString()
    
    
    
    //TEMPORARY ADD ALBELS
    
    @IBOutlet var widthOfCollectionView: NSLayoutConstraint!
    
    @IBOutlet var topSpaceButton: NSLayoutConstraint!
    
    @IBOutlet var AddPictureNew: UIButton!
    
    @IBOutlet var imagesCountLabel: UILabel!
    @IBOutlet var heightOfContainsView: NSLayoutConstraint!
    
    
    
    
    
    
    
    
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
        
        
        
        
        
        
        
        
        let defaults = NSUserDefaults.standardUserDefaults()
        self.tagsArr = defaults.mutableArrayValueForKey("categoriesFromWeb")//categories from the web
        
        self.heightOfCollectionView.constant = 0
        heightOfContainsView.constant=50
        placesClient =  GMSPlacesClient.sharedClient()
        
        //imagePicker.delegate = self
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor(red: 32/255, green: 47/255, blue: 65/255, alpha: 1)
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        
        descriptionTV.inputAccessoryView = toolBar
        searchTF_GTV.inputAccessoryView = toolBar
        
        for index in 0 ..< tagsArr.count {
            checked[index] = false
        }
        
        // Do any additional setup after loading the view, typically from a nib.
        
       // self.SelectedImagesCollectionView.frame.size.height=0
        
           // isCamera=true
            //self .capture()
        
        
        
        
        locationStr=""
        
        categoriesSelected=""
        descriptionTF.font = UIFont(name: "Roboto-Bold", size: 18)!
         descriptionTF.text = "Add"
        descriptionTF.textColor=UIColor .lightGrayColor()
        categoriesTF.font = UIFont(name: "Roboto-Bold", size: 18)!
        categoriesTF.text = "Add"
        categoriesTF.textColor=UIColor .lightGrayColor()
         imageToPost.setImage(nil, forState: .Normal)
        geoTagLbl.font = UIFont(name: "Roboto-Bold", size: 18)!
        geoTagLbl.text = "Add"
        geoTagLbl.textColor=UIColor .lightGrayColor()
        pickerController = DKImagePickerController()
        
        boolCount=0
        
        
        clearButtonOutlet .setTitle("Discard", forState: UIControlState .Normal)
        
        
    }
    override func viewWillAppear(animated: Bool)
    {
        
          imagesCountLabel.font = UIFont(name: "Roboto-Bold", size: 10)!
        
       //if user is logged in
         let defaults = NSUserDefaults.standardUserDefaults()
        let name = defaults.stringForKey("userLoginId")
        if name==""
        {
            print("DONE")
            
            self.tabBarController?.tabBar.hidden = false
            
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
        //Do other stuff if logged in
        else
        {
            self.tabBarController?.tabBar.hidden = false //hide tab bar
            
            postBtn.layer.cornerRadius=postBtn.frame.height/2
            // imageToPost.cornerRadius(0)
            postBtn.clipsToBounds=true
            
            
            searchTF_GTVback.layer.masksToBounds = true
            
            descriptionView.hidden = true
            categoriesView.hidden = true
            geoTagView.hidden = true
//            
//            if locationStr == "" {
//                geoTagLbl.text = "Add"
//                geoTagLbl.font = UIFont(name: "Roboto-Bold", size: 18)!
//                geoTagLbl.textColor = UIColor.lightGrayColor()
//            }
//            
//            descriptionTV.text = "Enter description here.."
//            descriptionTV.textColor = UIColor.lightGrayColor()
            imageToPost.imageView?.contentMode = .ScaleAspectFill
            
          
            
            if self.multipleImagesArray.count<1{
                
                self.heightOfCollectionView.constant=0
                imagesCountLabel.text="No Pictures Added"
               
                topSpaceButton.constant=9
                self.widthOfCollectionView.constant=0
                heightOfContainsView.constant=50
                clearButtonOutlet.hidden=true

            }
            else{
                self.heightOfCollectionView.constant=77
                
              
                imagesCountLabel.text="\(self.multipleImagesArray.count) Pictures Added"
                if self.multipleImagesArray.count<1 {
                    imagesCountLabel.text="No Pictures Added"
                    clearButtonOutlet.hidden=true

                }
                
                heightOfContainsView.constant=90
            }

        }
        
        
         self.navigationController?.navigationBarHidden=true //hide navigation bar
        
        self.AddPictureNew.layer.borderColor=UIColor .darkGrayColor().CGColor
        self.AddPictureNew.layer.borderWidth=1.0
        self.AddPictureNew.layer.cornerRadius=4
        self.AddPictureNew.clipsToBounds=true
        
        ////////start updating location//////////
        Location.locationInstance.locationManager.startUpdatingLocation()
        
    }

   
    
        
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
            NSURLCache.sharedURLCache().removeAllCachedResponses()
        // Dispose of any resources that can be recreated.
    }
    


    //MARK: Action Methods
    
    @IBAction func addCategoriesBtn(sender: AnyObject) {
        //categoriesView.hidden = false
        
        
        self.tabBarController?.tabBar.hidden = true
        self.categoriesView.frame = CGRectMake(0, self.view.bounds.height, self.view.bounds.width, self.view.bounds.height )
        self.categoriesView.hidden=false
        
        UIView.animateWithDuration(0.4, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {() -> Void in
            self.categoriesView.frame = CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height )
            }, completion: {(finished: Bool) -> Void in
        })
        
        
        
        
        
        
        
        postBtn.setTitle("Done", forState: UIControlState.Normal)
        self.tabBarController?.tabBar.hidden = true
    }
    
    @IBAction func addDescriptionBtn(sender: AnyObject) {
        descriptionView.hidden = false
         postBtn.setTitle("Done", forState: UIControlState.Normal)
        self.tabBarController?.tabBar.hidden = true
    }
    
    
    
    @IBAction func clearBtn(sender: AnyObject) {
        
        ///   When clear the data
        multipleImagesArray .removeAllObjects()
        SelectedImagesCollectionView.reloadData()
        originalArray.removeAllObjects()
        thumbnailArray.removeAllObjects()
        categoriesTable.reloadData()
        self.viewDidLoad()
        self.viewWillAppear(true)
        clearButtonOutlet.hidden=true
        
    }
    
    
    
    
    
    
    @IBAction func postBtnAction(sender: AnyObject)
    {
        self.tabBarController?.tabBar.hidden = false
        
        if categoriesView.hidden==false {
            categoriesView.hidden = true
            postBtn.setTitle("Post", forState: UIControlState.Normal)
            self.categoriesDoneBtnAction(self)
            
        }
        else if descriptionView.hidden==false {
            descriptionView.hidden = true
            postBtn.setTitle("Post", forState: UIControlState.Normal)
            self.descriptionDonebtnAction(self)
            
        }
        else if geoTagView.hidden==false {
            geoTagView.hidden = true
            postBtn.setTitle("Post", forState: UIControlState.Normal)
            
        }
        else
        {
            
            
            
            
            
            
            print("desc=\(descriptionTV.text),----- category=\(categoriesTF.text)-------- geotag==\(geoTagLbl.text)")
            
            
            print(imageData.bytes)
            //&& descriptionTV.text  != "Enter description here.."  removed
            if(imageData.bytes != nil && categoriesTF.text != "Add" && geoTagLbl.text != "Add")
            {
               
                //Indicator
                let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                loadingNotification.mode = MBProgressHUDMode.Indeterminate
                loadingNotification.label.text = "Uploading..."
                
                self.startUploadingImage()
                
                
                
                
                
                
            }
            else
            {
                
                
                CommonFunctionsClass.sharedInstance().alertViewOpen("Fill all fields", viewController: self)
                
                
                
                
            }
            
        }
        
        
       
        
    }
    
    
    
    //MARK:- ///////////-------- NEW Images   S3 ----
    
    func startUploadingImage()
    {
        let myGroup = dispatch_group_create()
        
        for l in 0..<multipleImagesArray.count {
            
            
    
        dispatch_group_enter(myGroup)
            
            
            print("Different format \(NSDate())")
            
            let formatter = NSDateFormatter()
            formatter.dateFormat = "ddMMyyHHmmss"
            let stringDate: String = formatter.stringFromDate(NSDate())
            print(stringDate)
    
            
            
           
            let defaults = NSUserDefaults.standardUserDefaults()
            let uId = defaults .stringForKey("userLoginId")
            
            let localFileName:String? = "\(uId!)originalImage\(l)\(stringDate).jpg"//st
           
            
            
            
            
            // Configure AWS Cognito Credentials
            let myIdentityPoolId = "us-west-2:47968651-2cda-46d4-b851-aea8cbcd663f"
            
            let credentialsProvider:AWSCognitoCredentialsProvider = AWSCognitoCredentialsProvider(regionType:AWSRegionType.USWest2, identityPoolId: myIdentityPoolId)
            
            let configuration = AWSServiceConfiguration(region:AWSRegionType.USWest2, credentialsProvider:credentialsProvider)
            
            AWSServiceManager.defaultServiceManager().defaultServiceConfiguration = configuration
            
            // Set up AWS Transfer Manager Request
            let S3BucketName = "testpyt"
            print("Locatl file name= \(localFileName)")
            
            let remoteName = localFileName!
            let uploadRequest = AWSS3TransferManagerUploadRequest()
            uploadRequest.body = self.generateImageUrl(remoteName, index: l)
            uploadRequest.ACL=AWSS3ObjectCannedACL.PublicRead
            uploadRequest.key = remoteName
            uploadRequest.bucket = S3BucketName
            uploadRequest.contentType = "image/jpeg"
            
            
            let transferManager = AWSS3TransferManager.defaultS3TransferManager()
            
            
            
            let s3URL = NSURL(string: "https://s3-us-west-2.amazonaws.com/\(S3BucketName)/\(uploadRequest.key!)")!
            print("Uploaded to:\n\(s3URL)")
            self.originalArray.addObject(String(s3URL))
            
            
            // Perform file upload
            transferManager.upload(uploadRequest).continueWithBlock { (task) -> AnyObject! in
                

                
                
                if let error = task.error {
                    print("Upload failed with error: (\(error.localizedDescription))")
                }
                
                if let exception = task.exception {
                    print("Upload failed with exception (\(exception))")
                }
                
                if task.result != nil {
                    
//                    let s3URL = NSURL(string: "https://s3-us-west-2.amazonaws.com/\(S3BucketName)/\(uploadRequest.key!)")!
//                    print("Uploaded to:\n\(s3URL)")
//                    
//                   
//                   
//                    self.originalArray.addObject(String(s3URL))
                    
                    print(uploadRequest.key)
                    
                    self.remoteImageWithUrl(uploadRequest.key!)
                    
                    if l==self.multipleImagesArray.count-1 {
                    dispatch_async(dispatch_get_main_queue()) {
                        
                       // CommonFunctionsClass.sharedInstance().alertViewOpen("Upload on s3", viewController: self)
                    }
                    }
                    
                    
                }
                else {
                    print("Unexpected empty result.")
                }
                
                
                
                
                  dispatch_group_leave(myGroup)
                
                return nil
                
                
                
               
              
                
                
            }//
                
            
            
            
       
        
            
        }
        
       
        
        dispatch_group_notify(myGroup, dispatch_get_main_queue(), {
            print("Finished all Original requests.")
            self.boolCount=self.boolCount+1
            print(self.boolCount)
            //self.sendtoDataBase()
             self.sendThumbnails()
        })
        
        
        
    }
    
    
    func sendThumbnails() {
        
        
        let myGroup2 = dispatch_group_create()
        
        for l in 0..<multipleImagesArray.count {
            
            
            
            dispatch_group_enter(myGroup2)
            
            
            
            
            
           
            
            let formatter = NSDateFormatter()
            formatter.dateFormat = "ddMMyyHHmmss"
            let stringDate: String = formatter.stringFromDate(NSDate())
            print(stringDate)
            
            
            
            let defaults = NSUserDefaults.standardUserDefaults()
            let uId = defaults .stringForKey("userLoginId")
            
            
            let localFileName:String? = "\(uId!)ThumbnailImage\(l)\(stringDate).jpg"//st

            
            
            
            
            
            
            // Configure AWS Cognito Credentials
            let myIdentityPoolId = "us-west-2:47968651-2cda-46d4-b851-aea8cbcd663f"
            
            let credentialsProvider:AWSCognitoCredentialsProvider = AWSCognitoCredentialsProvider(regionType:AWSRegionType.USWest2, identityPoolId: myIdentityPoolId)
            
            let configuration = AWSServiceConfiguration(region:AWSRegionType.USWest2, credentialsProvider:credentialsProvider)
            
            AWSServiceManager.defaultServiceManager().defaultServiceConfiguration = configuration
            
            // Set up AWS Transfer Manager Request
            let S3BucketName = "testpyt"
            print("Locatl file name= \(localFileName)")
            
            let remoteName = localFileName!
            let uploadRequest = AWSS3TransferManagerUploadRequest()
            uploadRequest.body = self.generateThumbnailImageUrl(remoteName, index: l)
            uploadRequest.ACL=AWSS3ObjectCannedACL.PublicRead
            uploadRequest.key = remoteName
            uploadRequest.bucket = S3BucketName
            uploadRequest.contentType = "image/jpeg"
        
            
            let transferManager = AWSS3TransferManager.defaultS3TransferManager()
            
            // Perform file upload
            
            let s3URL = NSURL(string: "https://s3-us-west-2.amazonaws.com/\(S3BucketName)/\(uploadRequest.key!)")!
            print("Uploaded to:\n\(s3URL)")
            
            self.thumbnailArray .addObject(String(s3URL))
            
            transferManager.upload(uploadRequest).continueWithBlock { (task) -> AnyObject! in
                

                
                
                if let error = task.error {
                    print("Upload failed with error: (\(error.localizedDescription))")
                }
                
                if let exception = task.exception {
                    print("Upload failed with exception (\(exception))")
                }
                
                if task.result != nil {
                    
//                   let s3URL = NSURL(string: "https://s3-us-west-2.amazonaws.com/\(S3BucketName)/\(uploadRequest.key!)")!
//                    print("Uploaded to:\n\(s3URL)")
//                    
//                    self.thumbnailArray .addObject(String(s3URL))
                    
                    // Remove locally stored file
                    self.remoteImageWithUrl(uploadRequest.key!)
                    
                    if l==self.multipleImagesArray.count-1 {
                        dispatch_async(dispatch_get_main_queue()) {
                            
                            //CommonFunctionsClass.sharedInstance().alertViewOpen("Upload on s3", viewController: self)
                        }
                    }
                    
                    
                }
                else {
                    print("Unexpected empty result.")
                }
                
                
                
                
                dispatch_group_leave(myGroup2)
                
                return nil
                
                
                
                
            }
            
            
            
            
            
            
            
        }
        
        
        dispatch_group_notify(myGroup2, dispatch_get_main_queue(), {
            print("Finished all Thumbnail requests.")
            self.boolCount=self.boolCount+1
            print(self.boolCount)
            self.sendtoDataBase()
            
        })
        
        
        
    }
    
    
    
    
    func generateImageUrl(fileName: String, index: Int) -> NSURL
    {
    
        
        let tempImageV = multipleImagesArray.objectAtIndex(index).valueForKey("originalImage") as! UIImage
        
        let fileURL = NSURL(fileURLWithPath: NSTemporaryDirectory().stringByAppendingString("PytOriginal-\(fileName)"))
        let data = UIImageJPEGRepresentation(tempImageV, 0.2)
        data!.writeToURL(fileURL, atomically: true)
        
        return fileURL
    }
    
    func generateThumbnailImageUrl(fileName: String, index: Int) -> NSURL
    {
        
        
        let tempImageV = multipleImagesArray.objectAtIndex(index).valueForKey("thumbnail") as! UIImage
        
        let fileURL = NSURL(fileURLWithPath: NSTemporaryDirectory().stringByAppendingString("\(fileName)"))
        let data = UIImageJPEGRepresentation(tempImageV, 0.2)
        data!.writeToURL(fileURL, atomically: true)
        
        return fileURL
    }
    
    
    
    
    
    func remoteImageWithUrl(fileName: String)
    {
        let fileURL = NSURL(fileURLWithPath: NSTemporaryDirectory().stringByAppendingString(fileName))
        do {
            try NSFileManager.defaultManager().removeItemAtURL(fileURL)
        } catch
        {
            print(error)
        }
    }

    
   
    
    
    
    func sendtoDataBase() {
        
        
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let uId = defaults .stringForKey("userLoginId")
        
        
        if thumbnailArray.count==originalArray.count {
            
            if self.boolCount==2{
                
                
                print("Upload to database")
                
                
                
                var location = ""
                var place = ""
                var state = ""
                var city = ""
                var country = ""
                
                
                let anArr = geoTagLbl.text?.componentsSeparatedByString(",")
                if anArr?.count ==  6{
                    place = anArr![0]
                    location = anArr![0]
                    city = anArr![3]
                    state = anArr![4]
                    country = anArr![5]
                    
                }
                else if anArr?.count ==  5{
                    place = anArr![0]
                    location = anArr![0]
                    
                    city = anArr![2]
                    state = anArr![3]
                    country = anArr![4]
                }
                else if anArr?.count ==  4{
                    place = anArr![0]
                    location = place
                    city = anArr![1]
                    state = anArr![2]
                    country = anArr![3]
                }
                else if anArr?.count ==  3{
                    place = anArr![0]
                    location = place
                    city = anArr![1]
                    country = anArr![2]
                }
                else if anArr?.count ==  2{
                    place = anArr![0]
                    location = place
                    country = anArr![1]
                }
                else if anArr?.count ==  1{
                    country = anArr![0]
                }
                
                //Indicator
                //            let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                //            loadingNotification.mode = MBProgressHUDMode.Indeterminate
                //            loadingNotification.label.text = "Uploading..."
                
                if descriptionTV.text  == "Enter description here.." {
                    descriptionTV.text=""
                }
                
                
                var dic = NSDictionary()
                let add = geoTagLbl.text! as String
                if self.locationType=="other" {
                    
                    dic = [
                        "Description": descriptionTV.text!,
                        "category": categoriesTF.text!,
                        "location":self.changeSpecialCharacter(location),
                        "city":self.changeSpecialCharacter(city),
                        "state":self.changeSpecialCharacter(state),
                        "country":self.changeSpecialCharacter(country),
                        "latitude":"",
                        "longitude":"",
                        "place": self.changeSpecialCharacter(place),
                        "address":self.changeSpecialCharacter(add),
                        "userId":uId!
                    ]
                    
                }
                else
                {
                    
                    dic = [
                        "Description": descriptionTV.text!,
                        "category": categoriesTF.text!,
                        "location":self.locationString,
                        "city":self.locationcity,
                        "state":self.locationState,
                        "country":self.locationCountry,
                        "latitude":self.locationLatitude,
                        "longitude":self.locationLongitude,
                        "place": self.changeSpecialCharacter(place),
                        "address":self.changeSpecialCharacter(add),
                        "userId":uId!
                    ]
                    
                }
                
                
                
                let imagesDictionary = NSMutableDictionary()
                
                //            for l in 0..<multipleImagesArray.count {
                //
                //                let originalImageLink = originalArray.objectAtIndex(l)
                //                let thumbnailImageLink = thumbnailArray.objectAtIndex(l)
                //
                //                imagesDictionary.setValue(originalImageLink, forKey: "originalPhoto\(l)")
                //                imagesDictionary.setValue(thumbnailImageLink, forKey: "thumbnailPhoto\(l)")
                //
                //            }
                
                
                imagesDictionary .setValue(dic, forKey: "userData")
                imagesDictionary .setValue(originalArray, forKey: "originaPhoto")
                imagesDictionary .setValue(thumbnailArray, forKey: "thumbnailPhoto")
                
                ApiServices.sharedInstance.postRequest("",params:imagesDictionary,data: imagesDictionary, onCompletion: {json, error, status in
                    print(json)
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        if(json["status"].int! == 1)
                        { MBProgressHUD.hideHUDForView(self.view, animated: true)
                            
                            let Alert = UIAlertController(title: "", message: json["msg"].string!, preferredStyle: UIAlertControllerStyle.Alert)
                            
                            Alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                                
                               
                                Location.locationInstance.locationManager.stopUpdatingLocation()
                                
                                self.clearBtn(self)
                                
                                self.boolCount=0
                                self.dismissViewControllerAnimated(true, completion: {})
                                
                                self.tabBarController?.selectedIndex = 0
                                
                                
                                //self.BAckAction(self)
                                
                            }))
                            
                            self.presentViewController(Alert, animated: true, completion: nil)
                            
                            
                        }
                        else
                        {
                            let Alert = UIAlertController(title: "", message: "Something went wrong", preferredStyle: UIAlertControllerStyle.Alert)
                            
                            Alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                                
                            }))
                            
                            self.presentViewController(Alert, animated: true, completion: nil)
                        }
                        
                        
                        MBProgressHUD.hideHUDForView(self.view, animated: true)
                        
                        
                    }
                    
                })
                
                
            }
            
            
            
            
            
            
            
            
            
            
            
            
        }
        else{
            print("not upload yet")
        }
        
        
        
    }
    
    
    //MARK:-
    //MARK:-
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    @IBAction func geoTagBtnAction(sender: AnyObject) {
        
        self.tabBarController?.tabBar.hidden = true
        locationsArr .removeAllObjects()
        searchLocationsTable .reloadData()
        searchLocationsTable.hidden=true
        
        
        searchTF_GTV.text = geoTagLbl.text
        categoriesTF.font = UIFont.systemFontOfSize(15.0)
        geoTagView.hidden = false
        
        postBtn.setTitle("Done", forState: UIControlState.Normal)
        
        let currntLocString = Location.locationInstance.locationString
        
        
        if(geoTagLbl.text != "Add location of your image")
        {
            
            //placeAutocomplete(geoTagLbl.text!)
            searchTF_GTV.text = ""
            placeAutocomplete(currntLocString as String)
        }
        else
        {
            searchTF_GTV.text = ""
            placeAutocomplete(currntLocString as String)
        }
        
    }
    
    @IBAction func categoriesDoneBtnAction(sender: AnyObject) {
        categoriesSelected = ""
        for index in 0..<checked.count {
            if(checked[index] as! Bool == true)
            {
                let  strrin = tagsArr.objectAtIndex(index).valueForKey("name") as! String
                
                categoriesSelected = categoriesSelected + strrin + ","
            }
        }
        categoriesSelected = String(categoriesSelected.characters.dropLast())
        
        if (categoriesSelected == "") {
            categoriesTF.font = UIFont(name: "Roboto-Bold", size: 18)!
            categoriesTF.text = "Add"
            categoriesTF.textColor = UIColor.lightGrayColor()
        }
        else
        {
            categoriesTF.font = UIFont.systemFontOfSize(15.0)
            categoriesTF.text = categoriesSelected
            categoriesTF.textColor = UIColor.blackColor()
            clearButtonOutlet.hidden=false
        }
        
        categoriesView.hidden = true
    }
    @IBAction func descriptionDonebtnAction(sender: AnyObject) {
        if (descriptionTV.text == "Enter description here..") {
            descriptionTF.font = UIFont(name: "Roboto-Bold", size: 18)!
            descriptionTF.text = "Add"
            descriptionTF.textColor = UIColor.lightGrayColor()
        }
        else
        {
            descriptionTF.font = UIFont.systemFontOfSize(15.0)
            descriptionTF.text = descriptionTV.text
            descriptionTF.textColor = UIColor.blackColor()
            clearButtonOutlet.hidden=false
        }
        descriptionView.hidden = true
    }
    
    
   
    
    
    
    
    
    
    @IBAction func BAckAction(sender: AnyObject) {
        
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        
        if categoriesView.hidden==false {
            
            UIView.animateWithDuration(0.4, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {() -> Void in
                self.categoriesView.frame = CGRectMake(0, self.view.bounds.height, self.view.bounds.width, self.view.bounds.height )
                }, completion: {(finished: Bool) -> Void in
            })
            
           categoriesView.hidden=true
            
            
            
        }
        else if descriptionView.hidden==false{
            descriptionView.hidden=true
        }
        else if geoTagView.hidden==false{
            geoTagView.hidden=true
        }
            
        else
        {
        let nxtObj = self.storyboard?.instantiateViewControllerWithIdentifier("MainTabBarViewController") as! MainTabBarViewController
        
        dispatch_async(dispatch_get_main_queue(), {
            
            Location.locationInstance.locationManager.stopUpdatingLocation()
            
            self.presentViewController(nxtObj, animated: true, completion: nil)
            
//           // self.navigationController!.popToRootViewControllerAnimated(true)
//            self.navigationController! .pushViewController(nxtObj, animated: true)
          //  self.dismissViewControllerAnimated(true, completion: {})
            
        })
        }
       
    }
    
    
    
    
    
    
    //MARK: Table View
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(tableView == searchLocationsTable)
        {
            return locationsArr.count
        }
        else if(tableView == categoriesTable)
        {
            return tagsArr.count
        }
        return 0
    }
    func tableView(tableView: UITableView , heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if(tableView == searchLocationsTable)
        {
            return 50
        }
        else if(tableView == categoriesTable)
        {
            return 50
        }
        return 50
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        if(tableView == searchLocationsTable)
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("SearchLocationsCell") as! SearchLocationsCell
            let dic = locationsArr[indexPath.row]
            cell.name.text = dic.objectForKey("name") as? String
            cell.place.text = dic.objectForKey("place") as? String
            
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("CategoriesCell") as! CategoriesCell
            cell.name.text = tagsArr.objectAtIndex(indexPath.row).valueForKey("name") as? String
            
            
            cell.checkMark.layer.cornerRadius=cell.checkMark.frame.size.width/2
            cell.checkMark.clipsToBounds=true
            
            if (checked[indexPath.row] as! Bool == true)
            {
                
                cell.checkMark.image=UIImage (named: "searchSelect")
               
                cell.checkMark.backgroundColor=UIColor .clearColor()
                //cell.accessoryType = .Checkmark
                //tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: UITableViewScrollPosition.Bottom)
            } else {
                cell.checkMark.image=UIImage (named: "searchUnselect")
              
               cell.checkMark.backgroundColor=UIColor .clearColor()
                
                // cell.accessoryType = .None
            }
            return cell
            
        }
    }
   
//    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
//        if(tableView == categoriesTable)
//        {
//            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
//                cell.accessoryType = .None
//                checked[indexPath.row] = false
//            }
//        }
//        else if(tableView == searchLocationsTable)
//        {
//            
//        }
//    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if tableView == categoriesTable {
           // if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                
                if checked[indexPath.row] as! Bool == true {
                     checked[indexPath.row] = false
                }
                
               // if cell.accessoryType == .Checkmark {
                    //cell.accessoryType = .None
                    
                   
               // }
                
                
                
                else {
                    //cell.accessoryType = .Checkmark
                    checked[indexPath.row] = true
                }
            //}
            
            categoriesTable.reloadData()
            
        }
        else
        {
            let dic = locationsArr[indexPath.row]
            
            var locationStr = ""
            if dic.objectForKey("place")as? String == "" {
                locationStr = String(format: "%@",(dic.objectForKey("name") as? String)! )
            }
            else{
                locationStr = String(format: "%@ , %@",(dic.objectForKey("name") as? String)!,(dic.objectForKey("place") as? String)! )
            }
            
            
            if locationStr == "" {
                geoTagLbl.text = "Add location of your image"
                geoTagLbl.textColor = UIColor.lightGrayColor()
                
            }
            else
            {
                geoTagLbl.text = locationStr
                
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                        loadingNotification.mode = MBProgressHUDMode.Indeterminate
                        loadingNotification.label.text = "Please Wait..."
                        self.clearButtonOutlet.hidden=false
                                self.googleReverse(locationStr)
                    //self.googleReverse(dic.objectForKey("name") as? String ?? "")
                        })
                
               
                
                geoTagLbl.textColor = UIColor.blackColor()
                geoTagLbl.font = UIFont.systemFontOfSize(15.0)
                postBtn.setTitle("Post", forState: UIControlState.Normal)
                self.tabBarController?.tabBar.hidden = false
               
              
                
                
                
            }
            
           
            
            self.view.endEditing(true)
            geoTagView.hidden = true
        }
    }
    
    //MARK: Text View Delegates
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
    }
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter description here.."
            textView.textColor = UIColor.lightGrayColor()
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText:NSString = textView.text
        let updatedText = currentText.stringByReplacingCharactersInRange(range, withString:text)
        
        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {
            
            textView.text = "Enter description here.."
            textView.textColor = UIColor.lightGrayColor()
            
            textView.selectedTextRange = textView.textRangeFromPosition(textView.beginningOfDocument, toPosition: textView.beginningOfDocument)
            
            return false
        }
            
            // Else if the text view's placeholder is showing and the
            // length of the replacement string is greater than 0, clear
            // the text view and set its color to black to prepare for
            // the user's entry
        else if textView.textColor == UIColor.lightGrayColor() && !text.isEmpty {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
        
        return true
    }
    
    func donePicker()
    {
        //        descriptionTV.resignFirstResponder()
        //       // geoTagTF.resignFirstResponder()
        searchTF_GTV.resignFirstResponder()
        self.view.endEditing(true)
        self.geoTagView.endEditing(true)
    }
    
    //MARK: Text Field Delegates
    func textFieldDidBeginEditing(textField: UITextField) {    //delegate method
        textField.text=""
        locationsArr .removeAllObjects()
        searchLocationsTable .reloadData()
        searchLocationsTable.hidden=true
        searchString = String()
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {  //delegate method
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        searchString = searchString + string
        
        if(string == "")
        {
            searchString = searchString.substringToIndex(searchString.endIndex.predecessor())
            print(searchString)
        }
        searchLocationsTable.hidden=false
        if(searchString == "")
        {
             searchLocationsTable.hidden=true
            locationsArr .removeAllObjects()
            searchLocationsTable.reloadData()
        }
        else
        {
            placeAutocomplete(searchString)
        }
        

        
        
        return true;
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        self.view.endEditing(true)
        searchTF_GTV.resignFirstResponder()
        return true
    }
    
    //MARK:- CollectionView Data source and delegates
    //MARK:-
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int   {
        
        return 1
    }
    
    
    
    
    func collectionView(collectionView: UICollectionView,numberOfItemsInSection section: Int) -> Int {
        
       
        if multipleImagesArray.count<1 {
            return 0
        }
        else{
            return multipleImagesArray.count
        }
        
        
       
    }
    
    func collectionView(collectionView: UICollectionView,cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
       
        //let cell = ImageCollectionViewCell.dequeueReusableCellWithReuseIdentifier("imagesCell",forIndexPath: indexPath)
        
let cell = collectionView.dequeueReusableCellWithReuseIdentifier("imagesCell", forIndexPath: indexPath) as! ImageCollectionViewCell
        
        
        let img = self.multipleImagesArray .objectAtIndex(indexPath.row).valueForKey("Image") as! UIImage
        
        cell.selectedImage.image=img
        
        cell.selectedImage.contentMode = .ScaleAspectFill
        cell.selectedImage.layer.cornerRadius = 3
        cell.selectedImage.clipsToBounds = true
        cell.buttonDelete.tag=indexPath.row
        cell.buttonDelete .addTarget(self, action: #selector(imagePostViewController.deleteSelectedImage(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        cell.buttonDelete.layer.cornerRadius=cell.buttonDelete.frame.size.width/2
        cell.buttonDelete.clipsToBounds=true
       // cell.layer.cornerRadius=5
       // cell.clipsToBounds=true
        
        cell.buttonAdd.hidden=true
        cell.buttonDelete.hidden=false
        cell.selectedImage.hidden=false
        
        

        
            return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
       
         let img = self.multipleImagesArray .objectAtIndex(indexPath.row).valueForKey("originalImage") as! UIImage
        
        
        imageToPost.setImage(img, forState: .Normal)
        imageToPost.imageView?.contentMode = .ScaleAspectFill
        imageToPost.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        //imageToPost.imageView?.clipsToBounds = true
       // imageToPost.clipsToBounds=true
        
        
        
    }
    
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
            return CGSize(width: 80, height: 80) // The size of one cell
        
    }
    
    
    
    //Remove image target from collectionView
    func deleteSelectedImage(sender:UIButton) -> Void {
        
        print(sender.tag)
        self.multipleImagesArray .removeObjectAtIndex(sender.tag)
         imageToPost.userInteractionEnabled=true
    self.SelectedImagesCollectionView .reloadData()
        imagesCountLabel.text="\(self.multipleImagesArray.count) Added"
        clearButtonOutlet.hidden=false
        
        if self.multipleImagesArray.count<1 {
            imageToPost .setImage(nil, forState: UIControlState .Normal)
            self.heightOfCollectionView.constant = 0
            topSpaceButton.constant=9
            self.widthOfCollectionView.constant=0
            self.heightOfContainsView.constant=50
            clearButtonOutlet.hidden=true

            imagesCountLabel.text="No Pictures Added"
            
        }
        else
        {
            let img = self.multipleImagesArray .objectAtIndex(0).valueForKey("originalImage") as! UIImage
            
            
            imageToPost.setImage(img, forState: .Normal)
            imageToPost.imageView?.contentMode = .ScaleAspectFill
            imageToPost.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            //imageToPost.imageView?.clipsToBounds = true
            //imageToPost.clipsToBounds=true

        }
        
        
    
            
        
        
        
    
    }
    
    
    
    
    
    //MARK: Get Geo Tagsd
    func placeAutocomplete(place:String) {
        
        locationsArr.removeAllObjects()
        
        let offset = 200.0 / 1000.0;
        
        let latMax = Location.locationInstance.locationLatitude + offset;
        let latMin = Location.locationInstance.locationLatitude - offset;
        let lngOffset = offset * cos(Location.locationInstance.locationLatitude * M_PI / 200.0);
        let lngMax = Location.locationInstance.locationLongitude + lngOffset;
        let lngMin = Location.locationInstance.locationLongitude - lngOffset;
        let initialLocation = CLLocationCoordinate2D(latitude: latMax, longitude: lngMax)
        let otherLocation = CLLocationCoordinate2D(latitude: latMin, longitude: lngMin)
        let bounds = GMSCoordinateBounds(coordinate: initialLocation, coordinate: otherLocation)
        
        let filter = GMSAutocompleteFilter()
        filter.type = .NoFilter
        
        placesClient!.autocompleteQuery(place, bounds: bounds, filter: filter, callback: { (results, error: NSError?) -> Void in
            guard error == nil else {
                print("Autocomplete error \(error)")
                return
            }
            
            
            //print(results)
            
            
            
            
            for result in results! {
                
                let dic = [
                    "name":result.attributedPrimaryText.string ,
                    "place":result.attributedSecondaryText!.string,
                    "tpye":result.types[0] as? String ?? ""
                ]
                
                
                self.locationsArr.addObject(dic)
            }
            if self.locationsArr.count>0{
                self.searchLocationsTable.hidden=false
            }
            self.searchLocationsTable.reloadData()
        })
    }
    
    
    
    //MARK: Image Picker Delegates
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController,didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        
        if multipleImagesArray.count<8 {
            self.heightOfCollectionView.constant = 77
            self.SelectedImagesCollectionView.hidden=false
            self.widthOfCollectionView.constant=self.view.frame.width/1.5
            self.topSpaceButton.constant=50
            heightOfContainsView.constant=90
            
            var chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage!
            
            let urlImg = info[UIImagePickerControllerReferenceURL]
            
            
            
            
            print(chosenImage)
            
            var finalImage = UIImage()
            finalImage=chosenImage
           
            
            var uploadImg = UIImage()
            
            if chosenImage.size.width>1500 {
                
                //finalImage =  scaleImage(chosenImage, toSize: CGSize(width: 2048, height: 1556))
                finalImage =  scaleImage(chosenImage, toSize: CGSize(width: self.imageToPost.frame.size.width+150, height: self.imageToPost.frame.size.height+150))
                
                
                
                 uploadImg = scaleImage(chosenImage, toSize: CGSize(width: 1500, height: 1300))
                imageData = UIImageJPEGRepresentation(uploadImg,0.2)!
                
                print(imageData.bytes)
                
                
            }
            else
            {
                imageData = UIImageJPEGRepresentation(chosenImage,0.2)!
                print(imageData.bytes)
            }
            
            
            chosenImage = finalImage
            
            
            
            
            imageToPost.setImage(chosenImage, forState: .Normal)
            imageToPost.imageView?.contentMode = .ScaleAspectFill
            imageToPost.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            
            
            finalImage = self.scaleImage(chosenImage, toSize: CGSize(width:100, height: 100))
            
            let testImgView = UIImageView()
            testImgView.image=self.scaleImage(chosenImage, toSize: CGSize(width:300, height: 300))
            
            self.multipleImagesArray .addObject(["Image":finalImage, "imageData": imageData, "originalImage":chosenImage, "urlImg":"camera", "thumbnail": testImgView.image! ])
            
            imagesCountLabel.text="\(self.multipleImagesArray.count) Added"
            self.SelectedImagesCollectionView .reloadData()
            clearButtonOutlet.hidden=false

           print("original=\(chosenImage), other=\(testImgView.image)")
            
            
            dismissViewControllerAnimated(true, completion: nil)
            
            
            
            
            
            
            
            ///Testing
            
            
         //   CommonFunctionsClass.sharedInstance().alertViewOpen("Original image\(info[UIImagePickerControllerOriginalImage] as! UIImage!),  ---- resize image \(chosenImage), new Resize img=\(uploadImg),size of img mb=\(self.imageData.length/1024/1024), size of img kb=\(self.imageData.length/1024)", viewController: self)
            
            
            /////testing
            
            
            
        }
            
        else
        {
            dismissViewControllerAnimated(true, completion: nil)
            
            CommonFunctionsClass.sharedInstance().alertViewOpen("Cannot add more then 8 pictures", viewController: self)
        }
        
       
    }
    
    
    
    
    func photofromLibrary() {
        
      
        pickerController=DKImagePickerController()
        
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            print("didSelectAssets")
            print(assets)
            
        }
        
        
        
        
        
        self.presentViewController(pickerController, animated: true) {}
        
        pickerController.allowMultipleTypes=false
        pickerController.assetType = .AllPhotos
        pickerController.maxSelectableCount = 8 - self.multipleImagesArray.count
        
      
        
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            print("didSelectAssets")
          //  self.multipleImagesArray .removeAllObjects()
            
          
            
            dispatch_async(dispatch_get_main_queue()) {
                self.heightOfCollectionView.constant = 90
                self.SelectedImagesCollectionView.hidden=false
                self.widthOfCollectionView.constant=self.view.frame.width/1.5
                self.topSpaceButton.constant=50
                self.heightOfContainsView.constant=90

            for asset in assets {
                
                
                asset.fetchOriginalImage(false, completeBlock: { image, info in
                
                    if let img = image{
                        print(img)
                        
                        print(info)
                        let dictInfo:NSDictionary = info!
                        
                        print(dictInfo.valueForKey("PHImageFileURLKey"))
                        let urlImg = dictInfo.valueForKey("PHImageFileURLKey")
                        
//                        self.imageData = UIImageJPEGRepresentation(img,0.3)!
//                        print(self.imageData.bytes)
                        var uploadImg = UIImage()
                        
                        if img.size.width>1200 {
                            
                           
                            print("Going Inside")
                            
                            uploadImg = self.scaleImage(img, toSize: CGSize(width: 1500, height: 1300))
                            self.imageData = UIImageJPEGRepresentation(uploadImg,0.2)!
                            
                            print(self.imageData.length/1024/1024)
                            
                            
                        }
                        else
                        {
                            self.imageData = UIImageJPEGRepresentation(img,0.2)!
                           print(self.imageData.length/1024/1024)
                        }
                        
                        
                        
                        
                        
                        
                        
                        self.imageToPost.setImage(img, forState: .Normal)
                        self.imageToPost.imageView?.contentMode = .ScaleAspectFill
                        self.imageToPost.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
                        
                        
                        
                       let finalImage = self.scaleImage(img, toSize: CGSize(width:100, height: 100))
                        
                        let testImgView = UIImageView()
                        testImgView.image=self.scaleImage(img, toSize: CGSize(width:300, height: 250))
                    
                        if self.multipleImagesArray.count<8 {
                           
                            
                            if self.multipleImagesArray.valueForKey("urlImg").containsObject(urlImg!){
                                
                                print("contains")
                                
                            }
                            else{
                            self.multipleImagesArray .addObject(["Image":finalImage, "imageData": self.imageData, "originalImage":img, "urlImg": urlImg!, "thumbnail": testImgView.image!])
                            // print(multipleImagesArray)
                            }
                            
                            
                             print("original=\(img), other=\(testImgView.image)")
                            
                        }
                        
                        
                        
                       // CommonFunctionsClass.sharedInstance().alertViewOpen("oringinal=\(img), scaled=\(uploadImg), size of mb img=\(self.imageData.length/1024/1024), size of kb img=\(self.imageData.length/1024)", viewController: self)
                        
                    }
                    
                    
                    
                    
                self.SelectedImagesCollectionView .reloadData()
                self.imagesCountLabel.text="\(self.multipleImagesArray.count) Added"
                    self.clearButtonOutlet.hidden=false

                
                })
                
            }
            }
        
            
        }
        
        
        
        
        
//        imagePicker.allowsEditing = false
//        imagePicker.sourceType = .PhotoLibrary
//        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func capture() {
       // if isCamera == false {
           // multipleImagesArray .removeAllObjects()
        //isCamera=true
       // }
        
       
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .Camera
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    
    
    
    func scaleImage(image: UIImage, toSize newSize: CGSize) -> UIImage {
        var scaledSize:CGSize = newSize
        var scaleFactor: Float = 1
        if image.size.width > image.size.height {
            scaleFactor = Float(image.size.width / image.size.height)
            scaledSize.width = newSize.width
            scaledSize.height =  newSize.height / CGFloat(scaleFactor)
        }
        else {
            scaleFactor = Float(image.size.height / image.size.width)
            scaledSize.height = newSize.height
            scaledSize.width = newSize.width / CGFloat(scaleFactor)
        }
        UIGraphicsBeginImageContextWithOptions(scaledSize, false, 0.0)
        let scaledImageRect = CGRectMake(0.0, 0.0, scaledSize.width, scaledSize.height)
        image.drawInRect(scaledImageRect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        

        
        
        return scaledImage
    }
    
    
    
   
    
    
    
    
    
    
    @IBAction func actionSheet(sender: AnyObject)
    {
        imagePicker.delegate = self
        
        
        
        if multipleImagesArray.count==8 {
            CommonFunctionsClass.sharedInstance().alertViewOpen("Cannot add more than 8 pictures", viewController: self)
        }
        else{
            
            let alertController = UIAlertController(title: "Select Image", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
            
            let libAction = UIAlertAction(title: "Select from library", style: UIAlertActionStyle.Default, handler: {(alert: UIAlertAction!) in self.photofromLibrary()
                
            })
            
            let captureAction = UIAlertAction(title: "Capture image", style: UIAlertActionStyle.Default, handler: {(alert: UIAlertAction!) in self.capture()
                
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: {(alert: UIAlertAction!) in print("cancel")})
            
            alertController.addAction(libAction)
            alertController.addAction(captureAction)
            alertController.addAction(cancelAction)
            
            self.presentViewController(alertController, animated: true, completion:{})
        }
        
        
        
    }
    
    
    
    
    
    func googleReverse(name:NSString) -> Void
    
    {
        
        //capital letter first
        var str2 = String()
        str2=name as String
        var str = NSString()
        str=str2
        
        
        print(str)
        
        if str.length<1 // check if empty textfield
        {
           
        }
            
//        else if(str .rangeOfCharacterFromSet(NSCharacterSet .decimalDigitCharacterSet()).location != NSNotFound)//check numeric value
//        {
//            
//            print("numeric values")
//        }
            
            //finaly add location with G.Reverse api
        else
        {
            //str2.replaceRange(str2.startIndex...str2.startIndex, with: String(str2[str2.startIndex]).capitalizedString)
            str2 = str2.capitalizedString
            var str = NSString()
            print(str2)
            str = str2 .stringByTrimmingCharactersInSet(NSCharacterSet .whitespaceCharacterSet())
            
           
            
                
                
                ///get the lat long if not avaliable
                let address = str2 as String
                let geocoder = CLGeocoder()
                geocoder
                
                geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
                    if((error) != nil)
                    {
                        print("Error", error)
                        self.locationType = "other"
                        
                       MBProgressHUD.hideHUDForView(self.view, animated: true)
                        
                       
                    }
                    else{
                         if let placemark = placemarks?.first
                        {
                            let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                            //print(coordinates)
                            let latitude = String(format:"%f", coordinates.latitude)
                            let longitude = String(format:"%f", coordinates.longitude)
                             //print(placemark.name)
                
                             //print(placemark.addressDictionary)
                            
                            
                            if placemark.addressDictionary==nil
                            {
                                
                            }
                                
                            else
                            {
                    
                                
                               
                                print("Name From PlaceApi-- \(str2)")
                                
                                
                                let subLoc = placemark.addressDictionary!["SubLocality"] as? String ?? ""
                                print("SubLocality-- \(subLoc)")
                                
                               
                            
                                
                                let state = placemark.addressDictionary!["State"] as? String ?? ""
                                print("State--\(state)")
                               
                                
                                
                                let city = placemark.addressDictionary!["City"] as? String ?? ""
                                print("City---\(city)")
                                
                                
                                
                                
                                
                                let country = placemark.addressDictionary!["Country"] as? String ?? ""
                                print("Country-- \(country)")
                                
                                print("Lat--- \(latitude)")
                                print("Long----\(longitude)")
                        
                                
                                self.locationString = self.changeSpecialCharacter(str2)//str2
                                self.locationLatitude = latitude
                                self.locationLongitude = longitude
                                self.locationCountry = self.changeSpecialCharacter(country)//country
                                self.locationcity=self.changeSpecialCharacter(city)//city
                                 self.locationState = self.changeSpecialCharacter(state) //state
                                
                                
                               
                                var type = NSString()//used to find the entered string is a City, State, or country
                                type = ""
                                
                                if(str.caseInsensitiveCompare(city) == NSComparisonResult.OrderedSame)
                                {
                                    print("is city")
                                    self.locationString=self.changeSpecialCharacter(city)
                                    type = "city"
                                }
                                    
                                else if(str.caseInsensitiveCompare(state) == NSComparisonResult.OrderedSame)
                                {
                                    print("is state")
                                    self.locationcity=self.changeSpecialCharacter(state)
                                    type = "state"
                                }
                                else if(str.caseInsensitiveCompare(country) == NSComparisonResult.OrderedSame)
                                {
                                    print("is country")
                                    self.locationCountry = self.changeSpecialCharacter(country)
                                    type = "country"
                                }
                                    
                                
                                self.locationType = type
                                
                                
                                    
                                
                                
                            }
                            
                            
                        }
                        
                          MBProgressHUD.hideHUDForView(self.view, animated: true)
                    }
                    
                   
                    
                })
                
            
        }
        
        
    }
    
    
    
    
    //MARK:- Get the categories from api from database
    
    func serverResponseArrived(Response:AnyObject)
    {
        
        
        jsonResult = NSDictionary()
        jsonResult = Response as! NSDictionary
        print(jsonResult)
        
    }
    
    
    
    //Mark: Function to change the special characters
    func changeSpecialCharacter(textAsString: String) -> String {
        
        
        
        let txtToChange = textAsString
        let safeURL = txtToChange.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        
        
        print("Final Url-----> " + (safeURL as String))
        
        return safeURL
        
        
    }
    
    
    
    
    
}
extension UIButton
{
    //func cornerRadius(radius:CGFloat)  {
       // self.layer.cornerRadius = radius
       // self.layer.masksToBounds = true
    //}
}






    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


