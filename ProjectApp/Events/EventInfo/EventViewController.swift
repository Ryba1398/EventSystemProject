//
//  EventViewController.swift
//  ProjectApp
//
//  Created by Николай Рыбин on 22.04.2020.
//  Copyright © 2020 Николай Рыбин. All rights reserved.
//

import UIKit
import Alamofire

class EventViewController: UIViewController {
    
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var EventLocationLabel: UILabel!
    @IBOutlet weak var EventDataLabel: UILabel!
    @IBOutlet weak var EventWorkTimeLabel: UILabel!
    @IBOutlet weak var EventCapacityLabel: UILabel!
    @IBOutlet weak var RegistrationTypeLabel: UILabel!
    @IBOutlet weak var EventStatusLabel: UILabel!
    
    @IBOutlet weak var showRoomsButton: UIButton!
    @IBOutlet weak var showRolesButton: UIButton!
    
    @IBOutlet weak var ScrollView: UIScrollView!

    @IBOutlet weak var ContentView: UIView!
    
    var event: Event?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         self.tabBarController?.tabBar.isHidden = true
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //configureRefreshControl()
        sendWebRequest(event: event!);
    }
    
//    func configureRefreshControl () {
//        self.ScrollView.refreshControl = UIRefreshControl()
//        self.ScrollView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
//    }
//
//
//    @objc func handleRefreshControl() {
//        sendWebRequest(event: event!)
//        DispatchQueue.main.async {
//            self.ScrollView.refreshControl?.endRefreshing()
//        }
//    }
    
    func SetInfo(event: Event){
        eventTitleLabel.text = event.title
        EventLocationLabel.text = event.location
        EventDataLabel.text = self.getDate(event: event)
        EventWorkTimeLabel.text = self.getWorkTime(event: event)
        
        if event.peopleCapacity != nil{
            EventCapacityLabel.text =  "Вместимость: \(String(describing: event.peopleCapacity!)) гостей"
        }else{
            EventCapacityLabel.text = ""
        }
        
        RegistrationTypeLabel.text = event.getRegistrationType()
        EventStatusLabel.text = event.getEventStatus()
    }
    
    func getDate(event: Event) -> String{
        let startDate = DateFormater.convert(timestamp: event.startsAt , to: .date)
        let endDate = DateFormater.convert(timestamp: event.endsAt , to: .date)
        
        if(startDate == endDate){
            return startDate
        }
        
        return "\(startDate) — \(endDate)"
    }
    
    func getWorkTime(event: Event) -> String{
        let start = DateFormater.convert(timestamp: event.startsAt , to: .time)
        let end = DateFormater.convert(timestamp: event.endsAt , to: .time)
        return "\(start) — \(end)"
    }
    
    func sendWebRequest(event: Event){
        
        let url = RequestInfo.getAdress(type: .event(event.id))
        
        DataLoader.LoadData(url: url) { (response, isConnected) in
                
            if(isConnected){
                do {
                    let jsonData = response!.data!
                    let eventInfo = try JSONDecoder().decode(EventInfo.self, from: jsonData)
                    
                    //Set info about rooms

                    self.ContentView.isHidden = false
                    
                    self.SetInfo(event: event)
                    
                    let roomsContainer = self.children[0] as! RoomsTableViewController
                    roomsContainer.rooms = eventInfo.data.rooms
                    
                    if Float(eventInfo.data.rooms!.count) != 0 {
                        self.showRoomsButton.isHidden = false
                        DispatchQueue.main.async{
                            roomsContainer.tableView.reloadData()
                        }
                    }
                    //Set info about roles
                    
                    let rolesTable = self.children[1] as! RolesTableViewController
                    rolesTable.roles = eventInfo.data.memberRoles
                    
                    if Float(eventInfo.data.memberRoles!.count) != 0 {
                        self.showRolesButton.isHidden = false
                        DispatchQueue.main.async{
                            rolesTable.tableView.reloadData()
                        }
                    }
                    
                } catch {
                    print(error.localizedDescription)
                }
            }else{

                DispatchQueue.main.asyncAfter(deadline: .now() + .microseconds(400000), execute: {
                PopUpViewController.ShowErrorView(message: "Проблемы с доступом к сети" , parent: self)
                })

            }
        }
    }
}
