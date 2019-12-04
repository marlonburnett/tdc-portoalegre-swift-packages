//
//  DateFormatterService.swift
//  TheDevConf2019
//
//  Created by Marlon Burnett on 24/11/19.
//  Copyright © 2019 Marlon Burnett. All rights reserved.
//

import Foundation

public enum DateFormattingError: Error {
    case invalidIsoDateString
}

public protocol DateFormatterServiceContract {
    func parse(isoDateString: String) throws -> Date
    func stringRepresentingTime(for date: Date) -> String
}

public class DateFormatterService: DateFormatterServiceContract {
    public static let shared = DateFormatterService()
    
    private let isoDateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate]
        
        return formatter
    }()
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d 'de' MMMM 'de' YYYY"
        formatter.locale = Locale.init(identifier: "pt-BR")
        
        return formatter
    }()
        
    
    private init() {}
    
    public func parse(isoDateString: String) throws -> Date {
        guard let date = isoDateFormatter.date(from: isoDateString) else {
            throw DateFormattingError.invalidIsoDateString
        }
        
        return date
    }
    
    public func stringRepresentingTime(for date: Date) -> String {
        let dateNow = Date()
        
        let differenceInDays = Calendar.current.dateComponents([.day], from: date, to: dateNow).day ?? 0
        
        guard differenceInDays < 1 else {
            return dateFormatter.string(from: date)
        }
        
        let differenceInHours = Calendar.current.dateComponents([.hour], from: date, to: dateNow).hour ?? 0

        guard differenceInHours < 1 else {
            return "há \(differenceInHours) hora\(differenceInHours > 1 ? "s" : "")"
        }

        let differenceInMinutes = max(Calendar.current.dateComponents([.minute], from: date, to: dateNow).minute ?? 1, 1)

        return "há \(differenceInMinutes) minuto\(differenceInMinutes > 1 ? "s" : "")"
    }
}
