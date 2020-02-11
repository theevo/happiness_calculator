//
//  Entry.swift
//  NotificationPatternsJournal
//
//  Created by Trevor Walker on 2/4/20.
//  Copyright © 2020 Trevor Walker. All rights reserved.
//

import Foundation

class Entry {
    let title: String
    let happiness: Int
    var isIncluded: Bool
    
    init(title: String, happiness: Int, isIncluded: Bool) {
        self.title = title
        self.happiness = happiness
        self.isIncluded = isIncluded
    }
}
