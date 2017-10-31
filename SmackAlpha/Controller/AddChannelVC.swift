//
//  AddChannelVC.swift
//  SmackAlpha
//
//  Created by Ghita on 10/29/17.
//  Copyright © 2017 Ghita. All rights reserved.
//

import UIKit

class AddChannelVC: UIViewController {

    @IBOutlet weak var bgView: UIView!
    //Outlets
    
    @IBOutlet weak var channelName: UITextField!
    @IBOutlet weak var channelDescription: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }

    @IBAction func closeModalPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func createChannel(_ sender: Any) {
        guard let name = channelName.text, channelName.text != "" else {return}
        guard let description = channelDescription.text else {return}
        
        SocketService.instance.addChannel(name: name, description: description) { (success) in
            if success {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func setUpView() {
        let closeTouch = UITapGestureRecognizer(target: self, action: #selector(AddChannelVC.closeTap(_ :)))
        bgView.addGestureRecognizer(closeTouch)
        channelName.attributedPlaceholder = NSAttributedString(string: "name", attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.2588235294, green: 0.3294117647, blue: 0.7254901961, alpha: 0.5)])
         channelDescription.attributedPlaceholder = NSAttributedString(string: "description", attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.2588235294, green: 0.3294117647, blue: 0.7254901961, alpha: 0.5)])
        
    }
    
    @objc func closeTap(_ recognize: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
}
