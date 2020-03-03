//
//  EntryCellTableViewCell.swift
//  NotificationPatternsJournal
//
//  Created by theevo on 3/3/20.
//  Copyright © 2020 Trevor Walker. All rights reserved.
//

import UIKit

protocol EntryTableViewCellDelegate: class {
    func switchToggledOnCell(cell: EntryCellTableViewCell)
}

class EntryCellTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var higherOrLowerLabel: UILabel!
    @IBOutlet weak var isEnabledSwitch: UISwitch!
    
    // MARK: - Properties
    var entry: Entry?
    weak var delegate: EntryTableViewCellDelegate?
    
    // MARK: - Helper Functions
    
    func setEntry(entry: Entry, averageHappiness: Int) {
        self.entry = entry
        updateUI(averageHappiness: averageHappiness)
    }
    
    func updateUI(averageHappiness: Int) {
        guard let entryToDisplay = entry else { return }
        titleLabel.text = entryToDisplay.title
        isEnabledSwitch.isOn = entryToDisplay.isIncluded
        higherOrLowerLabel.text = entryToDisplay.happiness >= averageHappiness ? "Higher" : "Lower"
        
    }
    
    @IBAction func toggleIsIncluded(_ sender: Any) {
        delegate?.switchToggledOnCell(cell: self)
    }
    
    
}
