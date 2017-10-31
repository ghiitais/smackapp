//
//  ProfileVC.swift
//  SmackAlpha
//
//  Created by Ghita on 10/29/17.
//  Copyright © 2017 Ghita. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {

    //Outlets
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var userEmail: UILabel!
    
    @IBOutlet weak var bgView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        
    }
    @IBAction func logoutBtnPressed(_ sender: Any) {
        userDataService.instance.logoutUser()
        NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        dismiss(animated: true, completion: nil)
    }

    @objc func closeTap(_ recognizer: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func setUpView() {
        userName.text = userDataService.instance.name
        userEmail.text = userDataService.instance.email
        profileImage.image = UIImage(named: userDataService.instance.avatarName)
        profileImage.backgroundColor = userDataService.instance.returnUIColor(components: userDataService.instance.avatarColor)
        let closeTouch = UITapGestureRecognizer(target: self, action: #selector(ProfileVC.closeTap(_:)))
        bgView.addGestureRecognizer(closeTouch)
    }
    
    @IBAction func closeModalPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    

}
