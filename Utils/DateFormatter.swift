//
//  DateFormatter.swift
//  Checklist creator
//
//  Created by Olga Klyushkina on 02.05.2020.
//  Copyright © 2020 klyushkina. All rights reserved.
//

import Foundation

extension DateFormatter {

    private static var currentLocaleDateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current

        return dateFormatter
    }

    static var shortWeekdayNames: [String] {
        return DateFormatter.currentLocaleDateFormatter.shortWeekdaySymbols
    }

}
