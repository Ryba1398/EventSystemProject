//
//  EventsTableViewController.swift
//  ProjectApp
//
//  Created by Николай Рыбин on 21.04.2020.
//  Copyright © 2020 Николай Рыбин. All rights reserved.
//

import UIKit
import Alamofire

class EventsTableViewController: UITableViewController {
    
    var events: Events?
    
    var indicatorMustHide = false
    
    func configureRefreshControl () {
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.alpha = 1.0
        self.refreshControl?.addTarget(self, action:
            #selector(handleRefreshControl),
                                       for: .valueChanged)
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        animateHiding()
    }
    
    @IBAction func logOut(_ sender: UIBarButtonItem) {
        logOut()
    }
    @objc func handleRefreshControl() {
        
        indicatorMustHide = true
        apiRequest()
        DispatchQueue.main.async {
            self.refreshControl?.endRefreshing()
        }
    }
    
    func animateHiding(){
        
        if indicatorMustHide{
            UIView.animate(withDuration: 0.2, animations: {self.refreshControl?.alpha = 0.0}, completion: {(value: Bool) in
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                    self.refreshControl?.alpha = 1.0
                    self.indicatorMustHide = false
                }
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureRefreshControl()
        apiRequest()
    }
    
    var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
    func apiRequest(){
        let url = RequestInfo.getAdress(type: .events)
        
        DataLoader.LoadData(url: url) { (response, isConnected) in
            if isConnected{
                do {
                    let jsonData = response!.data!
                    self.events = try JSONDecoder().decode(Events.self, from: jsonData)
                } catch {
                    print(error.localizedDescription)
                }
                
                DispatchQueue.main.async{
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Cell Info" {
            
            let cell = sender as! EventTableViewCell
            let indexPath = tableView.indexPath(for: cell)
            
            let vc = segue.destination as! EventViewController
            vc.event = events!.data[indexPath!.row]
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(events != nil){
            return events!.data.count
        }else if !isConnectedToInternet{
            return 1
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(events != nil){
            self.tableView.separatorStyle = .singleLine
            let cell = tableView.dequeueReusableCell(withIdentifier: "Event Cell" , for: indexPath) as! EventTableViewCell
            cell.SetFields(eventData: events!.data[indexPath.row])
            return cell
        }
        
        if(events?.data.count == 0){
            self.tableView.separatorStyle = .none
            let cell = tableView.dequeueReusableCell(withIdentifier: "Error Cell" , for: indexPath) as! ErrorTableViewCell
            cell.SetMessage(input: "Мероприятия еще не добавлены.")
            return cell
        }
        
        self.tableView.separatorStyle = .none
        let cell = tableView.dequeueReusableCell(withIdentifier: "Error Cell" , for: indexPath) as! ErrorTableViewCell
        cell.SetMessage(input: "Нет доступа к сети.\nОжидание соединения...")
        return cell
    }
    
    func logOut(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let secondVC = storyboard.instantiateViewController(identifier: "loginViewController")
        
        secondVC.modalPresentationStyle = .fullScreen
        secondVC.modalTransitionStyle = .coverVertical
        
        DataManager().isAppAuthorized = false
        
        present(secondVC, animated: true, completion: nil)
    }
}
