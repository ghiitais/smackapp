//
//  SocketService.swift
//  SmackAlpha
//
//  Created by Ghita on 10/29/17.
//  Copyright © 2017 Ghita. All rights reserved.
//

import UIKit
import SocketIO

class SocketService: NSObject {

    
    static let instance = SocketService()
    
    override init() {
        super.init()
    }
    var socket: SocketIOClient = SocketIOClient(socketURL: URL(string: BASE_URL)!)
    // Establish connection b/w app and web server
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
    
    func addChannel(name: String, description: String, completion: @escaping CompletionHandler) {
      // emit from our app to the api
        socket.emit("newChannel", name, description)
        completion(true)
    }
    // func to detect emission from api, listenning for the event,
    //called in the viewDidLoad
    func getChannel(completion: @escaping CompletionHandler) {
        socket.on("channelCreated") { (dataArray, ack) in // ack = acknowledgment
            guard let channelName = dataArray[0] as? String else {return} // we can se it from the code
            guard let channelDescription = dataArray[1] as? String else {return}
            guard let channelId = dataArray[2] as? String else {return}
            
            let newChannel = Channel(channelTitle: channelName, channelDescription: channelDescription, id: channelId)
            MessageService.instance.channels.append(newChannel)
            completion(true)
            
        }
   
    }
    // function to add messages to our API
    func addMessage(messageBody: String, userId: String, channelId: String, completion: @escaping CompletionHandler) {
        let user = userDataService.instance
        socket.emit("newMessage", messageBody, userId, channelId, user.name, user.avatarName, user.avatarColor)
        completion(true)
    }
    
    // Listen when messages are sent to the server and sent them back to us
    // We have to check that the message we're getting (created for eg by another user on another device) is meant to be for our selected channel, otherwise i won't show it
    // so channel id of incoming messages matches channel id of current channel
    
    
    //(new fo runread channels)
    // in the channelVC, set up listener for new msgs and if new msgs comes in that is not selected channel we add that channel to array of unread channels and update our channels rown accordingly
    
    func getChatMessage(completion: @escaping (_ newMessage: Message) -> Void){
        socket.on("messageCreated") { (dataArray, ack) in
            guard let messageBody = dataArray[0] as? String else {return}
            guard let channelId = dataArray[2] as? String else {return}
            guard let userName = dataArray[3] as? String else {return}
            guard let userAvatar = dataArray[4] as? String else {return}
            guard let userAvatarColor = dataArray[5] as? String else {return}
            guard let messageId = dataArray[6] as? String else {return}
            guard let timeStamp = dataArray[7] as? String else {return}
            
            // check of incoming message is in channel selected (before refactor)
            let newMessage = Message(message: messageBody, userName: userName, channelId: channelId, userAvatar: userAvatar, userAvatarColor: userAvatarColor, timeStamp: timeStamp, id: messageId )
           completion(newMessage)
        }
    }

    func getTypingUsers(_ completionHandler: @escaping (_ typingUsers: [String: String]) -> Void ){
        
        socket.on("userTyping") { (dataArray, ack) in
            guard let typingUsers = dataArray[0] as? [String: String] else {return}// each entry is key-value pair key username and value channelId they began typing
            completionHandler(typingUsers) 
        }
    }
    
    
    
    
   
}
