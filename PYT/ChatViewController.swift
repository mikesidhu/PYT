




//
//  ChatViewController.swift
//  PYT
//
//  Created by Niteesh on 23/01/17.
//  Copyright © 2017 appsMaven. All rights reserved.
//

import UIKit
import IQKeyboardManager
import JSQMessagesViewController
import SDWebImage

class ChatViewController: JSQMessagesViewController {
    
   
    private var photoMessageMap = [String: JSQPhotoMediaItem]()
    
    var userAvatarImage: JSQMessagesAvatarImage!
    var myAvataerImage: JSQMessagesAvatarImage!
    
    
    
    //Messages
    let incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(UIColor(red: 153/255, green: 189/255, blue: 131/255, alpha: 1.0))
    let outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(UIColor.whiteColor())
    var messages = [JSQMessage]()
    
    
    var CountTableArray = NSMutableArray() 
    var selectedTag = Int()
    var largeUrl = NSString()
    var thumbUrl = NSString()
    var locationName = NSString()
    var locationType = NSString()
    var receiver_Id = NSString()
    var receiverName = NSString()
    var receiverProfile = NSString()
    var myProfilePic = NSString()
    var myName = NSString()
    
    var avatars = [String: JSQMessagesAvatarImage]()
    
    var chatingIndicator = UIActivityIndicatorView()
    
    
    
    
    
    override func viewWillAppear(animated: Bool) {
        
        self.headerLabel.text = receiverName as String
        self.headerImage.image = UIImage (named: "header")
        self.backBtn .setImage(UIImage (named:"back"), forState: UIControlState .Normal)
        
        self.backBtn .addTarget(self, action: #selector(ChatViewController.backButtonAction) , forControlEvents: UIControlEvents .TouchUpInside)
        
        
    }
    
    //BACK Action
    
    func backButtonAction() -> Void {
        
        if zoomImageScrollView.hidden==false {
            
            zoomImageScrollView.hidden=true
        }
        else
        {
        self.navigationController?.popViewControllerAnimated(true)
        self.tabBarController?.tabBar.hidden = false
        }
    }
    
    
    ////Add this method in view did appear to get the messages
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        SocketIOManager.sharedInstance.getChatMessage { (messageInfo) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
               
               // print(messageInfo)
                let otherId = messageInfo["senderId"] as! String
                let msg = messageInfo["msg"] as! String
                let msgType = "1"
                
                
                if messageInfo["LocationName"] as! String == self.locationName as String && messageInfo["LocationType"] as! String == self.locationType as String {
                    
                    
                    let message =  JSQMessage(senderId: otherId, senderDisplayName: msgType, date: NSDate(), text: msg) // JSQMessage(senderId: otherId, displayName: msgType, text: msg)
                    
                    self.messages += [message]
                    
                    JSQSystemSoundPlayer .jsq_playMessageReceivedAlert()
                    
                    self.reloadMessagesView()
                    
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(5.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
                        
                        self.reloadMessagesView()
                        
                    }
                    
                    
                    
                    
                }
                else{
                    print("different location message")
                    
                }
                
                
                
              
                
                
                
                
               
            })
        }
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        zoomImageScrollView.hidden=true
        
       
         
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let uId = defaults .stringForKey("userLoginId")
       
        
        //SocketIOManager.sharedInstance.closeConnection()
       chatingIndicator.startAnimating()
        self.view .addSubview(chatingIndicator)
        self.view.bringSubviewToFront(chatingIndicator)
        SocketIOManager.sharedInstance.establishConnection()
          self.getOlderMessages(uId!)
        
       
        
        
        
        
        
        
        
        
        
        
        
        self.tabBarController?.tabBar.hidden = true
        // Do any additional setup after loading the view.
       
        selectedTag = 91190
       
       
        
       
        
        self.senderId=uId!

        
        
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside=true
        
        
        
        
        self.setup()
      //  self.addDemoMessages()
        
        //var messages: [JSQMessage] = [JSQMessage]()
       // var avatarDict = [String: JSQMessagesAvatarImage]()
        
        
        
        
        
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside=true
        
        self.ImagesTableView? .reloadData()
        
        zoomImageScrollView.delegate=self
        zoomImageScrollView.showsVerticalScrollIndicator=false
        zoomImageScrollView.showsHorizontalScrollIndicator=false
        
     
        
         myName = defaults .stringForKey("userLoginName")!
         myProfilePic = defaults .stringForKey("userProfilePic")!
        
        
        
        self .createAvatar()
        
        if CountTableArray.count>0 {
            //print(CountTableArray.objectAtIndex(0).valueForKey("Thumbnail") as? String ?? "")
            if CountTableArray.objectAtIndex(0).valueForKey("Thumbnail") as? String ?? "" == "NA" {
                
            }
        }
        else
        {
            //call the api to get photos
            self.getPhotosByLocation(uId!, other_UserId: receiver_Id as String, location_Name: locationName as String, location_Type: locationType as String)
        }
        
       
        
       
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChatViewController.handleDisconnectedUserUpdateNotification(_:)), name: "userWasDisconnectedNotification", object: nil)
        
        
       
}

    
    
    //MARK: Get notified when user is dicconnected 
    func handleDisconnectedUserUpdateNotification(notification: NSNotification) {
        let disconnectedUserNickname = notification.object as! String
        print("User \(disconnectedUserNickname.uppercaseString) has left.")
        
        
        SocketIOManager.sharedInstance.establishConnection()
        
    }
    
    
    func handleConnectedUserUpdateNotification(notification: NSNotification) {
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
            
            
            let defaults = NSUserDefaults.standardUserDefaults()
            let uId = defaults .stringForKey("userLoginId")
            
            if uId == nil || uId == ""{
                
            }
            else
            {
                SocketIOManager.sharedInstance.connectToServerWithNickname(uId!, completionHandler: { (userList) -> Void in
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        if userList != nil {
                            
                            //print(userList)
                            
                        }
                    })
                })
                
            }
            
            
            
            
            
        }
        
        
        
        
    }

    
    
    
    
    
    
    
    //MARK: Get Photos By Location
    //MARK:
    
    
    func getPhotosByLocation(my_UserId: String, other_UserId: String, location_Name: String, location_Type:String) -> Void {
       
        let parameterString = "senderId=\(other_UserId)&userId=\(my_UserId)&locationName=\(location_Name)&locationType=\(location_Type)"
        
        ////print("Parameter=\(parameterString)")
        
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
            let request = NSMutableURLRequest(URL: NSURL(string: "\(appUrl)get_images_for_chat")!)
            
            
            request.HTTPMethod = "POST"
            let postString = parameterString
            request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
                guard error == nil && data != nil else {                                                          // check for fundamental networking error
                    //print("error=\(error)")
                    return
                }
                
                if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                    //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    //print("response = \(response)")
                }
                
                let responseString = String(data: data!, encoding: NSUTF8StringEncoding)
                ////print("responseString = \(responseString)")
                
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    do {
                        
                        let result = NSString(data: data!, encoding:NSASCIIStringEncoding)!
                         //print("Body: \(result)")
                        
                        let anyObj: AnyObject = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                        
                        basicInfo = NSMutableDictionary()
                        basicInfo = anyObj as! NSMutableDictionary
                        
                        let status = basicInfo .valueForKey("status") as! NSNumber
                        
                        if status == 1{
                            
                            let arrPhoto: NSMutableArray = basicInfo .valueForKey("photos")! as! NSMutableArray
                            
                           
                            if arrPhoto.count>0{
                                
                                
                                for i in 0..<arrPhoto.count {
                                    
                                  
                                    
                                    let thumb = arrPhoto.objectAtIndex(i).valueForKey("photos")!.valueForKey("imageStandard") as? String ?? ""
                                    
                                     let large = arrPhoto.objectAtIndex(i).valueForKey("photos")!.valueForKey("imageLarge") as? String ?? ""
                                    
                                    
                                    
                                    
                                    self.CountTableArray .addObject(["Thumbnail": thumb, "Large": large])
                                    
                                    
                                    
                                    
                                }
                                
                                
                                
                                
                                
                                
                            }
                            
                            
                            
                        }
                        else
                        {
                            
                            //CommonFunctionsClass.sharedInstance().alertViewOpen("No Older chats found", viewController: self)
                            
                            
                        }
                        
                        
                       self.reloadMessagesView()
                        
                        
                        
                        
                        
                    } catch {
                        //print("json error: \(error)")
                        CommonFunctionsClass.sharedInstance().alertViewOpen("Sorry there is some issue in backend, Please try again", viewController: self)
                        indicatorClass.sharedInstance().hideIndicator()
                        
                        //  self .postRequestCategories("", viewController: viewController) //recall
                        
                    }
                    
                    
                  
                    
                })
                
                
                
                
                
                
                
            }
            task.resume()
            
        }
        else
        {
            CommonFunctionsClass.sharedInstance().alertViewOpen("Please Check Internet Connection", viewController: self)
        }
        
        
        
    }
    
    
    
    
    
    
    //MARK: Api to get the 10 older messages of this chat
    func getOlderMessages(userId: String ) -> Void {
        
        let parameterString = "senderId=\(receiver_Id)&userId=\(userId)&locationName=\(locationName)&locationType=\(locationType)"
        
        print("Parameter=\(parameterString)")
        
        let isConnectedInternet = CommonFunctionsClass.sharedInstance().isConnectedToNetwork()
        
        if isConnectedInternet
        {
            let request = NSMutableURLRequest(URL: NSURL(string: "\(appUrl)chat_description")!)
            
            
            request.HTTPMethod = "POST"
            let postString = parameterString
            request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
                guard error == nil && data != nil else {                                                          // check for fundamental networking error
                    //print("error=\(error)")
                    return
                }
                
                if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                    //print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    //print("response = \(response)")
                }
                
                let responseString = String(data: data!, encoding: NSUTF8StringEncoding)
            ////print("responseString = \(responseString)")
                
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    do {
                        
                        let result = NSString(data: data!, encoding:NSASCIIStringEncoding)!
                      // print("Body: \(result)")
                        
                        let anyObj: AnyObject = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                        
                        basicInfo = NSMutableDictionary()
                        basicInfo = anyObj as! NSMutableDictionary
                        
                        let status = basicInfo .valueForKey("status") as! NSNumber
                        
                        if status == 1{
                            
                            let arr: NSMutableArray = basicInfo .valueForKey("chat")!.valueForKey("message") as! NSMutableArray
                            
                            ////print(arr)
                            
                           
                            
                            
                            
                            for i in 0..<arr.count{
                            //print(arr.objectAtIndex(i).valueForKey("received"))
                                let msg = arr.objectAtIndex(i).valueForKey("received") as! Bool
                           
                                var UsId = ""
                                
                                if msg == false{
                                    UsId = self.senderId
                                }
                                else{
                                    UsId = self.receiver_Id as String
                                }
                                
                                
                                
                                
                            let message = JSQMessage(senderId: UsId, senderDisplayName: "", date: NSDate(), text: arr.objectAtIndex(i).valueForKey("msg") as? String ?? "")
                                
                                self.messages += [message]
                                
                                
                                
                                
                            }
                            
                        }
                        else
                        {
                            
                            //CommonFunctionsClass.sharedInstance().alertViewOpen("No Older chats found", viewController: self)
                            
                            
                        }
                        
                        
                       self.reloadMessagesView()
                        
                        
                        
                        
                        
                    } catch {
                        //print("json error: \(error)")
                        CommonFunctionsClass.sharedInstance().alertViewOpen("Sorry there is some issue in backend, Please try again", viewController: self)
                        indicatorClass.sharedInstance().hideIndicator()
                        
                        //  self .postRequestCategories("", viewController: viewController) //recall
                        
                    }
                    
                    
                    self.chatingIndicator.hidden=true
                    self.chatingIndicator.stopAnimating()
                    self.chatingIndicator.removeFromSuperview()
                    
                })
                
                
                
                
                
                
                
            }
            task.resume()
            
        }
        else
        {
            CommonFunctionsClass.sharedInstance().alertViewOpen("Please Check Internet Connection", viewController: self)
        }
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    func createAvatar()
    {
        
       
        
        
       let imgView1 = UIImageView()
        let imageView2 = UIImageView()
        
     
                
        
       
        //get my profile pic
        let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in
            
           if self.myProfilePic == ""
           {
           self.myAvataerImage = JSQMessagesAvatarImageFactory.avatarImageWithImage(UIImage (named: "backgroundImage"), diameter: 30)
           }
           else{
            self.myAvataerImage = JSQMessagesAvatarImageFactory.avatarImageWithImage(image, diameter: 30)
            }
            
            
        }
        
        //completion block of the sdwebimageview
        imgView1.sd_setImageWithURL(NSURL(string: myProfilePic as String), placeholderImage: nil, completed: block)
        
        
        
        //
        //get user profile pic
        let block2: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in
            
            //self.finishReceivingMessage()
            if self.receiverProfile == ""
            {
                 self.userAvatarImage = JSQMessagesAvatarImageFactory.avatarImageWithImage(UIImage (named: "backgroundImage"), diameter: 30)
            }
            else{
                self.userAvatarImage = JSQMessagesAvatarImageFactory.avatarImageWithImage(image, diameter: 30)
            }
            
            
            
            
        }
        
        //completion block of the sdwebimageview
        imageView2.sd_setImageWithURL(NSURL(string: receiverProfile as String), placeholderImage: nil, completed: block2)
        
        
        
        
        
        
        
       
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    @IBAction func openImages(sender: AnyObject) {
        
        
        
        selectedTag = 91190
        ImagesTableView .reloadData()
        IQKeyboardManager.sharedManager().resignFirstResponder()
        
        self.heightOfImagesView.constant = 200
        self .jsq_setToolbarBottomLayoutGuideConstant(0)
        
        
        
    }
    
    
    
 
    
    
    //MARK: Reload the messages view
    
    func reloadMessagesView() {
       
        self.collectionView?.reloadData()
        self.scrollToBottomAnimated(true)
        
        
    }
    
    
    
    
    
    
    
    
    //MARK:
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        NSURLCache.sharedURLCache().removeAllCachedResponses()
        
        //print("MEMORYWARNING AND CLEARING CACHE ")
        
        //let imageCache = SDImageCache.sharedImageCache()
        //imageCache.clearMemory()
        // imageCache.clearDisk()
        // Dispose of any resources that can be recreated.
    }
    
    }



//MARK - Setup

extension ChatViewController
{
    
    func addDemoMessages() {
        
        ////////get the messages from server
//        SocketIOManager.sharedInstance.getChatMessage { (messageInfo) -> Void in
//            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                
//                //print(messageInfo)
//                
//                //self.chatMessages.append(messageInfo)
//                //self.tblChat.reloadData()
//                //                self.scrollToBottom()
//            })
//        }
        
        
        
        
        
        
        
        
        
        
        for i in 1...5 {
            let sender = (i%2 == 0) ? "Server" : self.senderId
            let messageContent = "Message nr. \(i)"
            let message = JSQMessage(senderId: sender, displayName: sender, text: messageContent)
            self.messages += [message]
        }
        self.reloadMessagesView()
    }
    
    
    func setup() {
        //self.senderId = UIDevice.currentDevice().identifierForVendor?.UUIDString
        self.senderDisplayName = UIDevice.currentDevice().identifierForVendor?.UUIDString
    }
}







//MARK - Data Source
extension ChatViewController {
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       // //print(collectionView)
        
       
           
            return self.messages.count
            
        
    }
    
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        
//        let message = self.messages[indexPath.row] //self.messageModelData.messages[indexPath.row]
//        if message.isMediaMessage {
//        //print(message.senderDisplayName)
//        }
//        
//        let data = self.messages[indexPath.row]
//        return data

        
        let message = self.messages[indexPath.item]
       // //print(message)
       // //print(message.text)
      //
        
        let result = convertStringToDictionary(message.text)!
        
       // //print(result)
        
        //// get the string and convert it into json and get the values what you need
        
        
        
        if result["Media"] as! String == "1" {
            //print("Text message")
            
            let JSQTypeMessage = JSQMessage(senderId: message.senderId, senderDisplayName: "", date: NSDate(), text: result["message"]as! String)
            //print(JSQTypeMessage)
            
            return JSQTypeMessage
            
        }
        
        else
        {
            var stringUrl:NSURL?
           ////print(result["thumbUrl"] as! String)
           // //print(result["largeUrl"] as! String)
            
            
            
            
            stringUrl = NSURL(string: result["thumbUrl"] as! String )
            
            let tempImageView = UIImageView(image: nil)
           // tempImageView.sd_setImageWithURL(stringUrl, completed: nil)
            
            let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in
               
                //self.finishReceivingMessage()
                
                
            }
            
            //completion block of the sdwebimageview
            tempImageView.sd_setImageWithURL(stringUrl, placeholderImage: nil, completed: block)
            
            
            let photoImage = JSQPhotoMediaItem(image: tempImageView.image)
            
            
            
            
            
            
            // This makes it so the bubble can be incoming rather than just all outgoing.
            if !(message.senderId == self.senderId) {
                photoImage.appliesMediaViewMaskAsOutgoing = false
            }
            
            let message = JSQMessage(senderId: message.senderId, displayName: self.senderDisplayName, media: photoImage)
            
            
            return message
        }
        
        
        let JSQTypeMessage = JSQMessage(senderId: message.senderId, senderDisplayName: "", date: message.date, text: message.text)
        
        return JSQTypeMessage
            
            
        
        
        
        
        
        
        
        
        
        
//        
//        if (message.text.rangeOfString ("https://") != nil) {
//            
//            let types: NSTextCheckingType = .Link
//            
//            let detector = try? NSDataDetector(types: types.rawValue)
//            
//           // guard let detect = detector else {
////                let JSQTypeMessage = JSQMessage(senderId: message.senderId, senderDisplayName: "", date: NSDate(), text: message.text)
////                //print(JSQTypeMessage)
////                
////                return JSQTypeMessage
//          //  }
//            
//            let matches = detect.matchesInString(message.text!, options: .ReportCompletion, range: NSMakeRange(0, message.text!.characters.count))
        
//            var stringUrl:NSURL?
//            //print(matches)
//            
//            let strSep: String = String(message.text)
//            
//            let arrCommon = strSep.componentsSeparatedByString("123PYT321")
//            //print(arrCommon)
//            
//            
//            stringUrl = NSURL(string: arrCommon[0])
//            
//            let tempImageView = UIImageView(image: nil)
//            tempImageView.sd_setImageWithURL(stringUrl, completed: nil)
//            
//            let photoImage = JSQPhotoMediaItem(image: tempImageView.image)
//            
//            // This makes it so the bubble can be incoming rather than just all outgoing.
//            if !(message.senderId == self.senderId) {
//                photoImage.appliesMediaViewMaskAsOutgoing = false
//            }
//            
//            let message = JSQMessage(senderId: message.senderId, displayName: self.senderDisplayName, media: photoImage)
//            return message
//        }
//        
//        let JSQTypeMessage = JSQMessage(senderId: message.senderId, senderDisplayName: "", date: message.date, text: message.text)
//        
//        return JSQTypeMessage
        
    
    
    
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, didDeleteMessageAtIndexPath indexPath: NSIndexPath!) {
        self.messages.removeAtIndex(indexPath.row)
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        let data = messages[indexPath.row]
        switch(data.senderId) {
        case self.senderId:
            return self.outgoingBubble
        default:
            return self.incomingBubble
        }
    }
    
    
    
    
    
    
        
  //MARK: Users profile pictures
    

    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource!
    {
        let message = messages[indexPath.row]
        
        
        
        if (message.senderId == self.senderId) {
            //reurn my profile
         return myAvataerImage
            
                    
        }
        else
        {
            return userAvatarImage
        }
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    override func collectionView(collectionView: JSQMessagesCollectionView, didTapMessageBubbleAtIndexPath indexPath: NSIndexPath) {
         IQKeyboardManager.sharedManager().resignFirstResponder()
        
        self.bottomSpaceOfZoomView.constant = 0//self.view.frame.size.height
        //print("Bottdcfhsvhjacgc--\(bottomSpaceOfZoomView.constant)")
        self.view .layoutIfNeeded()
        
        let message = self.messages[indexPath.row] //self.messageModelData.messages[indexPath.row]
       
        
        
        
        let result = convertStringToDictionary(message.text)!
        
        //print(result)
        
        //// get the string and convert it into json and get the values what you need
       
        if result["Media"] as! String == "1" {
            //print("Text message   Dont do any thing")
            
        }
            
        else{
            var stringUrl = ""
             var largeUrl = ""
            
            
            //print(result["thumbUrl"] as! String)
            //print(result["largeUrl"] as! String)
            
            stringUrl = result["thumbUrl"] as! String
            largeUrl = result["largeUrl"] as! String
            
            
            
             self .openImageZoom(stringUrl, large: largeUrl)
            
            
        }
        
        
        
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
}




//MARK - Toolbar
extension ChatViewController
{
    
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        
         zoomImageScrollView.hidden=true //Hide the zoom view
        
       
        
        if  selectedTag == 91190 // if message is text message
        {
            //// convert the message into json
            let tempDict = NSMutableDictionary()
            tempDict .setValue(text, forKey: "message")
            tempDict .setValue("1", forKey: "Media") // here 1 is for text
            //print(tempDict)
            
            let jsonData = try! NSJSONSerialization.dataWithJSONObject(tempDict, options: NSJSONWritingOptions.PrettyPrinted)
            
            let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding)! as String
            
            //print(jsonString)
            
            
            
            //toUserDP
            //toUserName
            
             let message = JSQMessage(senderId: self.senderId, senderDisplayName: senderDisplayName, date: date, text: jsonString)
            
            self.messages += [message]
            

                       
           //SocketIOManager.sharedInstance.sendMessage(text, withNickname: self.senderId, receiverId: receiver_Id as String) //senderId)
            
            
            SocketIOManager.sharedInstance.sendMessage(jsonString, withNickname: self.senderId, receiverId: receiver_Id as String, locType: locationType as String, msgType: "1", locName: locationName as String, receiverName: receiverName as String, receiverProfile: receiverProfile as String, senderName: myName as String, senderDp: myProfilePic as String )
            
           //self.reloadMessagesView()
            self.finishSendingMessage()
            
        }
        else
        {
            self.addPhotoMediaMessage()
        }
    }
    
    
    override func didPressAccessoryButton(sender: UIButton!) {
        
         SocketIOManager.sharedInstance.reconnect()
        
        
        if self.heightOfImagesView.constant == 200 {
         self.heightOfImagesView.constant = 0
            inputToolbar.contentView.textView.becomeFirstResponder()
             selectedTag = 91190
            zoomImageScrollView.hidden=true
            inputToolbar.contentView.rightBarButtonItem.enabled = false
            inputToolbar.contentView.textView.text = nil
        }
        
        
        else
        {
        self.openImages(self)
            self.scrollToBottomAnimated(true)
            inputToolbar.contentView.rightBarButtonItem.enabled = false
            inputToolbar.contentView.textView.text = nil
        }

        
        
       }
    
    
    /////Send button action to send the messages to the server
    
   
    
    
    //MARK: Function to get the dictionary from the response
    //MARK:
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                return try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String:AnyObject]
            } catch let error as NSError {
                //print(error)
            }
        }
        return nil
    }
    
    
    
    
    
    
    
    
    
    
    
}



extension ChatViewController {
   
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
       // //print("Returning num sections")
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ////print("Returning num rows")
        
        if CountTableArray.count % 3 == 0 {
            return CountTableArray.count/3
        }
        else
        {
            return CountTableArray.count/3 + 1
            
        }
        
        
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //print("Trying to return cell")
        let CellIdentifier = "CellImagesMessages"
        
        var cell:UITableViewCell
        
        if let reuseCell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) {
            cell=reuseCell
        } else {
            cell=UITableViewCell()
            cell.frame=CGRectMake(0, 0, tableView.frame.size.width, 110)
            //(style: .Default, reuseIdentifier: CellIdentifier)
        }
       
        let arr = NSMutableArray()
        
        
        
        
        let count = indexPath.row * 3
         ////print(count)// to show the 3 images at a time in row of tableview
        
        for i in count..<CountTableArray.count {
          // //print(i)
            arr .addObject(["Images":CountTableArray .objectAtIndex(i), "Tag":i])
            if arr.count==3 {
                break
            }
        }
        
       // //print(arr)
        //print(arr.count)
        
        let newBtn1 = UIButton()
        let newBtn2 = UIButton()
        let newBtn3 = UIButton()
        
        let indicator1 = UIActivityIndicatorView()
        let indicator2 = UIActivityIndicatorView()
        let indicator3 = UIActivityIndicatorView()
        
        
        cell.clipsToBounds=true
        
        
        let buttonWidth = cell.frame.size.width/3 - 10
        var buttonSpace = (buttonWidth * 3 )
        
        buttonSpace = cell.frame.size.width - buttonSpace
       
        buttonSpace = buttonSpace / 3 - 2 //+ 10
        
       // //print("Button space = \(buttonSpace) \n button Width = \(buttonWidth)")
        
        
        for j in 0..<arr.count {
            
            
            
            let imageName2 = arr.objectAtIndex(j).valueForKey("Images")!.valueForKey("Thumbnail") as? String ?? ""
            ////print(imageName2)
            
            let url2 = NSURL(string: imageName2 )
            let pImage : UIImage = UIImage(named:"backgroundImage")!
            
            
            
            if j == 0 {
                newBtn1.frame = CGRectMake(buttonSpace, 0, buttonWidth, 95)
                newBtn1.addTarget(self, action: #selector(ChatViewController.buttonAction(_:)), forControlEvents: .TouchUpInside)
                cell.contentView .addSubview(newBtn1)
                newBtn1.clipsToBounds=true
                newBtn1.tag = arr.objectAtIndex(j).valueForKey("Tag") as! Int
                
                indicator1.center = newBtn1.center
                newBtn1 .addSubview(indicator1)
                indicator1 .startAnimating()
                indicator1.activityIndicatorViewStyle = .Gray
                
                let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in
                    
                    indicator1 .removeFromSuperview()
                }
                
                newBtn1.sd_setImageWithURL(url2, forState: .Normal, placeholderImage: pImage, completed: block)
                
                if newBtn1.tag == selectedTag {
                    
                    newBtn1.layer.borderWidth=3.5
                    newBtn1.layer.borderColor = UIColor .greenColor().CGColor
                    
                }
                
               
                    
                
            }
            else if (j == 1)
            {
                newBtn2.frame = CGRectMake(newBtn1.frame.origin.x + buttonWidth + buttonSpace , 0, buttonWidth, 95)
               newBtn2.addTarget(self, action: #selector(ChatViewController.buttonAction(_:)), forControlEvents: .TouchUpInside)
                cell.contentView .addSubview(newBtn2)
                newBtn2.clipsToBounds=true
                newBtn2.tag = arr.objectAtIndex(j).valueForKey("Tag") as! Int
                
                indicator2.center = newBtn2.center
                newBtn2 .addSubview(indicator2)
                indicator2 .startAnimating()
                indicator2.activityIndicatorViewStyle = .Gray
                
                
                let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in
                    indicator2 .removeFromSuperview()
                }
                
                newBtn2.sd_setImageWithURL(url2, forState: .Normal, placeholderImage: pImage, completed: block)
                
                
                if newBtn2.tag == selectedTag {
                    
                    newBtn2.layer.borderWidth=3.5
                    newBtn2.layer.borderColor = UIColor .greenColor().CGColor
                    
                }
                
                
            }
                
            else
            {
                newBtn3.frame = CGRectMake(newBtn2.frame.origin.x + buttonWidth + buttonSpace , 0, buttonWidth, 95)
                // newBtn.addTarget(self, action: #selector(self.urSelctor), forControlEvents: .TouchUpInside)
               newBtn3.addTarget(self, action: #selector(ChatViewController.buttonAction(_:)), forControlEvents: .TouchUpInside)
        
                cell.contentView .addSubview(newBtn3)
                newBtn3.clipsToBounds=true
                newBtn3.tag = arr.objectAtIndex(j).valueForKey("Tag") as! Int
                
                indicator3.center = newBtn3.center
                newBtn3 .addSubview(indicator3)
                indicator3 .startAnimating()
                indicator3.activityIndicatorViewStyle = .Gray
                
                let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in
                    indicator3 .removeFromSuperview()
                }
                
                newBtn3.sd_setImageWithURL(url2, forState: .Normal, placeholderImage: pImage, completed: block)
                
                if newBtn3.tag == selectedTag {
                    
                    newBtn3.layer.borderWidth=3.5
                    newBtn3.layer.borderColor = UIColor .greenColor().CGColor
                    
                }
            }
            
            
            
        }
        
        
        
        /*
 
         let imageName2 = hotelImagesArray.valueForKey("normal") .objectAtIndex(indexPath.row)
         let url2 = NSURL(string: imageName2 as! String)
         let pImage : UIImage = UIImage(named:"backgroundImage")!
         
         
         let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in
         
         activityIndicatorView .removeFromSuperview()
         }
         
         //completion block of the sdwebimageview
         locationimage2.contentMode = .ScaleAspectFill
         locationimage2.sd_setImageWithURL(url2, placeholderImage: pImage, completed: block)
         
 */
        

        
        
        
        //cell .setNeedsUpdateConstraints()
       // cell .updateConstraintsIfNeeded()
      // cell.contentView.backgroundColor=UIColor .redColor()
        //print("Returning cell")
        return cell
    }
    
    
    
    
    func buttonAction(sender: UIButton!) {
        //print("Button tapped")
        //print(sender.tag)
        
        
        bottomSpaceOfZoomView.constant = self.view.frame.size.height - inputToolbar.frame.origin.y
        //print(bottomSpaceOfZoomView.constant)
        
        zoomImageScrollView.hidden=false
self.view .bringSubviewToFront(zoomImageScrollView)
        
        zoomIndicator.hidden=false
        zoomIndicator.startAnimating()
        
        zoomImageScrollView.minimumZoomScale = 1.0
        zoomImageScrollView.maximumZoomScale = 5.0
        zoomImageScrollView.zoomScale = 1.0
        zoomImageScrollView .contentSize = CGSizeMake(zoomImageView.frame.size.width, zoomImageView.frame.size.height)
        
        
        
        //print(CountTableArray.objectAtIndex(sender.tag))
        
        
        let imageLarge = CountTableArray.objectAtIndex(sender.tag).valueForKey("Large") as? String ?? ""
        let imageThumbnail = CountTableArray.objectAtIndex(sender.tag).valueForKey("Thumbnail") as? String ?? ""
        
        largeUrl = imageLarge
        thumbUrl = imageThumbnail
        
        
        let urlLarge = NSURL(string: imageLarge )
         let urlThumb = NSURL(string: imageThumbnail )
        
        let pImage : UIImage = UIImage(named:"backgroundImage")!
        zoomImageView.sd_setImageWithURL(urlThumb, placeholderImage: pImage)
        
        selectedTag = sender.tag //assign the value into varibble so that sjhow the green border in tableview
        
        ImagesTableView .reloadData()
        
        inputToolbar.contentView.rightBarButtonItem.enabled = true
        
        
        
        
        
        
        let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in
        
        self.zoomIndicator.stopAnimating()
            self.zoomIndicator.hidden=true
        
        }
        
        zoomImageView.sd_setImageWithURL(urlLarge, placeholderImage: zoomImageView.image, completed: block)
        
       
        
        
        
        
      // self.addPhotoMediaMessage()
        
        
    }

    
    func addPhotoMediaMessage() {
        
        
        //print("Large url=\(largeUrl),\n Thumbnail url =\(thumbUrl)")
        
        
        let uniqueUrl = "\(thumbUrl)123PYT321\(largeUrl)"
        
        
        
        let tempDict = NSMutableDictionary()
        tempDict .setValue(thumbUrl, forKey: "thumbUrl")
        tempDict.setValue(largeUrl, forKey: "largeUrl")
        tempDict .setValue("2", forKey: "Media")
        //print(tempDict)
        
        let jsonData = try! NSJSONSerialization.dataWithJSONObject(tempDict, options: NSJSONWritingOptions.PrettyPrinted)
        
        let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding)! as String
        
        //print(jsonString)
        
       
        
        let photoMessage = JSQMessage(senderId: self.senderId, senderDisplayName: "1", date: NSDate(), text: jsonString as String) //JSQMessage(senderId: self.senderId, displayName: thumbUrl as String, media: photoItem)
        
        self.messages.append(photoMessage)
       
//        SocketIOManager.sharedInstance.sendMessage(jsonString as String, withNickname: self.senderId, receiverId: receiver_Id as String, locType: locationType as String, msgType: "2", locName: locationName as String, receiverName: receiverName as String, receiverProfile: receiverProfile as String, senderName: myName as String, senderDp: myProfilePic as String)
       
        SocketIOManager.sharedInstance.sendMessage(jsonString, withNickname: self.senderId, receiverId: receiver_Id as String, locType: locationType as String, msgType: "1", locName: locationName as String, receiverName: receiverName as String, receiverProfile: receiverProfile as String, senderName: myName as String, senderDp: myProfilePic as String )
        
        
        
       
        self.reloadMessagesView()
         selectedTag = 91190
        ImagesTableView .reloadData()
        inputToolbar.contentView.rightBarButtonItem.enabled = false
    }
    
 
    
   
    
    /*
    private func fetchImageDataAtURL(photoURL: String, forMediaItem mediaItem: JSQPhotoMediaItem, clearsPhotoMessageMapOnSuccessForKey key: String?) {
       
        let imgView = UIImageView()
        imgView.sd_setImageWithURL(NSURL(string: photoURL), placeholderImage: UIImage (named: "backgroundImage"))
        
           mediaItem.image = imgView.image
                self.collectionView.reloadData()
                
                guard key != nil else {
                    return
                }
        
        
        
    }
    
    */
    
    
    
    
    
    
    
    
    
     
     
     
     
     override func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView?
     {
        
     if scrollView==zoomImageScrollView
     {
     return zoomImageView
     }
     
     else
     {
        return self.view
        }
        
    }
    
    
    //MARK: Show zoom image
    
    func openImageZoom(thumbnail: NSString, large: NSString) -> Void {
        
        //print(zoomImageScrollView)
         zoomImageScrollView.hidden=false
        self.view .bringSubviewToFront(zoomImageScrollView)
        
         zoomIndicator.hidden=false
         zoomIndicator.startAnimating()
        
          zoomImageScrollView.minimumZoomScale = 1.0
         zoomImageScrollView.maximumZoomScale = 5.0
         zoomImageScrollView.zoomScale = 1.0
         zoomImageScrollView .contentSize = CGSizeMake(zoomImageView.frame.size.width, zoomImageView.frame.size.height)
        
        
        
       
        
        
        let imageLarge = large
        let imageThumbnail = thumbnail
        
        
        let urlLarge = NSURL(string: imageLarge as String )
        let urlThumb = NSURL(string: imageThumbnail as String )
        
        let pImage : UIImage = UIImage(named:"backgroundImage")!
        zoomImageView.sd_setImageWithURL(urlThumb, placeholderImage: pImage)
        
        
         let block: SDWebImageCompletionBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in
        
         self.zoomIndicator.stopAnimating()
            self.zoomIndicator.hidden=true
        
           }
        
          zoomImageView.sd_setImageWithURL(urlLarge, placeholderImage: zoomImageView.image, completed: block)
        
        
        
        
    }
 
    
    
    
    
  
    
    
    
    
    
}











 
        