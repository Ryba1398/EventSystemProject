//
//  GuestInfoViewController.swift
//  ProjectApp
//
//  Created by Николай Рыбин on 23.04.2020.
//  Copyright © 2020 Николай Рыбин. All rights reserved.
//

import UIKit
import Alamofire

class GuestInfoViewController: UIViewController {
    
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var secondName: UILabel!
    @IBOutlet weak var guestCategory: UILabel!
    @IBOutlet weak var availableRooms: UILabel!
    @IBOutlet weak var callPhone: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    
    @IBOutlet weak var InfoView: UIView!
    
    
    var personUuid: String?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webRequest()
    }
    
    
    
    @IBAction func callPhone(_ sender: UIButton) {
        
        var phone = sender.titleLabel?.text!.replacingOccurrences(of: " ", with: "")
        phone = phone!.replacingOccurrences(of: "-", with: "")
        phone = phone!.replacingOccurrences(of: "(", with: "")
        phone = phone!.replacingOccurrences(of: ")", with: "")
        
        if let phoneURL = NSURL(string: ("tel://" + phone!)) {
            UIApplication.shared.open(phoneURL as URL, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func sendEmail(_ sender: Any) {
        
        print(emailButton.titleLabel!.text!)
        
        if let url = URL(string: "mailto:\(emailButton.titleLabel!.text!)") {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    }
    
    
    
    func webRequest(){
        let url = RequestInfo.getAdress(type: .person(personUuid!))
        
        DataLoader.LoadData(url: url) { (response, isConnected) in
            if(isConnected){
                
                do {
                    let jsonData = response!.data!
                    let guest = try JSONDecoder().decode(Guest.self, from: jsonData)
                    self.setInfo(guest)
                } catch {
                    print(error.localizedDescription)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + .microseconds(400000), execute: {
                        PopUpViewController.ShowErrorView(message: "Посетитель c таким QR кодом не найден" , parent: self)
                    })
                }
            }else{
                
                DispatchQueue.main.asyncAfter(deadline: .now() + .microseconds(400000), execute: {
                    PopUpViewController.ShowErrorView(message: "Проблемы с доступом к сети" , parent: self)
                })
            }
        }
    }
    
    func setInfo(_ guest: Guest){
        self.InfoView.isHidden = false
        
        self.firstName.text = guest.data.member.firstName + " " + guest.data.member.lastName
        self.secondName.text = guest.data.member.lastName
        
        self.callPhone.setTitle(guest.data.member.phone, for: .normal)
        self.emailButton.setTitle(guest.data.member.email, for: .normal)  //guest.data.member.email
        
        self.guestCategory.text = guest.data.role.name
        
        print(guest.data.role.roomsAvailable)
        
        if guest.data.role.roomsAvailable != ""{
            self.availableRooms.text = guest.data.role.roomsAvailable
        }else{
            self.availableRooms.text = "Никакие"
        }
    }
}
