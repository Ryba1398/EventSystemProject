//
//  RoomsTableViewController.swift
//  ProjectApp
//
//  Created by Николай Рыбин on 25.04.2020.
//  Copyright © 2020 Николай Рыбин. All rights reserved.
//

import UIKit

class RoomsTableViewController: UITableViewController {
    
    var rooms: [Room]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if rooms != nil{
            return rooms!.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Room Cell", for: indexPath) as! RoomTableViewCell
        cell.roomNameLabel.text = rooms![indexPath.row].name
        return cell
    }
}
