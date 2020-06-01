//
//  ErrorTableViewCell.swift
//  ProjectApp
//
//  Created by Николай Рыбин on 06.05.2020.
//  Copyright © 2020 Николай Рыбин. All rights reserved.
//

import UIKit

class ErrorTableViewCell: UITableViewCell {
    
    @IBOutlet weak var MessageLabel: UILabel!
    
    public func SetMessage(input: String){
        MessageLabel.text = input
    }
}
