//
//  BookingViewController.swift
//  PYT
//
//  Created by Niteesh on 06/12/16.
//  Copyright © 2016 appsMaven. All rights reserved.
//

import UIKit
import GoogleMaps
import SDWebImage

class BookingViewController: UIViewController, GMSMapViewDelegate {

    @IBOutlet var scrollContentHeight: NSLayoutConstraint!
    
    @IBOutlet var mapView: GMSMapView!
    @IBOutlet var selectedCounts: UILabel!
    @IBOutlet var selectedLocationName: UILabel!
    
    @IBOutlet var bucketCount: UILabel!
    
    
    
    @IBOutlet var bookingTableView: UITableView!
    
    
    @IBOutlet var bookHotel: UIButton!
    @IBOutlet var bookFlights: UIButton!
    
    
    
    var arrayOfStories = NSMutableArray()
    
    
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        bookHotel.layer.cornerRadius=bookHotel.frame.size.height/2
        bookHotel.layer.borderColor = UIColor (colorLiteralRed: 162/255, green: 200/255, blue: 138/255, alpha: 1).CGColor
        bookHotel.layer.borderWidth = 1.5
        bookHotel.clipsToBounds=true
        
        bookFlights.layer.cornerRadius=bookFlights.frame.size.height/2
        bookFlights.layer.borderColor = UIColor (colorLiteralRed: 162/255, green: 200/255, blue: 138/255, alpha: 1).CGColor
        bookFlights.layer.borderWidth = 1.5
        bookFlights.clipsToBounds=true
        
        
        
        //bookingTableView.estimatedRowHeight =  100.0
        bookingTableView.rowHeight = 110
        
            scrollContentHeight.constant = 330 + bookingTableView.rowHeight * CGFloat(arrayOfStories.count)
          self.view .layoutIfNeeded()
        
        
        
        
       
        
        
        
         selectedCounts.attributedText = attributedTextClass().setAttributeRobotBold("\(arrayOfStories.count)", text1Size: 12, text2: " Places Finalized", text2Size: 12) //  "\(arrayOfStories.count) Places Finalized"
        
        
               
        
        
        
      
        let locationStr = arrayOfStories.objectAtIndex(0).valueForKey("location") as? String ?? ""
        selectedLocationName.attributedText = attributedTextClass().setAttributeRobotBold("\(locationStr)", text1Size: 13, text2: " Bookings", text2Size: 12)   //"\(locationStr) Bookings"
        
        
        
        
        bucketCount.layer.cornerRadius=bucketCount.frame.size.width/2
        bucketCount.clipsToBounds=true
         self.mapView.delegate=self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        NSURLCache.sharedURLCache().removeAllCachedResponses()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK:- Back btn action
    @IBAction func backBtnAction(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
        self.dismissViewControllerAnimated(true, completion: {})
        NSURLCache.sharedURLCache().removeAllCachedResponses()
        
    }
    
    
    @IBAction func bookFlightAction(sender: AnyObject) {
    UIApplication.sharedApplication().openURL(NSURL(string:"https://www.expedia.co.in")!)
    }
    
    @IBAction func bookHotelAction(sender: AnyObject) {
    UIApplication.sharedApplication().openURL(NSURL(string: "https://in.hotels.com/")!)
    
    }
    
    
    
    

    //MARK:- TableView datasource and delgates
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        // #warning Incomplete implementation, return the number of sections
        
        
        return 1
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        
        return arrayOfStories.count
        
        
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        
        let cell:bookingCellClass = tableView.dequeueReusableCellWithIdentifier("bookingCell") as! bookingCellClass
        
        
         let pImage : UIImage = UIImage(named:"backgroundImage")! //placeholder image
        
        let storyImage = arrayOfStories .objectAtIndex(indexPath.row) .valueForKey("imageUrl")! as! NSString
        let url = NSURL(string: storyImage as String)
        
        
        let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in
            //print(self)
            
        }
        
        cell.locationImage.sd_setImageWithURL(url, placeholderImage: pImage, completed: block)
        
        //cell.locationImage.image=UIImage (named: "img5")
        cell.locationImage.contentMode = .ScaleAspectFill
        cell.locationImage.layer.cornerRadius=3
        cell.locationImage.clipsToBounds=true
        
        let locationStr = arrayOfStories.objectAtIndex(indexPath.row).valueForKey("location") as? String ?? ""
        
         var geoTag = arrayOfStories.objectAtIndex(indexPath.row).valueForKey("geoTag") as? String ?? ""
        if geoTag == "" {
            geoTag = locationStr
        }
        
        
        cell.museumName.text=geoTag
        
        
        
//        let segAttributeslabel: NSDictionary = [
//            NSForegroundColorAttributeName: UIColor.init(colorLiteralRed: 32.0/255, green: 47.0/255, blue: 65.0/255, alpha: 1.0).CGColor,
//            NSFontAttributeName: UIFont(name:"Roboto-Bold", size: 12.0)!
//        ]
//        
//        let segAttributeslabel2: NSDictionary = [
//            NSForegroundColorAttributeName: UIColor.init(colorLiteralRed: 32.0/255, green: 47.0/255, blue: 65.0/255, alpha: 1.0).CGColor,
//            NSFontAttributeName: UIFont(name:"Roboto-Light", size: 12.0)!
//        ]
//        
//        
//        
//        
//        let attributedString1 = NSMutableAttributedString(string:"Location:  ", attributes:segAttributeslabel as? [String : AnyObject])
//        let attributedString2 = NSMutableAttributedString(string:"\(locationStr)", attributes:segAttributeslabel2 as? [String : AnyObject])
//        
//        
//        attributedString1.appendAttributedString(attributedString2)
        
        cell.locationLabel.attributedText = attributedTextClass().setAttributeRobotLight("Location: ", text1Size: 12, text2: "\(locationStr)", text2Size: 12) //attributedString1//"Location:\(locationStr)"
        
        
        
        
        
        
        /////set up mapview
        
        /*
        let geoTag = arrayOfStories.objectAtIndex(indexPath.row).valueForKey("geoTag") as? String ?? ""
        let lat = arrayOfStories.objectAtIndex(indexPath.row).valueForKey("latitude") as? String ?? ""
        let long = arrayOfStories.objectAtIndex(indexPath.row).valueForKey("longitude") as? String ?? ""
        
        cell.museumName.text=geoTag
        
        
        if indexPath.row==0 {
            let camera = GMSCameraPosition.cameraWithLatitude(CDouble(lat)!, longitude: CDouble(long)!, zoom: 10)
            mapView.camera = camera
        }
        
        mapView.myLocationEnabled = false
        
        var position = CLLocationCoordinate2DMake(Double(lat)!,Double(long)!)
        let marker = GMSMarker(position: position)
        marker.title=geoTag
        marker.map=mapView
        marker.icon=UIImage (named: "blueMarker")
*/
        
        
        cell.borderView.layer.cornerRadius=4
        cell.borderView.clipsToBounds=true
        cell.borderView.layer.shadowColor = UIColor .lightGrayColor().CGColor
        cell.borderView.layer.shadowOffset = CGSizeMake(0, 2.5)
        cell.borderView.layer.shadowOpacity = 0.7
        cell.borderView.layer.shadowRadius = 1.0
        
        
        let viw = cell.viewWithTag(1515)
        viw?.layer.cornerRadius=3
        viw?.clipsToBounds=true
        
        
        if indexPath.row==arrayOfStories.count-1 {
            self.setPinsInMap()
        }
        
        return cell
        
        
        
        
        
        
        
        
        
        
        
        
    }
    
    ///////////------ End of table View Delegates and Data source ---------///////////////
    

    
    
    /////MARK: Set Pins in map according to distance  ie show all the pins inside map
    //MARK:

    
    func setPinsInMap() -> Void {
        
        
       
        
       mapView.myLocationEnabled = false
        let path = GMSMutablePath()
        
        for i in 0..<arrayOfStories.count {
            
            let latTemp = Double (arrayOfStories.objectAtIndex(i).valueForKey("latitude") as? String ?? "")
            let longTemp = Double(arrayOfStories.objectAtIndex(i).valueForKey("longitude") as? String ?? "")
            let geoTag = arrayOfStories.objectAtIndex(i).valueForKey("geoTag") as? String ?? ""
            
            
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
                path.addCoordinate(CLLocationCoordinate2DMake(latTemp!, longTemp!))
            }
            
            
            
        }
        
        let bounds = GMSCoordinateBounds(path: path)
        self.mapView!.animateWithCameraUpdate(GMSCameraUpdate.fitBounds(bounds, withPadding: 15.0))
        
        
    }
    
    

    
    
    
    
    
    
    
    
    ////////////------ MArker info window custom
    
    func mapView(mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let infoWindow = UIView()
        infoWindow.frame=CGRectMake(0, 0, 180, 30)
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
        titleLabel.frame=CGRectMake(imageIcon.frame.origin.x + 31, 0, 100, 30)
        titleLabel.textColor=UIColor.blackColor()
        infoWindow .addSubview(titleLabel)
        
        
        
        //infoWindow.label.text = "\(marker.position.latitude) \(marker.position.longitude)"
        return infoWindow

    
        
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





class bookingCellClass: UITableViewCell {
    
    @IBOutlet var locationImage: UIImageView!
    @IBOutlet var museumName: UILabel!
    @IBOutlet var locationLabel: UILabel!
    
    @IBOutlet var borderView: UIView!
    
    
}


