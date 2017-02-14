//
//  chooseInterestsViewController.swift
//  PYT
//
//  Created by Niteesh on 21/12/16.
//  Copyright © 2016 appsMaven. All rights reserved.
//

import UIKit
import MBProgressHUD


class chooseInterestsViewController: UIViewController, apiClassInterestDelegate {

    
    @IBOutlet weak var doneBtnOutlet: UIButton!
    @IBOutlet weak var intrestTable: UITableView!
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    
    
    var tagsArr = [] //categories from the web saven in starting when start application
     var categId = NSMutableArray()
    var checked = NSMutableArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = NSUserDefaults.standardUserDefaults()
          tagsArr = defaults.mutableArrayValueForKey("categoriesFromWeb")
        
        checked = defaults.mutableArrayValueForKey("Interests")
        categId = defaults.mutableArrayValueForKey("IntrestsId")
        
        
        
        indicatorView.hidesWhenStopped=true
        
        apiClassInterest.sharedInstance().delegate=self
        
        
        
        
        // Do any additional setup after loading the view.
    }

    
    //MARK:- BACKBUTTON ACTION
    //MARK:-
    
    @IBAction func backButtonAction(sender: AnyObject) {
         self.dismissViewControllerAnimated(true, completion: {})
        self.navigationController?.popViewControllerAnimated(true)
        NSURLCache.sharedURLCache().removeAllCachedResponses()
    
    }
    
    
    @IBAction func doneButtonAction(sender: AnyObject)
    {
        if checked.count<1 {
            CommonFunctionsClass.sharedInstance().alertViewOpen("Please select some of your intrests!", viewController: self)
        }
        else
        {
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults .setValue(checked, forKey: "Interests")
            defaults .setValue(categId, forKey: "IntrestsId")
            
           
            
            
            dispatch_async(dispatch_get_main_queue(), {
                
                
                //10153101414156609
                
                
               
                
                MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                
                let strarr = self.categId .componentsJoinedByString(",")
                
                let defaults = NSUserDefaults.standardUserDefaults()
                let uId = defaults .stringForKey("userLoginId")
                
                let parameterString = "userId=\(uId!)&interest=\(strarr)"
                //let parameterString = "userId=106337066460748&placeName=kohsamui&placeType=city&category=\(strarr)"//testing
                print(parameterString)
                apiClassInterest.sharedInstance().postRequestInterest(parameterString, viewController: self)
                
                
               
                
             
            })
            
            
        }
        
        
        
        
        
    }
    
    
    
    
    
    
    func serverResponseArrivedInterest(Response:AnyObject)
    {
        
        jsonResult = NSDictionary()
        jsonResult = Response as! NSDictionary
        
        if jsonResult.valueForKey("status") as! NSNumber == 1 {
            
           // CommonFunctionsClass.sharedInstance().alertViewOpen("Interests are updated", viewController: self)
            
             let Alert = UIAlertController(title: "PYT", message: "Interests are updated", preferredStyle: UIAlertControllerStyle.Alert)
            Alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
               
                self.doneBtnOutlet.hidden=true
                self.backButtonAction(self)
                
            }))
            
            
            
        }
        
        
    }
    
    
    
    
    
    
    
    //MARK:- TableView Data source and delegates
    //MARK:-
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return tagsArr.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
       
            let cell = tableView.dequeueReusableCellWithIdentifier("IntrestCell") as! CategoriesCell
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
    
    
   
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
       
            doneBtnOutlet.hidden=false
            
        
            if checked .containsObject(tagsArr .objectAtIndex(indexPath.row).valueForKey("name") as! String)
            {
            
                let objId = (tagsArr .objectAtIndex(indexPath.row).valueForKey("category_id") as? Int)
                
                let objectInt = (tagsArr .objectAtIndex(indexPath.row).valueForKey("name") as? String)
                checked .removeObject(objectInt!)
                categId .removeObject(objId!)
                
                
                
            }
            else
            {
                
                let objId = (tagsArr .objectAtIndex(indexPath.row).valueForKey("category_id") as? Int)
                let objectInt = (tagsArr .objectAtIndex(indexPath.row).valueForKey("name") as? String)
                checked .addObject(objectInt!)
                categId .addObject(objId!)
            }
        
            
            intrestTable .reloadData()
            
            
            
            
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
