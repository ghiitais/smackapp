//
//  createAccountVC.swift
//  SmackAlpha
//
//  Created by Ghita on 10/6/17.
//  Copyright © 2017 Ghita. All rights reserved.
//

import UIKit

class createAccountVC: UIViewController {

    //Outlets
    
    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    // variables
    
    var avatarName = userDataService.instance.avatarName
    var avatarColor = "[0.5, 0.5, 0.5, 1]"
    var bgColor: UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.isHidden = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(createAccountVC.handleTap))
        view.addGestureRecognizer(tap)
    }
    
    @objc func handleTap () {
        
        view.endEditing(true)
    }
    override func viewDidAppear(_ animated: Bool) {
        if userDataService.instance.avatarName != "" {
            userImage.image = UIImage(named: userDataService.instance.avatarName)
            avatarName = userDataService.instance.avatarName
            if avatarName.contains("light") && bgColor==nil { // so it shows up at first
                userImage.backgroundColor = UIColor.lightGray
            }
        }
        
    }
    @IBAction func createAccountPressed(_ sender: Any) {
        spinner.isHidden = false
        spinner.startAnimating()
        guard let email = emailTxt.text, emailTxt.text != ""  else {return}
        guard let password = passwordTxt.text, passwordTxt.text != "" else {return}
        guard let name = userNameTxt.text, userNameTxt.text != "" else {return}
        
        
        AuthService.instance.registerUser(email: email, password: password) { (success) in
            if success {
                AuthService.instance.loginUser(email: email, password: password, completion: {
                    (success) in
                    if success {
                        AuthService.instance.createUser(name: name, email: email, avatarName: self.avatarName, avatarColor: self.avatarColor, completion: { (success) in
                            if success {
                                self.spinner.isHidden = true
                                self.spinner.stopAnimating()
                                self.performSegue(withIdentifier: "unwindToChannel", sender: nil)
                                NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil) // when we create an account the notificaiton is broadcast
                            }
                        })
                    }
                })
            }
        }
    }
    
    
    
    @IBAction func pickBgColorPressed(_ sender: Any) {
         //randomly generated number between 0 and 255
        let r = CGFloat(arc4random_uniform(255)) / 255
         let g = CGFloat(arc4random_uniform(255)) / 255
         let b = CGFloat(arc4random_uniform(255)) / 255
        
        bgColor = UIColor(red: r, green: g, blue: b, alpha: 1)
        avatarColor = "[\(r), \(g), \(b), 1]"
        
        UIView.animate(withDuration: 0.2) {
            self.userImage.backgroundColor = self.bgColor
        }
    }
    
    
    @IBAction func pickAvatarPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_AVATAR_PICKER, sender: nil)
    }
    @IBAction func closeBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "unwindToChannel", sender: nil)
    }
    
  
}
