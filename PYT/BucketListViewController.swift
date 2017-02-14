//
//  BucketListViewController.swift
//  PYT
//
//  Created by Niteesh on 21/12/16.
//  Copyright © 2016 appsMaven. All rights reserved.
//

import UIKit
import GoogleMaps

import MBProgressHUD

class BucketListViewController: UIViewController, apiClassBucketDelegate, GMSMapViewDelegate {

    
    
    @IBOutlet weak var heightOfscrollContant: NSLayoutConstraint!
    
    //List of items in bucket
    @IBOutlet weak var bucketListTable: UITableView!
    @IBOutlet weak var ListLabel: UILabel!
    @IBOutlet weak var bucketCountLabel: UILabel!
    
    
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var bucketIndicator: UIActivityIndicatorView!
    
    var uId = ""
    var bucketArray = NSMutableArray()
    var locationArray = NSMutableArray()
    var deleteBool = Bool()
    
    
    override func viewDidLoad() {
        
        self.tabBarController?.tabBar.hidden = true
        
        super.viewDidLoad()

        bucketListTable.rowHeight=100
        
        heightOfscrollContant.constant = self.view.frame.size.height //245+bucketListTable.rowHeight*7
        
        // Do any additional setup after loading the view.
        
        
        ListLabel.attributedText=attributedTextClass().setAttributeRobotBold("Bucket", text1Size: 12, text2: " List", text2Size: 12)
        
        
        bucketCountLabel.attributedText=attributedTextClass().setAttributeRobotBold(" ", text1Size: 12, text2: " Places Bucketed", text2Size: 12)
        
        
        bucketListTable.hidden=true
       bucketIndicator.hidden=false
        bucketIndicator.startAnimating()
        
        bucketListApiClass.sharedInstance().delegate=self
        
        mapView.delegate=self
        
        let defaults = NSUserDefaults.standardUserDefaults()
         uId = defaults .stringForKey("userLoginId")!
        print(uId)
        
        let perameter = "userId=\(uId)"
        
        bucketListApiClass.sharedInstance().postRequestForGetBucketList(perameter, viewController: self)
        deleteBool=false
        
        
        
        
    }

    
    
    //MARK:- Back Button Action
    
    @IBAction func backButtonAction(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
        
        
    }
    
    
    
    
    
    
    
    func serverResponseArrivedBucket(Response:AnyObject)
    {
        
        
        if deleteBool == true {
            
            let perameter = "userId=\(uId)"
            bucketListTable.hidden=true
            bucketIndicator.hidden=false
            bucketIndicator .startAnimating()

            bucketListApiClass.sharedInstance().postRequestForGetBucketList(perameter, viewController: self)
            deleteBool=false
            //delete data manage here
            
        }
        
        
        
        
        
        
        
        
        
        
        ///get all bucket list
        else
        {
        
        jsonResult = NSDictionary()
        
        jsonResult = Response as! NSDictionary
        
        print(jsonResult)
        
        let status = jsonResult.valueForKey("status") as! NSNumber
        if status == 1 {
            
            bucketArray = jsonResult.valueForKey("bucketData")?.valueForKey("bucket") as! NSMutableArray
            
            if bucketArray.count<1 {
                
                 CommonFunctionsClass.sharedInstance().alertViewOpen("No Bucketed List Found !!!", viewController: self)
                
                bucketCountLabel.attributedText=attributedTextClass().setAttributeRobotBold(" ", text1Size: 12, text2: " Places Bucketed", text2Size: 12)
                bucketIndicator.hidden=true
                
            }
            else{
                
                let countBkt = jsonResult.valueForKey("bucketData")?.valueForKey("bucketcount") as! NSNumber
                print(countBkt)
                
                let stCoun = "\(countBkt)"
                
                
                bucketCountLabel.attributedText=attributedTextClass().setAttributeRobotBold(stCoun, text1Size: 12, text2: " Places Bucketed", text2Size: 12)
                
                
                
                
                
                
                bucketListTable.hidden=false
                 mapView .clear()
                bucketListTable .reloadData()
               
                bucketIndicator.hidden=true
                
                bucketIndicator.stopAnimating()
                heightOfscrollContant.constant = 245+bucketListTable.rowHeight * CGFloat(bucketArray.count)
            }
            
            
            
        }
        else{
            bucketCountLabel.attributedText=attributedTextClass().setAttributeRobotBold(" ", text1Size: 11, text2: " Places Bucketed", text2Size: 11)
            
            CommonFunctionsClass.sharedInstance().alertViewOpen("No Bucketed List Found !!!", viewController: self)
            
        }
        
        }
        
        
        
        
        
    }
    
    
    
    
    
    
    
    //MARK:-
    //MARK:- TableView datasource and delgates
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
            return bucketArray.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        
            let cell = tableView.dequeueReusableCellWithIdentifier("bucketTableCell") as! bucketCellClass
        
            
        cell.shadowView.layer.cornerRadius=6
       // cell.shadowView.clipsToBounds=true
        cell.shadowView.layer.shadowColor = UIColor .lightGrayColor().CGColor
        cell.shadowView.layer.shadowOffset = CGSizeMake(0, 2.0)
        cell.shadowView.layer.shadowOpacity = 0.7
        cell.shadowView.layer.shadowRadius = 1.0
        
        
        cell.storyLocationName.text = bucketArray.objectAtIndex(indexPath.row).valueForKey("country") as? String ?? ""
        
       
        
        self.getLatLong(cell.storyLocationName.text!)
        
         return cell
        
    }
    
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        
        let deleteAction = UITableViewRowAction(style: .Default, title: "Delete") {action in
            
          
            let country = self.bucketArray.objectAtIndex(indexPath.row).valueForKey("country") as? String ?? ""
            
            
                
            
            let idImages = self.bucketArray.objectAtIndex(indexPath.row).valueForKey("countryImages") as! NSArray
            print(idImages)
            
            let strImg = idImages.componentsJoinedByString(",")
            print(strImg)
            
           let parameter = "userId=\(self.uId)&country=\(country)&imageId=\(strImg)"
            
            
            print(parameter)
            
             MBProgressHUD.showHUDAddedTo(self.view, animated: true)
           
            
            bucketListApiClass.sharedInstance().postRequestForDeletBucketList(parameter, viewController: self)
            
            //  self.arrayOfIntrest .removeObjectAtIndex(indexPath.row)
                //self.adjustHeightOftableView()
                
                self.deleteBool=true
            
        
        }
        
        
        return [deleteAction]
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
       
            return true
       
        
    }

    
    
    
    
    
    
    
    
    //MARK:- Api for lat long
    
    func getLatLong(parameterString : String)
    {
        
        
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
            
            
            
            let urlString = NSString(string:"http://maps.google.com/maps/api/geocode/json?sensor=false&address=\(parameterString)")
            
            
          
            
            
            let needsLove = urlString
            let safeURL = needsLove.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
            
            let url:NSURL = NSURL(string: safeURL as String)!
            print("Final Url-----> " + (safeURL as String))
            
            
            
            
            let session = NSURLSession.sharedSession()
           
            
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "GET"
            request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
            
          
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {(response, data, error) in
              
                
                NSOperationQueue.mainQueue().addOperationWithBlock
                    {
                        
                        
                        if data == nil
                        {
                            
                        }
                        else
                        {
                            
                            
                            //  dispatch_async(dispatch_get_main_queue(), {
                            
                            do {
                                
                                
                               
                                
                                let anyObj: AnyObject = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                                
                                jsonResult = NSDictionary()
                                
                                jsonResult = anyObj as! NSDictionary
                                
                               // print(jsonResult)
                                
                                let resltArr = jsonResult.valueForKey("results") as! NSMutableArray
                                
                                if resltArr.count > 0{
                                    
                                    print(resltArr.objectAtIndex(0).valueForKey("geometry")?.valueForKey("location"))
                                    
                            let address = resltArr.objectAtIndex(0) .valueForKey("formatted_address") as? String ?? " "
                                    
                                    
                        let latitude = resltArr.objectAtIndex(0) .valueForKey("geometry")?.valueForKey("location")?.valueForKey("lat") as! NSNumber
                    let longitude = resltArr.objectAtIndex(0) .valueForKey("geometry")?.valueForKey("location")?.valueForKey("lng") as! NSNumber
                                 
                             
                                    
                                    print(latitude)
                                    print(longitude)
                                    
                                    
                                    self.locationArray .addObject(["address": address, "latitude": "\(latitude)", "longitude": "\(longitude)"])
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                }
                                
                                
                                
                               
                                
                                
                                
                            } catch {
                               
                            }
                            
                            
                            
                            
                            
                            
                        }
                        
                        
                        self.setPinsInMap()
                        
                        
                }
                
            }
            
            
            
            
        }
       
        
        
        
        
       
        
        
        
        
        
    }

    
    
    
    //MARK:- Set the pins
    
    func setPinsInMap() -> Void {
        
        mapView.myLocationEnabled = false
        let dataArray = locationArray
        
        // print(dataArray.valueForKey("latitude"))
        let path = GMSMutablePath()
        
        for i in 0..<dataArray.count {
            
            let latTemp = Double (dataArray.objectAtIndex(i).valueForKey("latitude") as? String ?? "")
            let longTemp = Double(dataArray.objectAtIndex(i).valueForKey("longitude") as? String ?? "")
            let geoTag = dataArray.objectAtIndex(i).valueForKey("address") as? String ?? ""
            
            
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
     
        self.mapView.moveCamera(cameraUpdate)
        
        
        
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

    class bucketCellClass: UITableViewCell {
        
        
        @IBOutlet weak var storyLocationName: UILabel!
        
        @IBOutlet weak var shadowView: UIView!
        
        @IBOutlet weak var locationImage: UIImageView!
        
        
        
        
        
        
}


