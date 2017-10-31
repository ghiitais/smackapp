//
//  MessageCell.swift
//  SmackAlpha
//
//  Created by Ghita on 10/30/17.
//  Copyright © 2017 Ghita. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    // Outlets
    
    @IBOutlet weak var userImage: CircleImage!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var timeStamp: UILabel!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func configureCell(message: Message){
        messageLabel.text = message.message
        userName.text = message.userName
        userImage.image = UIImage(named: message.userAvatar)
        userImage.backgroundColor = userDataService.instance.returnUIColor(components: message.userAvatarColor)
        
        // 2017-07-13T21:49:23.590Z
        guard var isoDate = message.timeStamp else {return}
        let end = isoDate.index(isoDate.endIndex, offsetBy: -5)
        isoDate = isoDate.substring(to: end)
    
    
        let isoFormatter = ISO8601DateFormatter()
        let chatDate = isoFormatter.date(from: isoDate.appending("Z"))
        
        let newFormatter = DateFormatter()
        newFormatter.dateFormat = "MMM d, h:mm a"
        
        if let finalDate = chatDate {
            let finalDate = newFormatter.string(from: finalDate)
            timeStamp.text = finalDate
        }
        
        
    }
    
    
    
    
    
    
    
    
    

}
