//
//  ChatVC.swift
//  SmackAlpha
//
//  Created by Ghita on 10/6/17.
//  Copyright © 2017 Ghita. All rights reserved.
//

import UIKit



class ChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //Outlets
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var channelNameLabel: UILabel!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var messageTextBox: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var typingUsersLabel: UILabel!
    
    // Variables
    var isTyping = false
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendBtn.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        
        view.bindToKeyboard()
        let tap = UITapGestureRecognizer(target: self, action: #selector(ChatVC.handleTap))
        view.addGestureRecognizer(tap)
        
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
      
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        
        // Listen to the selected channel notification
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.channelSelected(_:)), name: NOTIF_CHANNEL_SELECTED, object: nil)
        
        if  AuthService.instance.isLoggedIn {
            AuthService.instance.findUserByEmail(completion: { (sucess) in
                NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
            })
        }
        // allowed to access the new messages whether or not the messages are coming from the channel selected
        
        SocketService.instance.getChatMessage { (newMessage) in
            if newMessage.channelId == MessageService.instance.selectedChannel?.id && AuthService.instance.isLoggedIn {
            MessageService.instance.messages.append(newMessage)
                self.tableView.reloadData()
                self.scrollDownToNewMessage()
            }
        }


     /*   SocketService.instance.getChatMessage { (success) in
            if success {
                self.tableView.reloadData()
                self.scrollDownToNewMessage()
            }
        } */
        
        SocketService.instance.getTypingUsers { (typingUsers) in
            guard let channelId = MessageService.instance.selectedChannel?.id else { return }
            var names = ""
            var numberOfTypers = 0
            
            for (typingUser, channel) in typingUsers {
                if typingUser != userDataService.instance.name && channel == channelId {
                    if names == "" {
                        names = typingUser
                    } else {
                        names = "\(names), \(typingUser)"
                    }
                    numberOfTypers += 1
                }
            }
            
            if numberOfTypers > 0 && AuthService.instance.isLoggedIn == true {
                var verb = "is"
                if numberOfTypers > 1 {
                    verb = "are"
                }
                self.typingUsersLabel.text = "\(names) \(verb) typing a message"
            } else {
                self.typingUsersLabel.text = ""
            }
        }
        
        
    }
    func scrollDownToNewMessage() {
    // scroll down to newest message
        if MessageService.instance.messages.count > 0 {
    
            let endIndex = IndexPath(row: MessageService.instance.messages.count - 1, section: 0)
            self.tableView.scrollToRow(at: endIndex, at: UITableViewScrollPosition.bottom, animated: false)
    }
    }
    
    @IBAction func messageBoxEditing(_ sender: Any) {
      guard let channelId = MessageService.instance.selectedChannel?.id else {return}
        if messageTextBox.text == "" {
            isTyping = false
            sendBtn.isHidden = true
            SocketService.instance.socket.emit("stopType", userDataService.instance.name, channelId)
        } else {
            if isTyping == false {
                sendBtn.isHidden = false
                 SocketService.instance.socket.emit("startType", userDataService.instance.name, channelId)
            }
            isTyping = true
        }
    }
    
    
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    @objc func userDataDidChange(_ notif: Notification){
        if AuthService.instance.isLoggedIn {
            onLogingGetMessages()
        } else {
            channelNameLabel.text = "Please log in"
            tableView.reloadData()
        }
    }
    
    @objc func channelSelected(_ notif: Notification){
         updateWithChannel()
    }

    func updateWithChannel() {
       let channelName = MessageService.instance.selectedChannel?.channelTitle ?? ""
        channelNameLabel.text = "#\(channelName)"
        getMessages()
    }
    
    @IBAction func sendBtn(_ sender: Any) {
        if AuthService.instance.isLoggedIn {
            guard let channelId = MessageService.instance.selectedChannel?.id else {return}
            guard let message = messageTextBox.text else {return}
            SocketService.instance.addMessage(messageBody: message, userId: userDataService.instance.id, channelId: channelId, completion: { (success) in
                if success{
                    self.messageTextBox.text = ""
                   self.messageTextBox.resignFirstResponder()
                    SocketService.instance.socket.emit("stopType", userDataService.instance.name, channelId)
                }
            })
        }
    }
    
    
    
    
    func onLogingGetMessages() {
        MessageService.instance.findAllChannels { (success) in
            if success {
                if MessageService.instance.channels.count > 0 {
                    MessageService.instance.selectedChannel = MessageService.instance.channels[0]
                    self.updateWithChannel()
                } else {
                    self.channelNameLabel.text = "No channels yet!"
                    }
                }
                }
                }
    
    func getMessages() {
        guard let channelId = MessageService.instance.selectedChannel?.id else {return}
        MessageService.instance.findAllMessageForChannel(channelId: channelId) { (success) in
            if success {
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as? MessageCell {
        let message = MessageService.instance.messages[indexPath.row]
        cell.configureCell(message: message)
        return cell
        } else {
            return UITableViewCell()
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.messages.count
    }
    
    
}

