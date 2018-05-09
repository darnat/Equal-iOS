//
//  Date+TimeAgo.swift
//  Equal
//
//  Created by Alexis DARNAT on 4/29/18.
//  Copyright © 2018 Alexis DARNAT. All rights reserved.
//

import Foundation

extension Date {
    
    public func timeAgo() -> String {
        let now = Date()
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: self, to: now)
        
        if let year = components.year,  year > 0 {
            return String(format: "%d years ago", year)
        }
        if let month = components.month, month > 0 {
            return String(format: "%d months ago", month)
        }
        if let day = components.day, day > 2 {
            return String(format: "%d days ago", day)
        }
        if let day = components.day, day == 2 {
            return String(format: "Yesterday")
        }
        return "Today"
    }
    
}
