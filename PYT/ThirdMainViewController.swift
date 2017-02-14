
//
//  ThirdMainViewController.swift
//  PYT
//
//  Created by Niteesh on 10/08/16.
//  Copyright © 2016 appsMaven. All rights reserved.
//

import UIKit
import SDWebImage
import ImageSlideshow
class ThirdMainViewController: UIViewController, UIGestureRecognizerDelegate, KASlideShowDelegate {

   
    
    
    
    
    var passedData = NSMutableArray()
     let baseUrlHotels = "http://terminal2.expedia.com/x/mhotels/search?"
    let baseURL = "\(appUrl)search_category_latest/" //live url
    
   // let baseURL = "http://35.163.56.71/search_category_latest/"//test url

    
    @IBOutlet var intrestTableView: UITableView!
   
    
    @IBOutlet var mainView: UIView!
    @IBOutlet var detailView: UIView!
    @IBOutlet var detailScrollView: UIScrollView!
    @IBOutlet var detailScrollContentView: UIView!
    @IBOutlet var detailTableView: UITableView!
   
    @IBOutlet var heightOfTable: NSLayoutConstraint!
    
    @IBOutlet var heightOfScrollContentView: NSLayoutConstraint!
    
    @IBOutlet var slideImageView: ImageSlideshow!
    
  
   
    @IBOutlet var textfromFoursquare: UILabel!
    
    @IBOutlet var webLinkOutLet: UIButton!
    
   
    
    @IBOutlet var hotelNameText: UITextView!
    @IBOutlet var hotelAddressLbl: UILabel!
    @IBOutlet var citylbl: UILabel!
    @IBOutlet var countryLbl: UILabel!
    @IBOutlet var contactLbl: UILabel!
    @IBOutlet var contactButtonLbl: UIButton!
    
    @IBOutlet var categoryLbl: UILabel!
    
    @IBOutlet var cameraBtnOutlet: UIButton!
    
    
    
    
    @IBOutlet var UserImageView: UIImageView!
    @IBOutlet var locationLblDetail: UILabel!
    @IBOutlet var geoTag: UILabel!
    
    @IBOutlet var detailSubView: UIView!
    
    
    
    
    var dataArray = NSMutableArray()
    var hotelImagesArray = NSMutableArray()
    var dataWithCategory = NSMutableArray()
    var parameterString = ""
    var webLinkString = NSString()
    
     var sdWebImageSource = [InputSource]()
    
   
    
    
    
    override func viewWillAppear(animated: Bool) {
        
        NSURLCache.sharedURLCache().removeAllCachedResponses()//clear cache
        
        //---- manage view behind the status and navigation bar----////
        
        self.edgesForExtendedLayout = UIRectEdge .None
        self.extendedLayoutIncludesOpaqueBars=false
        self.automaticallyAdjustsScrollViewInsets = false// adjust navigation bar
        
        self.navigationController?.navigationBarHidden=true //hide navigation bar
        self.tabBarController?.tabBar.hidden = true
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //---- manage view behind the status and navigation bar----////
        
//        self.edgesForExtendedLayout = UIRectEdge .None
//        self.extendedLayoutIncludesOpaqueBars=false
//        self.automaticallyAdjustsScrollViewInsets = false// adjust navigation bar
        
        navigationController?.interactivePopGestureRecognizer?.enabled = false
      
        
        
        
      //  print(passedData)
        print(passedData.count)
        
        
        let idArr = NSMutableArray()
        
        
        for i in 0..<passedData.count {
            
            var category = passedData .objectAtIndex(i) .valueForKey("category") as? NSString ?? "Empty"
            
            if category=="" {
                category="PYT"
            }
            
            let catArr = NSMutableArray()
            catArr .addObject(category)
            let swiftArray = catArr as NSArray as! [String]//change mutable array to array
            let stringRepresentation1 = swiftArray .joinWithSeparator(",")
          //  print(stringRepresentation1)
            
            var finalStr = String()
          //  if i==passedData.count-1 {
                 //finalStr = "\(passedData .objectAtIndex(i) .valueForKey("id") as! String)-\(stringRepresentation2)"
           // }
           // else{
            
             finalStr = "\(passedData .objectAtIndex(i) .valueForKey("id") as! String)-\(stringRepresentation1)"
           // }
            
            idArr .addObject(finalStr)
            
        
        }
        
        print(idArr)
        
        let swiftArray = idArr as NSArray as! [String]//change mutable array to array
        let stringRepresentation2 = swiftArray .joinWithSeparator("~")
        print(stringRepresentation2)
        
        

        
        let type = passedData .objectAtIndex(0).valueForKey("type") as? NSString ?? "Empty"
        let destinationname = passedData .objectAtIndex(0) .valueForKey("location") as? NSString ?? "Empty"

        
        
        
        //String for hit the api to get categories data
        parameterString = NSString(string:"\(stringRepresentation2)/\(destinationname)/\(type)") as String
        
        
        print(parameterString)
        
        
        //self .getHotels(parameterString)
        
        
        
        
        
        
    
        
        //////Gradient background color
        
        let layer = CAGradientLayer()
        layer.frame = CGRect(x: 0, y: 0, width: mainView.frame.size.width, height: self.view.frame.origin.y+self.view.frame.size.height)
        let blueColor = UIColor(red: 0/255, green: 146/255, blue: 198/255, alpha: 1.0).CGColor as CGColorRef
        let purpleColor = UIColor(red: 117/255, green: 42/255, blue: 211/255, alpha: 1.0).CGColor as CGColorRef
        layer.colors = [purpleColor, blueColor]
        layer.startPoint = CGPoint(x: 0.1, y: 0.5)
        layer.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        layer.locations = [0.25,1.0]
        self.view.layer.addSublayer(layer)
        self.view .bringSubviewToFront(mainView)
        self.view .bringSubviewToFront(intrestTableView)
       self.view.bringSubviewToFront(cameraBtnOutlet)
        
        
        webLinkOutLet.layer.cornerRadius=webLinkOutLet.frame.size.height/2-1
        webLinkOutLet.clipsToBounds=true

        
        
        
        let widthTotal = self.view.frame.size.width / 2
            self.intrestTableView.rowHeight = widthTotal + 65
        
       
        cameraBtnOutlet.layer.cornerRadius=cameraBtnOutlet.frame.size.width/2
        cameraBtnOutlet.clipsToBounds=true
        
        
        self.intrestTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        
        
        
        
        let tempView = UIView()
        tempView.frame=self.view.frame
        tempView.backgroundColor=UIColor .whiteColor()
        self.view .addSubview(tempView)
        
        
        let alertLbl = UILabel()
        alertLbl.text = "Thanks for selection, You will be navigated to a story in few days."
        alertLbl.textColor = UIColor .blackColor()
        alertLbl.frame = CGRectMake(tempView.frame.size.width/2-130, tempView.frame.size.height/2-150, 260, 300)
        alertLbl.adjustsFontSizeToFitWidth=true
        alertLbl.lineBreakMode = .ByWordWrapping
        alertLbl.numberOfLines=0
        tempView .addSubview(alertLbl)
        
        //self.view .bringSubviewToFront(tempView)
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), {() -> Void in
            
            self.navigationController! .popViewControllerAnimated(true)
            
             })
        
        
        
    }

    
    //MARK:- BAckBtn Action
    
    @IBAction func backAction(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
        self.dismissViewControllerAnimated(true, completion: {})
        
    }
    
    
        //pop back to previous view controller
        func navigationAction() -> Void
        {
            self.navigationController?.popViewControllerAnimated(true)
        }
    
    
    
      /// disable the side menu after logout
       func sideMenuShouldOpenSideMenu() -> Bool
       {
        return false;
       }
    
    
    
    
    
    
    

    
    
    
    
    // MARK: - KASlideShow delegate
    
    func kaSlideShowWillShowNext(slideshow: KASlideShow) {
        NSLog("kaSlideShowWillShowNext")
    }
    
    func kaSlideShowWillShowPrevious(slideshow: KASlideShow) {
        NSLog("kaSlideShowWillShowPrevious")
    }
    
    func kaSlideShowDidShowNext(slideshow: KASlideShow) {
        NSLog("kaSlideShowDidNext")
    }
    
    func kaSlideShowDidShowPrevious(slideshow: KASlideShow) {
        NSLog("kaSlideShowDidPrevious")
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //MARK:- tableView delegates and data source
    //MARK:-
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return 1
        
    }
    
    
    //section header view ////
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        let cell:ThirdPageHeaderTableViewCell = tableView.dequeueReusableCellWithIdentifier("customHeaderInSection") as! ThirdPageHeaderTableViewCell
        //for use in future
        return cell.contentView
    }

    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataWithCategory.count
        
    }
    

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 0
    }
    
    
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
//    {
//        return 220.0;//Choose your custom row height
//    }
    
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //cellHome
        
        let cell:thirdPageTableViewCell = tableView.dequeueReusableCellWithIdentifier("customCell")! as! thirdPageTableViewCell
        
        
        
        
        // let pImage : UIImage = UIImage(named:"backgroundImage")!
        
        
        cell.categoryLabel.text = self.captitalString(self.dataWithCategory.objectAtIndex(indexPath.row).valueForKey("category") as? String ?? "" )  //self.dataWithCategory[indexPath.row].valueForKey("category") as? String
       // cell.categoryImage.image = ""
        
        
        if (cell.categoryLabel.text=="random") || (cell.categoryLabel.text=="Random"){
            cell.categoryImage.image = UIImage (named: "city")
        }
      
            //Child Friendly
        else if (cell.categoryLabel.text=="child friendly") || (cell.categoryLabel.text=="Child Friendly"){
            cell.categoryImage.image=UIImage (named: "entertainment")
        }
            
        else if (cell.categoryLabel.text=="food") || (cell.categoryLabel.text=="Food"){
            cell.categoryImage.image=UIImage (named: "food_and_drink")
        }
            
        else if (cell.categoryLabel.text=="relaxation") || (cell.categoryLabel.text=="Relaxation"){
            cell.categoryImage.image=UIImage (named: "Adventure")
        }
            
            
        else if (cell.categoryLabel.text=="nightlife") || (cell.categoryLabel.text=="Nightlife"){
            cell.categoryImage.image=UIImage (named: "Adventure")
        }
            
            
        else if (cell.categoryLabel.text=="sports") || (cell.categoryLabel.text=="Sports"){
            cell.categoryImage.image=UIImage (named: "culture")
        }
            
            
        else if (cell.categoryLabel.text=="history") || (cell.categoryLabel.text=="History"){
            cell.categoryImage.image=UIImage (named: "Adventure")
        }
            
            
        
       else if (cell.categoryLabel.text=="road trips") || (cell.categoryLabel.text=="Road Trips"){
            cell.categoryImage.image=UIImage (named: "city")
        }
        
       else if (cell.categoryLabel.text=="cruises") || (cell.categoryLabel.text=="Cruises"){
            cell.categoryImage.image=UIImage (named: "Cruises")
        }
        
       else if (cell.categoryLabel.text=="entertainment") || (cell.categoryLabel.text=="Entertainment"){
            cell.categoryImage.image=UIImage (named: "entertainment")
        }
        
       else if (cell.categoryLabel.text=="restaurants") || (cell.categoryLabel.text=="Restaurants"){
            cell.categoryImage.image=UIImage (named: "food_and_drink")
        }
        
       else if (cell.categoryLabel.text=="shopping") || (cell.categoryLabel.text=="Shopping"){
            cell.categoryImage.image=UIImage (named: "Adventure")
        }
        
       else if (cell.categoryLabel.text=="adventure") || (cell.categoryLabel.text=="Adventure"){
            cell.categoryImage.image=UIImage (named: "Adventure")
        }
        
       else if (cell.categoryLabel.text=="architecture") || (cell.categoryLabel.text=="Architecture"){
            cell.categoryImage.image=UIImage (named: "architecture")
        }
        
        
       else if (cell.categoryLabel.text=="mountains") || (cell.categoryLabel.text=="Mountains"){
            cell.categoryImage.image=UIImage (named: "mountains")
        }
        
       else if (cell.categoryLabel.text=="beaches") || (cell.categoryLabel.text=="Beaches"){
            cell.categoryImage.image=UIImage (named: "beaches")
        }
        
       else if (cell.categoryLabel.text=="culture") || (cell.categoryLabel.text=="culture"){
            cell.categoryImage.image=UIImage (named: "culture")
        }
            
            
        else if (cell.categoryLabel.text=="city tours") || (cell.categoryLabel.text=="City Tours"){
            cell.categoryImage.image=UIImage (named: "culture")
        }
            
        
        else{
            
            cell.categoryImage.image=UIImage (named: "Adventure")
            
        }
        
        
        
        
        
        
        
        
            return cell
    
    }
    
    
    
  
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
      
    }
    
    

    
    //MARK:- Actions of Buttons in Detail View
    
    @IBAction func closeBtnDetailView(sender: AnyObject) {
        let transition:CATransition = CATransition()
        transition.duration = 0.4
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromBottom
        
        self.detailView!.layer.addAnimation(transition, forKey: kCATransition)
        self.detailView.hidden = true
        
        

    }
    
    
    @IBAction func selectBtnDetailView(sender: AnyObject) {
        let transition:CATransition = CATransition()
        transition.duration = 0.4
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromBottom
        
        self.detailView!.layer.addAnimation(transition, forKey: kCATransition)
        self.detailView.hidden = true
    

    }
    
    
    @IBAction func webLinkBtnDetailView(sender: AnyObject) {
    
        print(webLinkString)
          UIApplication.sharedApplication().openURL(NSURL(string: webLinkString as String)!)
        
    }
    
    
    
   
    @IBAction func contactBtnAction(sender: AnyObject) {
       
        let phone = "tel://\(self.contactButtonLbl.titleLabel!.text!)";
        let url:NSURL = NSURL(string:phone)!;
        UIApplication.sharedApplication().openURL(url);
        
        
        
    }
    
    
    

    @IBAction func postPictureAction(sender: AnyObject) {
        
        let nxtObj = self.storyboard?.instantiateViewControllerWithIdentifier("imagePostViewController") as! imagePostViewController
        
       dispatch_async(dispatch_get_main_queue(), {
            self.navigationController! .pushViewController(nxtObj, animated: true)
       })
       
        
    }
    
    
    
    //MARK:-Capital the all strings
    //MARK:- 
    
    //self.captitalString(arrayCountry[b!] as? String ?? ""
    func captitalString(nameString:NSString) -> String {
        
        var nameString2 = nameString
        nameString2 = nameString.capitalizedString
        return nameString2 as String
        
    }
    
    
    
    
    
        
    
    
    
    //MARK:- APi for get hotels EXPEDIA
    //MARK:-
    
    func getHotels(parameterString : String)
    {
        
        //["id": imageId, "imageLink": imageName2, "description": desc, "category":categ, "location":globalLocation, "type":globalType])
        
        
        
        
        
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
            
            // indicatorClass.sharedInstance().showIndicator("Connecting To Facebook, Please wait...")
            
            let urlString = NSString(string:"\(baseURL)\(parameterString)")
            print("WS URL----->>" + (urlString as String))
            
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
                       
                        
                        
                        
                        if data == nil
                        {
                            indicatorClass.sharedInstance().hideIndicator()
                            CommonFunctionsClass.sharedInstance().alertViewOpen("Server is not responding", viewController: self)
                             indicatorClass.sharedInstance().hideIndicator()
                        }
                        else
                        {
                            
                            //let result = NSString(data: data!, encoding:NSASCIIStringEncoding)!
                            
                           // print("Body: \(result)")
                            
                           // let jsonResult: AnyObject = try! NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.MutableContainers)
                            
                            do {
                                
                                
                                 let Response: AnyObject = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                               
                                jsonResult = NSDictionary()
                                jsonResult = Response as! NSDictionary
                                
                                
                                
                                
                                
                                let success = jsonResult.objectForKey("status") as! NSNumber
                                if success == 1
                                {
                                    self.dataArray = jsonResult .valueForKey("data")! as! NSMutableArray
                                    print(self.dataArray.count)
                                    
                                    // here data have been getting ino the arrays after get from server
                                    
                                    for i in 0 ..< self.dataArray.count
                                    {
                                        //print(self.dataArray .objectAtIndex(i))
                                        
                                    let categoryString = self.dataArray .objectAtIndex(i) .valueForKey("category")
                                       // print(categoryString!)
                                        
                                        var dataCategory = NSMutableArray()
                                        
                                        
                                        
                                        dataCategory = self.dataArray[i].valueForKey("data") as! NSMutableArray
                                        
                                        
                                        
                           let finalArrayCat = NSMutableArray() //add the category type photos
                                        
                                        for j in 0 ..< dataCategory.count {
                                            
                                          //  print(dataCategory[j])
                                           // print(dataCategory[j].valueForKey("name"))
                                            
                                            var photos = []
                                            photos = [dataCategory[j].valueForKey("photos")!]
                                            //print(photos[0].valueForKey("city"))
                                            
                                            var imageString = NSString()
                                            var locationCity = NSString()
                                            var locationCountry = NSString()
                                            var idString = NSString()
                                            var descriptionString = NSString()
                                            var nameString = NSString()
                                            var geoTagString = NSString()
                                            
                                            
                                            
                            imageString = photos[0].valueForKey("imageLarge") as? String ?? ""
                            locationCity = photos[0].valueForKey("city") as? String ?? ""
                            locationCountry = photos[0].valueForKey("country") as? String ?? ""
                            idString = photos[0].valueForKey("_id") as? String ?? ""
                            descriptionString = photos[0].valueForKey("description") as? String ?? ""
                            nameString = dataCategory[j].valueForKey("name") as? String ?? ""
                            geoTagString = photos[0].valueForKey("placeTag") as? String ?? ""
                                            
                                            let dict:NSDictionary = ["imageLink":imageString, "city": locationCity, "country": locationCountry, "id": idString, "description": descriptionString, "userName": nameString, "geoTag": geoTagString]
                                            
                                           // print(dict)
                                            
                                            
                                        
                                            finalArrayCat .addObject(dict)
                                            
                                            
                                            
                                        }
                                        
                                        if finalArrayCat.count>=1
                                        {
                                          self.dataWithCategory .addObject(["category": categoryString as! String, "data":finalArrayCat])
                                        }
                                      
                                        
                                        
                                        
                                        
                                     

                                        
                                            
                                        }
                                        
                                 
                                    self.reloaddata()
                                    
                                    
                                    indicatorClass.sharedInstance().hideIndicator()
                                    
                                }
                                    
                                        
                                     
                                    
                                
                                else{
                                    
                                    
                                    print("No location found")
                                    
                                    
//                                    self.reloaddata()
//
//                                    
//                                    indicatorClass.sharedInstance().hideIndicator()
                                    
                                    
                                }
                                
                                
                                
                                
                                
                                
                            }
                                catch {
                                print("json error: \(error)")
                                CommonFunctionsClass.sharedInstance().alertViewOpen("Sorry there is some issue in backend, Please try again", viewController: self)
                                indicatorClass.sharedInstance().hideIndicator()
                            }
                            

                            

                        }
                }
                
            })
            
            task.resume()
        }
        else
        {
            indicatorClass.sharedInstance().hideIndicator()
            CommonFunctionsClass.sharedInstance().alertViewOpen("Please Check Internet Connection", viewController: self)
        }
    }
    
    
    
    
    
    //MARK:- Add selected photos to table


    func reloaddata() {
        
        
        
        dispatch_async(dispatch_get_main_queue(), {
          
                self.intrestTableView .reloadData()
            
            indicatorClass.sharedInstance().hideIndicator()
        })

        
        
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


extension ThirdMainViewController : UITableViewDelegate {
    
    func tableView(tableView: UITableView,willDisplayCell cell: UITableViewCell,forRowAtIndexPath indexPath: NSIndexPath) {
        
        guard let tableViewCell = cell as? thirdPageTableViewCell else { return }
        //here setting the uitableview cell contains collectionview delgate conform to viewcontroller
        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row, andForSection: indexPath.section)
    }
    
    
    
}



extension ThirdMainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView,numberOfItemsInSection section: Int) -> Int {
       // print(dataWithCategory .valueForKey("data")[collectionView.tag].valueForKey("images")?.count)
        return (dataWithCategory .valueForKey("data")[collectionView.tag].valueForKey("images")?.count)!
    }
    
    func collectionView(collectionView: UICollectionView,cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ThirdPagecellCollectionView",forIndexPath: indexPath)
         cell.layer.cornerRadius=5
        cell.clipsToBounds=true
        
        dispatch_async(dispatch_get_main_queue(), {
            
            var imageName = NSString()
            var userNameForLoc = NSString()
            
            
            let totalData:NSArray = self.dataWithCategory .valueForKey("data")[collectionView.tag].valueForKey("imageLink") as! NSArray
        
        
            if (totalData.count<1 )
            {}
            else
            {
            
                var arrImg = NSArray()
                arrImg = self.dataWithCategory .valueForKey("data")[collectionView.tag].valueForKey("imageLink") as! NSArray
                
                
                imageName = arrImg[indexPath.row] as! String
            //    print(imageName)
                
               
            
            
            
        let locationImage = cell.viewWithTag(2000) as! UIImageView
         locationImage.contentMode = .ScaleAspectFill
               
                let url = NSURL(string: imageName as String)
                
                let pImage : UIImage = UIImage(named:"backgroundImage")! //placeholder image
                
                
                let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
                cell.backgroundView = activityIndicatorView
                //self.view.bringSubviewToFront(cell.backgroundView!)
                activityIndicatorView.startAnimating()
                
                let block2: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in
                   
                    
                }
                //completion block of the sdwebimageview
                locationImage.sd_setImageWithURL(url, placeholderImage: pImage, completed: block2)
                
                locationImage.clipsToBounds=true
                
                
        
        
                
               // var arrayName = NSArray()
               // arrayName = self.dataWithCategory .valueForKey("data")[collectionView.tag].valueForKey("name") as! NSArray
                userNameForLoc = "" //arrayName[indexPath.row] as? String ?? "NA"
                
                var geoTagLoc = NSArray()
                geoTagLoc = self.dataWithCategory .valueForKey("data")[collectionView.tag].valueForKey("geoTag") as! NSArray
                let tagGeo = geoTagLoc[indexPath.row] as? String ?? " "
                
                
        let locName = cell.viewWithTag(2001) as! UILabel
                locName.text=tagGeo as String
        locName.sizeToFit()
                
                locName.layoutIfNeeded()
                
       // let userName = cell.viewWithTag(2002) as! UILabel//been there
      //  userName.text = userNameForLoc as String
        
         
                var arrayLoc = NSArray()
                arrayLoc = self.dataWithCategory .valueForKey("data")[collectionView.tag].valueForKey("city") as! NSArray
               var LocationUser = arrayLoc[indexPath.row] as? String ?? ""
                
                if LocationUser == ""{
                    
                    var arrayLocCountry = NSArray()
                    arrayLocCountry = self.dataWithCategory .valueForKey("data")[collectionView.tag].valueForKey("country") as! NSArray
                     LocationUser = arrayLocCountry[indexPath.row] as? String ?? ""
                    
                }
                
                
                
                
                

                
        let location = cell.viewWithTag(2003) as! UILabel
        
                location.text = LocationUser as String
            }
        
            })
        
        
        
        
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        
        
        print("collectionviewtag:\(collectionView.tag) +  indexpathrow:\(indexPath.row)")
        //from here you can do push or present to anyview controller
        // collectionviewtag is tableView cell row value and indexpathrow return collectionView cell row value.
        
        
        var geoTagLoc = NSArray()
        geoTagLoc = self.dataWithCategory .valueForKey("data")[collectionView.tag].valueForKey("geoTag") as! NSArray
        let tagGeo = geoTagLoc[indexPath.row] as? String ?? " "
        geoTag.text = self.captitalString(tagGeo as String)
        geoTag.numberOfLines=0
       geoTag.adjustsFontSizeToFitWidth=true
        geoTag.lineBreakMode = .ByWordWrapping
        geoTag.clipsToBounds=true
        
        
        var arrayLoc = NSArray()
        arrayLoc = self.dataWithCategory .valueForKey("data")[collectionView.tag].valueForKey("city") as! NSArray
        var LocationUser = arrayLoc[indexPath.row] as? String ?? ""
        
        if LocationUser == ""{
            
            var arrayLocCountry = NSArray()
            arrayLocCountry = self.dataWithCategory .valueForKey("data")[collectionView.tag].valueForKey("country") as! NSArray
            LocationUser = arrayLocCountry[indexPath.row] as? String ?? ""
            
        }
        
        locationLblDetail.text = self.captitalString(LocationUser)
        
        
        var parameter = NSString()
        
        parameter = "https://api.foursquare.com/v2/venues/search?intent=browse&limit=1&client_id=DAKFO3TURLDTUL33JNPRTIGX03NMZM2ACCDWC2HHHZTV2YMT&client_secret=ILF0G3U4DRSC0WDW2EH12SFGTOKIWSKFUIOXV4FFEQOIB34B&v=20140203&near=\(LocationUser)&query=\(tagGeo)"
        
        print(parameter)
        
        
        var arrImg = NSArray()
        arrImg = self.dataWithCategory .valueForKey("data")[collectionView.tag].valueForKey("imageLink") as! NSArray
        
        
        let imageName:NSString = arrImg[indexPath.row] as! String
       // print(imageName)
        
       
        hotelImagesArray = NSMutableArray()
        hotelImagesArray .addObject(imageName)
        
        
      //  UserImageView.sd_setImageWithURL(NSURL(string: imageName as String), placeholderImage:UIImage(named: "logo"))
        
       
        self.hotelNameText.text=""
        self.hotelAddressLbl.text=""
        self.citylbl.text=""
        self.countryLbl.text=""
        self.contactButtonLbl .setTitle("", forState: UIControlState .Normal)
        self.categoryLbl.text=""
        
    
        self.sdWebImageSource = [InputSource]()
        self.slideImageView.slideshowInterval = 0
        self.slideImageView.pageControlPosition = PageControlPosition.InsideScrollView
        self.slideImageView.pageControl.currentPageIndicatorTintColor = UIColor.lightGrayColor();
        self.slideImageView.pageControl.pageIndicatorTintColor = UIColor.blackColor();
        self.slideImageView.contentScaleMode = UIViewContentMode.ScaleToFill
        self.slideImageView.circular=false
        self.slideImageView.setCurrentPageForScrollViewPage(0)
        
        let imgLink = self.hotelImagesArray[0] as! String
        
        sdWebImageSource.append(SDWebImageSource(urlString: imgLink as String)!)
        
        self.slideImageView.setImageInputs(sdWebImageSource )
        
        
      
        
        
        self .showView()
        
        self.getHotelsDetail(parameter as String)
        
        
        
        
        
        
}
    
    
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
//        let width1 = collectionView.frame.size.width/2.30  //1.8
//        let height2 = collectionView.frame.size.height - 5
//        return CGSize(width: width1, height: height2) // The size of one cell

    
        let width1 = collectionView.frame.size.width/1.50  //1.8
        
        
        
         let height2 = self.intrestTableView.rowHeight - 65
        return CGSize(width: width1, height: height2) // The size of one cell
    
    
    
    }
    

    
    
    //MARK:- Open the detail view on the tap of cell in collectionView
    
    
    func showView() -> Void {
        
        //self.view .bringSubviewToFront(detailView)
        
      
        //MARK:- Images Slide Show
      
        
      

        
        
        
        self.detailScrollView .setContentOffset(CGPointZero, animated: true)
        
        let transition:CATransition = CATransition()
        transition.duration = 0.4
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromTop
        
        self.detailView!.layer.addAnimation(transition, forKey: kCATransition)
        
        self.detailView.hidden = false
        //self.detailView.frame = self.mainViewWithGradient.frame
        self.view .bringSubviewToFront(self.detailView)
       
       
        
        
        var height = CGFloat(self.view.frame.size.height + 170)
        
        if height < 760 {
            
            height = 800+self.hotelNameText.frame.height
            
        }
        
        
        
        
        self.heightOfScrollContentView.constant = height
        
        self.detailScrollContentView .setNeedsLayout()
        
        
        
        
        
        
        
            }
    
    
    
    
 
    //MARK:- Get detail of thehotel from foursquare Api
    //MARK:-
    
     func getHotelsDetail(parameterStringHotels : String)
     {
     
     let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
     
     if isConnectedInternet
     {
     
        
        
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
      
        detailSubView .bringSubviewToFront(activityIndicatorView)
        activityIndicatorView.startAnimating()
      activityIndicatorView.frame=CGRectMake(detailSubView.frame.size.width/2, detailSubView.frame.size.height/2-20, 40, 40)
        
        detailSubView .addSubview(activityIndicatorView)
  
        
        
    
     
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
        
        activityIndicatorView .removeFromSuperview()
        
     }
     else
     {
     
     let result = NSString(data: data!, encoding:NSASCIIStringEncoding)!
     
       activityIndicatorView .removeFromSuperview()

     
     let jsonResult: AnyObject = try! NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.MutableContainers)
     
     var resultHotels = NSDictionary()
     resultHotels = jsonResult as! NSDictionary
     
     // print(resultHotels.valueForKey("response"))
        
        var hotelDetail = NSDictionary()
        hotelDetail = resultHotels.valueForKey("response") as! NSDictionary
        
     
        
        let totalElements = hotelDetail.allKeys.count
        if totalElements >= 1{
            
            var venues = []
            
            venues = hotelDetail.valueForKey("venues") as! NSMutableArray
            
         //   print(venues)
            if venues.count<1{
                
                
                
            }
            else{
                
                print(venues[0].valueForKey("id"))
                print(venues[0].valueForKey("name"))
                print(venues[0].valueForKey("contact"))
                let hotelname = venues[0].valueForKey("name") as? String ?? "NA"
                var phoneString = NSString()
                 var addressstring = NSString()
                 var countryString = NSString()
                 var cityString = NSString()
                 var stateString = NSString()
                 var checkInString = NSString()
                 var userCountString = NSString()
                 var tipString = NSString()
                var categoryString = NSString()

                
                
                if let venueId = venues[0].valueForKey("id"){
                    
                    print(venueId)
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        
                      
                        self .getPhotosOfHotel(venueId as! String)
                        
                    })
                    
                }
                
                
               // print(venues[0].valueForKey("location")?.valueForKey("formattedAddress"))
                
                
                
                if let phoneNo = venues[0].valueForKey("contact")?.valueForKey("phone"){
                    print(phoneNo)
                    phoneString = phoneNo as? String ?? "NA"
                }
                print(venues[0].valueForKey("location"))
                
                if let address = venues[0].valueForKey("location")?.valueForKey("address")
                {
                    
                    print(address)
                    addressstring = address as? String ?? "NA"
                    
                    
                    if let country = venues[0].valueForKey("location")?.valueForKey("country")
                    {
                        
                        print(country)
                        countryString = country as? String ?? "NA"
                    }
                    if let city = venues[0].valueForKey("location")?.valueForKey("city")
                    {
                        cityString = city as? String ?? "NA"
                        print(city)
                    }
                    
                    if let state = venues[0].valueForKey("location")?.valueForKey("state")
                    {
                        stateString = state as? String ?? "NA"
                        print(state)
                    }
                    
                    if let categ = venues[0].objectForKey("categories")![0]["name"]
                    {
                        
                        categoryString = categ as? String ?? "NA"
                        print(categ)
                        
                        
                    }
                    
                    
                    
                    
                }
                
                
                print(venues[0].valueForKey("stats"))
                
                if let checksIn = venues[0].valueForKey("stats")?.valueForKey("checkinsCount")
                {
                    checkInString = checksIn as? String ?? "NA"
                    print(checksIn)
                    
                    if let userCount = venues[0].valueForKey("stats")?.valueForKey("usersCount")
                    {
                        userCountString = userCount as? String ?? "NA"
                        print(userCount)
                    }
                    
                    if let tipCount = venues[0].valueForKey("stats")?.valueForKey("tipCount")
                    {
                        tipString = tipCount as? String ?? "NA"
                        
                    }
                    
                    
                }
                
                if let urlHotel = venues[0].valueForKey("url")
                {
                    
                    print(urlHotel)
                    self.webLinkString=urlHotel as! String
                    
                }
                
                
                
                self.hotelNameText.text=hotelname as String
                self.hotelAddressLbl.text=addressstring as String
                self.citylbl.text="\(cityString),\(stateString)"
                self.countryLbl.text=countryString as String
                self.categoryLbl.text=categoryString as String
                
                self.hotelNameText.textAlignment=NSTextAlignment.Left
                self.hotelNameText.clipsToBounds=true
                
                
                if phoneString==""{
                phoneString = "NA"
                }
                
               
               
                
               self.contactButtonLbl .setTitle(phoneString as String, forState: UIControlState .Normal)
                
          
                
                var height = CGFloat(self.view.frame.size.height + 170)
                
              
                    
                    height = 800+self.hotelNameText.frame.height
                    
            
                
                
                
                
                self.heightOfScrollContentView.constant = height
                
                self.detailScrollContentView .setNeedsLayout()

                
                
                
                

            
        }
        
        
               }
        
     
     
     
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
    
    
    
    //MARK:- Get the images from the four square api of the hotels
    //MARK:-
    
    func getPhotosOfHotel(idString:NSString) -> Void {
        
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
            
            // indicatorClass.sharedInstance().showIndicator("Connecting To Facebook, Please wait...")
            
            var urlString = NSString(string:"https://api.foursquare.com/v2/venues/\(idString)?client_id=DAKFO3TURLDTUL33JNPRTIGX03NMZM2ACCDWC2HHHZTV2YMT&client_secret=ILF0G3U4DRSC0WDW2EH12SFGTOKIWSKFUIOXV4FFEQOIB34B&v=20140203")
          //  print("WS URL----->>" + (urlString as String))
            
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
                                
                                
                                
                                if venues.valueForKey("photos")!.valueForKey("count") as! Int == 0 {
                                    
                                }
                                else
                                {
                                    
                                    let photos = venues .valueForKey("photos")! .valueForKey("groups")![0] .valueForKey("items") as! NSMutableArray
                                 
                                    
                                    
                                    print(photos.count)
                                    
                                    
                                    
                                      dispatch_async(dispatch_get_main_queue(), {
                                    
                                        
                                      //  self.UserImageView.sd_setImageWithURL(NSURL(string: self.hotelImagesArray[0] as! String), placeholderImage:UIImage(named: "logo"))
                                        let imgLink = self.hotelImagesArray[0] as! String
                                      //  self.sdWebImageSource = [InputSource]()
                                      //  self.sdWebImageSource.append(SDWebImageSource(urlString: imgLink as String)!)


                                        
                                        
                                        
                                    for l in 0..<photos.count{
                                        
                                        //print(photos[l].valueForKey("prefix"))
                                        
                                        //  print(photos[l].valueForKey("suffix"))
                                        
                                        let str1 = photos[l].valueForKey("prefix") as! String
                                        let str2 = photos[l].valueForKey("suffix") as! String
                                        
                                        let combinedString = "\(str1)original\(str2)"
                                        
                                        
                                        self.hotelImagesArray .addObject(combinedString)
                                          self.sdWebImageSource.append(SDWebImageSource(urlString: combinedString as String)!)
                                    }
                                    
                                    //Set the images into the slider of the detailView
                                    
                                    
                                    self.slideImageView.setImageInputs(self.sdWebImageSource )
                                    
                                    })
                                    
                                }
                                
                                
                                
                              
                                
                                        }
                            
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
    
    
     
 
    
    
    
    

}




