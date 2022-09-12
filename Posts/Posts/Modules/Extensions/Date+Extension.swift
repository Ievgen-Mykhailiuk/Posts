//
//  Date+Extension.swift
//  Posts
//
//  Created by Евгений  on 12/09/2022.
//

import Foundation

extension Date {
    static func configureDate(with date: Double) -> String {
        var result: String
        let startDate = Date()
        let daysInMonth = 30
        let endDate = Date(timeIntervalSince1970: date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let components = Calendar.current.dateComponents([.day], from: endDate, to: startDate)
        guard let days = components.day else { return "" }
        if days > daysInMonth {
            result = "\(days/daysInMonth) monthes ago"
        } else {
            result = "\(days) days ago"
        }
        return result
    }
}
