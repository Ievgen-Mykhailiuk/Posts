//
//  Date+Extension.swift
//  Posts
//
//  Created by Евгений  on 12/09/2022.
//

import Foundation

extension Date {
    static func timeAgo(from date: Double) -> String {
        let endDate = Date()
        let startDate = Date(timeIntervalSince1970: date)
        let dateFormatter = RelativeDateTimeFormatter()
        let result = dateFormatter.localizedString(for: startDate, relativeTo: endDate)
        return result
    }
}
