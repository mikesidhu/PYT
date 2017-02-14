//
//  ChatingListViewController.swift
//  PYT
//
//  Created by Niteesh on 23/01/17.
//  Copyright © 2017 appsMaven. All rights reserved.
//

import UIKit
import HMSegmentedControl


class ChatingListViewController: UIViewController {

    @IBOutlet weak var chatingListTable: UITableView!
    
    @IBOutlet weak var segMentControllView: HMSegmentedControl!
    
    @IBOutlet weak var chatingIndicator: UIActivityIndicatorView!
    
    
    var segmentArray = NSMutableArray()
    var segmentName = NSMutableArray()
    var usersChat = NSMutableArray()
    
    var chatLocation = NSString()
    var chatLocationType = NSString()

    
    
    override func viewWillAppear(animated: Bool) {
        chatingIndicator.hidden=false
        chatingIndicator.startAnimating()
        chatingListTable.userInteractionEnabled=false
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let uId = defaults .stringForKey("userLoginId")
        
        self.postRequestGetMessages("userId=\(uId!)", viewController: self)
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.navigationController?.navigationBarHidden=true
        
       

        
        
        // Do any additional setup after loading the view.
    }

   
    
    
    func updateSegment() -> Void {
        
        
        
        let viewWidth = CGRectGetWidth(self.view.frame)
        
        
        print(segmentName.count)
        
        segMentControllView.sectionTitles = NSArray (array: segmentName) as [AnyObject]// segmentName as! [String]
        segMentControllView.autoresizingMask = [.FlexibleRightMargin, .FlexibleWidth]
        segMentControllView.frame = CGRectMake(0, 60, viewWidth, 37)
        
        segMentControllView.segmentEdgeInset = UIEdgeInsetsMake(0, 5, 0, 5)
        
        segMentControllView.selectionStyle = HMSegmentedControlSelectionStyle.FullWidthStripe
        
        
        segMentControllView.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocation.Down
        
        
        segMentControllView.selectionIndicatorColor = UIColor(red: 157/255, green: 194/255, blue: 134/255, alpha: 1.0)
        segMentControllView.selectionIndicatorHeight=3.0
        segMentControllView.verticalDividerEnabled = true
        segMentControllView.verticalDividerColor = UIColor.clearColor()
        segMentControllView.verticalDividerWidth = 0.8
        segMentControllView.backgroundColor = UIColor .clearColor()
        
        segMentControllView.selectedSegmentIndex=selectedindxSearch
        let selectedAttributes: NSDictionary = [
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "Roboto-Bold", size: 16)!
        ]
        
        
        let segAttributes: NSDictionary = [
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name:"Roboto-Regular", size: 15.0)!
        ]
        
        
        segMentControllView .selectedTitleTextAttributes = selectedAttributes as [NSObject : AnyObject]
        segMentControllView .titleTextAttributes = segAttributes as [NSObject : AnyObject]
        
        
        segMentControllView.addTarget(self, action: #selector(self.segmentedControlChangedValue), forControlEvents: .ValueChanged)
    self.reloadTable()
        
        
        
    }
    
    
     func segmentedControlChangedValue(segmentedControl: HMSegmentedControl) {
     self .reloadTable()
        
    }
    
    func reloadTable() -> Void {
        chatingListTable.userInteractionEnabled=true
        usersChat = NSMutableArray()
        print(segmentArray.count)
        print(segMentControllView.selectedSegmentIndex)
        
        chatLocation = segmentArray.objectAtIndex(segMentControllView.selectedSegmentIndex).valueForKey("locationName") as? String ?? ""
        chatLocationType = segmentArray.objectAtIndex(segMentControllView.selectedSegmentIndex).valueForKey("locationType") as? String ?? ""
        
        let tmpArr = segmentArray .objectAtIndex(segMentControllView.selectedSegmentIndex).valueForKey("user") as! NSMutableArray
        
        usersChat = tmpArr
        
        print(usersChat.count)
        print(usersChat)
        
        self.chatingListTable .reloadData()
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    //MARk:-
    //MARK:- Data source and delegates of the tableView
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return usersChat.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        
        let cell:chatingTableCell = tableView.dequeueReusableCellWithIdentifier("chatingListCell") as! chatingTableCell
        
        
        
        
        let imageName2 = usersChat.objectAtIndex(indexPath.row).valueForKey("userImage") as? String ?? ""
        
        let url2 = NSURL(string: imageName2)
        let pImage : UIImage = UIImage(named:"backgroundImage")!
        cell.profilePic.sd_setImageWithURL(url2, placeholderImage: pImage)
        
        
        
        
        
        
        
        cell.profilePic.layer.cornerRadius=cell.profilePic.frame.size.width/2
        cell.profilePic.clipsToBounds=true
        
        cell.msgSendReceive.layer.cornerRadius=cell.msgSendReceive.frame.size.width/2
        cell.msgSendReceive.clipsToBounds=true
        
        
        
        cell.userNameLabel.text = usersChat.objectAtIndex(indexPath.row).valueForKey("userName") as? String ?? ""
        
        
        let msgArr = usersChat.objectAtIndex(indexPath.row).valueForKey("message") as! NSMutableArray
        
        let lastMsg = msgArr.lastObject!.valueForKey("msg") as? String ?? ""
        
        let time = msgArr.lastObject!.valueForKey("time") as? String ?? ""
        
        cell.lastMsgTime.text = time
        
        
        let result = ChatViewController() .convertStringToDictionary(lastMsg)! // convertStringToDictionary(message.text)!
        
        print(result)
        
        //// get the string and convert it into json and get the values what you need
        
        
        
        if result["Media"] as! String == "1" {
            print("Text message")
             cell.messageLabel.text = result["message"] as? String
        }
        else
        {
            print("Text message")
            cell.messageLabel.text = "Image"
        }
        
        
        cell.msgSendReceive.hidden=true
        
        
        
    
        
        return cell
        
    }
    
     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        
        let user2Id = usersChat.objectAtIndex(indexPath.row).valueForKey("userId") as? String ?? ""
        let usname = usersChat.objectAtIndex(indexPath.row).valueForKey("userName") as? String ?? ""
        
    var receiverProfileImage = ""
        
        if usersChat.objectAtIndex(indexPath.row).valueForKey("userImage") != nil {
            receiverProfileImage = usersChat.objectAtIndex(indexPath.row).valueForKey("userImage") as? String ?? ""
        }
        
        
        
        
        let sendArray = NSMutableArray()
        
      
            
        
                
                sendArray .addObject(["Thumbnail": "NA", "Large": "NA"])
                
                
                       print(sendArray)
            
            
        let nxtObj = self.storyboard?.instantiateViewControllerWithIdentifier("ChatViewController") as! ChatViewController
       // nxtObj.CountTableArray = sendArray
        nxtObj.receiver_Id = user2Id
        nxtObj.locationName = chatLocation
        nxtObj.locationType = chatLocationType
        nxtObj.receiverName = usname
        nxtObj.receiverProfile = receiverProfileImage
        self.navigationController! .pushViewController(nxtObj, animated: true)
        nxtObj.hidesBottomBarWhenPushed = true
    
    }
    

    
    
    
    
    
    //MARK: Api to get the chats 
    func postRequestGetMessages(parameterString : String , viewController : UIViewController)
    {
        
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
            let request = NSMutableURLRequest(URL: NSURL(string: "\(appUrl)get_chat_history")!)
            
            
            request.HTTPMethod = "POST"
            let postString = parameterString
            request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
                guard error == nil && data != nil else {                                                          // check for fundamental networking error
                    print("error=\(error)")
                    return
                }
                
                if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                }
                
                let responseString = String(data: data!, encoding: NSUTF8StringEncoding)
                print("responseString = \(responseString)")
                
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    do {
                        
                        let result = NSString(data: data!, encoding:NSASCIIStringEncoding)!
                        print("Body: \(result)")
                        
                        let anyObj: AnyObject = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                        
                        basicInfo = NSMutableDictionary()
                        basicInfo = anyObj as! NSMutableDictionary
                        
                        let status = basicInfo .valueForKey("status") as! NSNumber
                        self.segmentName .removeAllObjects()
                        self.segmentArray .removeAllObjects()
                        
                        if status == 1{
                            
                            let arr: NSMutableArray = basicInfo .valueForKey("chat") as! NSMutableArray
                            
                           print(arr)
                            
                            
                            
                            
                            for i in 0..<arr.count{
                                
                                let nameLoc = arr.objectAtIndex(i).valueForKey("locationName") as? String ?? "NA"
                                
                                self.segmentName .addObject(nameLoc)
                                
                                
                                
                                let locationChat: NSMutableDictionary = arr.objectAtIndex(i) as! NSMutableDictionary
                                
                                
                                self.segmentArray .addObject(locationChat)
                                
                                
                            }
                            
                            if arr.count<1 {
                                self.chatingListTable.hidden=true
                            }
                            else
                            {
                                self.chatingListTable.hidden=false
                                //print(self.segmentArray)
                                self .updateSegment()
                           
                            }
                           
                            
                        }
                        else
                        {
                            
                            CommonFunctionsClass.sharedInstance().alertViewOpen("No Older chats found", viewController: self)
                            
                            
                        }
                        
                        
                        
                        
                        
                        
                    } catch {
                        print("json error: \(error)")
                        CommonFunctionsClass.sharedInstance().alertViewOpen("Sorry there is some issue in backend, Please try again", viewController: viewController)
                        indicatorClass.sharedInstance().hideIndicator()
                        
                        //  self .postRequestCategories("", viewController: viewController) //recall
                        
                    }
                    
                    
                    self.chatingIndicator.hidden=true
                    self.chatingIndicator.stopAnimating()
                    self.tabBarController?.tabBar.items?[3].badgeValue = nil
                    let defaults = NSUserDefaults.standardUserDefaults()
                    let uId = defaults .stringForKey("userLoginId")
                    SocketIOManager.sharedInstance.sendCounter(uId!)
                
                    
                })
                
                
                
                
                
                
                
            }
            task.resume()
            
        }
        else
        {
            CommonFunctionsClass.sharedInstance().alertViewOpen("Please Check Internet Connection", viewController: viewController)
        }
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


class chatingTableCell: UITableViewCell {
    //chatingListCell
    
    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var msgSendReceive: UIImageView!
    
    @IBOutlet weak var lastMsgTime: UILabel!
    
}



