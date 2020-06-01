//
//  DateFormater.swift
//  ProjectApp
//
//  Created by Николай Рыбин on 21.05.2020.
//  Copyright © 2020 Николай Рыбин. All rights reserved.
//

import Foundation

class DateFormater{
    
    static let months = ["Января", "Февраля", "Марта", "Апреля", "Мая", "Июня", "Июля", "Августа", "Сентября", "Октября", "Ноября", "Декабря"]
    
    enum TimestampConverter {
        case time
        case date
        case prettyDate
    }
    
    static func convert(timestamp: Double, to: TimestampConverter) -> String {
        
        let date = Date(timeIntervalSince1970: timestamp)
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+3")
        dateFormatter.locale = NSLocale.current
        
        switch to {
        case .time:
            dateFormatter.dateFormat = "HH:mm"
        case .date:
            dateFormatter.dateFormat = "dd.MM.yyyy"
        case .prettyDate:
            let calendar = Calendar.current
            dateFormatter.dateFormat = "yyyy"
            return "\(calendar.component(.day, from: date)) \(months[calendar.component(.month, from: date)-1]) \(dateFormatter.string(from: date))"
        }
        
        return dateFormatter.string(from: date)
    }
}
