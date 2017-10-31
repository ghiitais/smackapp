//
//  userDataService.swift
//  SmackAlpha
//
//  Created by Ghita on 10/26/17.
//  Copyright © 2017 Ghita. All rights reserved.
//

import Foundation
class userDataService {
    static let instance = userDataService()
    
    public private(set) var id = ""
    public private(set) var avatarColor = ""
    public private(set) var avatarName = ""
    public private(set) var email = ""
    public private(set) var name = ""
    
    func setUserData(id: String, avatarColor: String, avatarName: String, email: String, name: String) {
        self.id = id
        self.avatarColor = avatarColor
        self.avatarName = avatarName
        self.email = email
        self.name = name
    }
    
    func setAvatarName(avatarName: String){
        self.avatarName = avatarName
    }
    
    func returnUIColor(components: String) -> UIColor {
        let scanner = Scanner(string: components)
        let skipped = CharacterSet(charactersIn: "[], ")
        let comma = CharacterSet(charactersIn: ",")
        scanner.charactersToBeSkipped = skipped
        
        var r, g, b, a: NSString?
        scanner.scanUpToCharacters(from: comma, into: &r)
        scanner.scanUpToCharacters(from: comma, into: &g)
        scanner.scanUpToCharacters(from: comma, into: &b)
        scanner.scanUpToCharacters(from: comma, into: &a)
        
        let defaultColor = UIColor.lightGray
        
        guard let rUnwrapped = r else {return defaultColor}
        guard let gUnwrapped = g else {return defaultColor}
        guard let bUnwrapped = b else {return defaultColor}
        guard let aUnwrapped = a else {return defaultColor}
        
         let rfloat = CGFloat(rUnwrapped.doubleValue)
         let gfloat = CGFloat(gUnwrapped.doubleValue)
         let bfloat = CGFloat(bUnwrapped.doubleValue)
         let afloat = CGFloat(aUnwrapped.doubleValue)
        
        let newUIColor = UIColor(red: rfloat, green: gfloat, blue: bfloat, alpha: afloat)
        return newUIColor
    }
    
    func logoutUser() {
        id = ""
        name = ""
        avatarName = ""
        avatarColor = ""
        email = ""
        AuthService.instance.isLoggedIn = false
        AuthService.instance.authKey = ""
        AuthService.instance.userEmail = ""
        MessageService.instance.clearChannels()
        MessageService.instance.clearMessages()
    }
    

    
}
