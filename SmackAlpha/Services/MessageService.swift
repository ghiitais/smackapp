//
//  MessageService.swift
//  SmackAlpha
//
//  Created by Ghita on 10/29/17.
//  Copyright © 2017 Ghita. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class MessageService {
    
    static let instance = MessageService()
    var channels = [Channel]()
    var selectedChannel: Channel? //If we are not logged in, we don't have a channel
    var messages = [Message]()
    var unreadChannels = [String]() // unread channels IDs
    
    func findAllChannels(completion: @escaping CompletionHandler){ //GET REQUEST
        Alamofire.request(URL_GET_CHANNELS, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            
            if response.result.error == nil {
                guard let data = response.data else {return}
                // Data is an Array of Json objects (postman)
                if let json = JSON(data: data).array {
                    for item in json {
                        let name = item["name"].stringValue
                        let channelDescription = item["description"].stringValue
                        let id = item["_id"].stringValue
                        let channel = Channel(channelTitle: name, channelDescription: channelDescription, id: id)
                        self.channels.append(channel)
                    }
                   //after all the channels have been retrieved from the api, broadcast this notification -> channelVC add the observer
                    NotificationCenter.default.post(name: NOTIF_CHANNELS_LOADED, object: nil)
                    completion(true)
                }
                
            } else {
                completion(false)
               debugPrint(response.result.error as Any)
            }
        }
    }
    
    func findAllMessageForChannel(channelId: String, completion: @escaping CompletionHandler){
        Alamofire.request("\(URL_GET_MESSAGES)\(channelId)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.result.error == nil {
                self.clearMessages()
                guard let data = response.data else {return}
                if let json = JSON(data: data).array { // loop through data
                    for item in json {
                        let messageBody = item["messageBody"].stringValue
                        let channelId = item["channelId"].stringValue
                        let id = item["_id"].stringValue
                        let userName = item["userName"].stringValue
                        let userAvatar = item["userAvatar"].stringValue
                        let userAvatarColor = item["userAvatarColor"].stringValue
                        let timeStamp = item["timeStamp"].stringValue
                        
                        let message = Message(message: messageBody, userName: userName, channelId: channelId, userAvatar: userAvatar, userAvatarColor: userAvatarColor, timeStamp: timeStamp, id: id)
                        self.messages.append(message)
                    }
                    completion(true)
                    print(self.messages)
                }
                
            } else {
                debugPrint(response.result.error as Any)
                completion(false)
            }
        }

    }
    
    func clearMessages() {
        messages.removeAll()
    }
    
    
    
    
    func clearChannels() { //when we are logged out
        channels.removeAll()
    }
    
}
