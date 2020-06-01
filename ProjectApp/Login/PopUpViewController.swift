//
//  PopUpViewController.swift
//  ProjectApp
//
//  Created by Николай Рыбин on 13.04.2020.
//  Copyright © 2020 Николай Рыбин. All rights reserved.
//

import UIKit


class PopUpViewController: UIViewController {
    
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageTextView: UITextView!
    
    var message: String?
    
    var hideMessage: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageTextView.text = message
        messageView.layer.cornerRadius = 24
        self.messageView.alpha = 1.0
        
        if hideMessage! {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                UIView.animate(withDuration: 0.3,
                               animations: {self.messageView.alpha = 0.0},
                               completion: {(value: Bool) in
                                self.view.removeFromSuperview()
                })
            })
        }
    }
    
    func showMessage(message: String, parentVC: UIViewController){
        self.message = message
        parentVC.addChild(self)
        self.view.frame = parent!.view.frame
        parent!.view.addSubview(self.view)
        self.didMove(toParent: parent)
    }
    
    static func ShowErrorView(message: String, parent: UIViewController, hideMessage: Bool = false){
        
        
        let popUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popUpVCid") as! PopUpViewController
        popUpVC.hideMessage = hideMessage
        popUpVC.showMessage(message: message, parentVC: parent)
    }
}
