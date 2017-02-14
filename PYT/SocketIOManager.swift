//
//  SocketIOManager.swift
//  PYT
//
//  Created by Niteesh on 02/02/17.
//  Copyright © 2017 appsMaven. All rights reserved.
//

import UIKit

class SocketIOManager: NSObject {

    
     static let sharedInstance = SocketIOManager()
    
    override init() {
        super.init()
    }
    
    
    
    ////and we’ll provide the IP address of our computer and the designated port.
    
    var socket: SocketIOClient = SocketIOClient(socketURL: NSURL(string: "http://pictureyourtravel.com")!)
    
    
    
    
    
    ///define two methods now that will make use of the above socket property. The first one connects the app to the server, and the second makes the disconnection.
    //MARK: create and disconnect connection
    
    func establishConnection() {
        socket.connect()
        
        
        
        
    }
    
    
    func reconnect() {
       // socket.reconnect()

//        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(4.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
//            
//            //dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {
//            let defaults = NSUserDefaults.standardUserDefaults()
//            let uId = defaults .stringForKey("userLoginId")
//            
//            if uId == nil || uId == ""{
//                
//            }
//            else
//            {
//                SocketIOManager.sharedInstance.connectToServerWithNickname(uId!, completionHandler: { (userList) -> Void in
//                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                        if userList != nil {
//                            
//                            print(userList)
//                            
//                        }
//                    })
//                })
//            }
//            
//            
//            
//            //})
//            
//        }

        
        
    }
    
    
    
    func closeConnection() {
        socket.disconnect()
        
        
        
        
    }
    
    
    
   
    
    
    
    
    
    
    //MARK: Function to send the messages
    
    
    func sendMessage(message: String, withNickname nickname: String, receiverId: String, locType: String, msgType: String, locName: String, receiverName: String, receiverProfile: String, senderName: String, senderDp: String) {
        
        print("senderid = \(nickname), receiver id=\(receiverId), msgType = \(msgType), message=\(message), senderId=\(nickname), receiverName=\(receiverName), receiverDP=\(receiverProfile), Sender Dp= \(senderDp) receiverId= \(receiverId)")
        
        socket.emit("message",["msg": message, "senderId": nickname,"to": receiverId, "locationName": locName, "locationType": locType, "msgType": msgType, "toUserDP": receiverProfile, "toUserName": receiverName, "senderName": senderName, "senderDp": senderDp ])
        
        
    }
    
    
    
    //TEMP Image Functiom
    
    
    func sendMessageImage(message: String, withNickname nickname: String, receiverId: String, locType: String, msgType: String, locName: String, receiverName: String, receiverProfile: String, senderName: String, senderDp: String) {
        
        print("senderid = \(nickname), receiver id=\(receiverId), msgType = \(msgType), message=\(message), senderId=\(nickname), receiverName=\(receiverName), receiverDP=\(receiverProfile), Sender Dp= \(senderDp) receiverId= \(receiverId)")
        
//        socket.emit("image",["msg": message, "senderId": nickname,"to": receiverId, "locationName": locName, "locationType": locType, "msgType": msgType, "toUserDP": receiverProfile, "toUserName": receiverName, "senderName": senderName, "senderDp": senderDp ])

        
        socket.emit("image",["msg": "Hello Kunal Testing is here for images" ])
        
        
    }
    
    
    
    
    
    
    //MARK: Clear the chat messages older counter
    
    func sendCounter(userId: String) {
        
       
        
        socket.emit("clearReadCount",["userId": userId ])
        
        
    }
    
    
    
    
    
    //MARK: Get the messages from the server
    ///
    
    func getChatMessage(completionHandler: (messageInfo: [String: AnyObject]) -> Void) {
        socket.on("message") { (dataArray, socketAck) -> Void in
            var messageDictionary = [String: AnyObject]()
           
            print(dataArray)
            let dataArr = NSArray(array: dataArray)
            print(dataArr)
            
            
            messageDictionary["senderId"] = dataArr.objectAtIndex(0).valueForKey("senderId") as? String ?? ""
            messageDictionary["msg"] = dataArr.objectAtIndex(0).valueForKey("msg") as? String ?? ""
            messageDictionary["LocationName"] = dataArr.objectAtIndex(0).valueForKey("locationName") as? String ?? ""
             messageDictionary["LocationType"] = dataArr.objectAtIndex(0).valueForKey("locationType") as? String ?? ""
             print(messageDictionary)
            
            completionHandler(messageInfo: messageDictionary)
        }
    }
    
    
    
    
    
    func getChatMessageNotify(completionHandler: (messageInfo: [String: AnyObject]) -> Void) {
        socket.on("notify") { (dataArray, socketAck) -> Void in
            var messageDictionary = [String: AnyObject]()
            
            let dataArr = NSArray(array: dataArray)
        
             messageDictionary["count"] = dataArr.objectAtIndex(0).valueForKey("count")
           print(messageDictionary)
            completionHandler(messageInfo: messageDictionary)
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //The first action we have to take is to send a new user’s nickname to the server, using of course the Socket.IO library. Open the SocketIOManager.swift file, and define the following method:
    //Send the nice name here id will be send of the user
    func connectToServerWithNickname(senderId: String, completionHandler: (userList: [[String: AnyObject]]!) -> Void) {
        
        print(senderId)
        
         let defaults = NSUserDefaults.standardUserDefaults()
        let userName = defaults .stringForKey("userLoginName")! as? String ?? ""
        
        
        let userPic = defaults .stringForKey("userProfilePic")! as? String ?? ""
        
        
        socket.emit("init", ["userId":senderId, "userName": userName, "profilePic": userPic])
        
        listenForOtherMessages()

        
        ///For future use
        /*
         socket.on("userList") { ( dataArray, ack) -> Void in
         completionHandler(userList: dataArray[0] as! [[String: AnyObject]])
         }
         
         
         //Leave chat 
         func exitChatWithNickname(nickname: String, completionHandler: () -> Void) {
         socket.emit("exitUser", nickname)
         completionHandler()
         }
         
         
        //Exit action
         @IBAction func exitChat(sender: AnyObject) {
         SocketIOManager.sharedInstance.exitChatWithNickname(nickname) { () -> Void in
         dispatch_async(dispatch_get_main_queue(), { () -> Void in
         self.nickname = nil
         self.users.removeAll()
         self.tblUserList.hidden = true
         self.askForNickname()
         })
         }
         }
         
         
         //MARK: Being Notified When Users Type Messages
         //
         func sendStartTypingMessage(nickname: String) {
         socket.emit("startType", nickname)
         }
         
         //// Notify when stop type
         
         func sendStopTypingMessage(nickname: String) {
         socket.emit("stopType", nickname)
         }
         
 */
        
        
        
        
        
    }
    
    
    
    private func listenForOtherMessages() {
        socket.on("userConnectUpdate") { (dataArray, socketAck) -> Void in
            NSNotificationCenter.defaultCenter().postNotificationName("userWasConnectedNotification", object: dataArray[0] as! [String: AnyObject])
            
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
                
                //dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), {
                let defaults = NSUserDefaults.standardUserDefaults()
                let uId = defaults .stringForKey("userLoginId")
                
                if uId == nil || uId == ""{
                    
                }
                else
                {
                    SocketIOManager.sharedInstance.connectToServerWithNickname(uId!, completionHandler: { (userList) -> Void in
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            if userList != nil {
                                
                                print(userList)
                                
                            }
                        })
                    })
                }
                
                
                
                //})
                
            }
            
            
        }
        
        socket.on("userExitUpdate") { (dataArray, socketAck) -> Void in
            NSNotificationCenter.defaultCenter().postNotificationName("userWasDisconnectedNotification", object: dataArray[0] as! String)
        }
        
//        socket.on("userTypingUpdate") { (dataArray, socketAck) -> Void in
//            NSNotificationCenter.defaultCenter().postNotificationName("userTypingNotification", object: dataArray[0] as? [String: AnyObject])
//        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}
