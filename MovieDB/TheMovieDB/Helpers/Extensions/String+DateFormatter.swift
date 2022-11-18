//
//  String+DateFormatter.swift
//  MovieDB
//
//  Created by Nestor Contreras Miranda on 17/11/22.
//

import Foundation

extension String {
    
    func dateFormatter() -> Date {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = "yyyy-MM-dd"
        
        let date = formatter.date(from: self) ?? Date()
        return date
    }
    
    func printFormattedDate() -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MMM dd,yyyy"
        return dateFormat.string(from: dateFormatter())
    }
}
