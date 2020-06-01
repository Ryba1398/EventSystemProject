//
//  EventTableViewCell.swift
//  ProjectApp
//
//  Created by Николай Рыбин on 22.04.2020.
//  Copyright © 2020 Николай Рыбин. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {

    @IBOutlet weak var EventNameLabel: UILabel!
    @IBOutlet weak var EventLocationLabel: UILabel!
    @IBOutlet weak var startDataLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    
    func SetFields(eventData: Event){
        EventNameLabel.text = eventData.title
        EventLocationLabel.text = eventData.location
        startDataLabel.text = DateFormater.convert(timestamp: eventData.startsAt, to: .prettyDate)
        startTimeLabel.text = DateFormater.convert(timestamp: eventData.startsAt, to: .time)
    }
}
