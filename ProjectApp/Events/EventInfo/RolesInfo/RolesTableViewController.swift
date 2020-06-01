//
//  RolesTableViewController.swift
//  ProjectApp
//
//  Created by Николай Рыбин on 03.05.2020.
//  Copyright © 2020 Николай Рыбин. All rights reserved.
//

import UIKit

class RolesTableViewController: UITableViewController {
    
    var roles: [MemberRole]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if roles != nil{
            return roles!.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Role Cell", for: indexPath) as! RoleTableViewCell
        cell.RoleLabel.text = roles![indexPath.row].name
        return cell
    }
}
