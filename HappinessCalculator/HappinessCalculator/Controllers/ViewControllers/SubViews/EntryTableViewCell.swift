//
//  EntryTableViewCell.swift
//  NotificationPatternsJournal
//
//  Created by Trevor Walker on 2/4/20.
//  Copyright © 2020 Trevor Walker. All rights reserved.
//

import UIKit

// Creating our protocol
protocol EntryTableViewCellProtocol: class {
    //creating our function
    func tappedCell(cell: EntryTableViewCell)
}

class EntryTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var higherOrLowerLabel: UILabel!
    @IBOutlet weak var isEnabledSwitch: UISwitch!
    
    // MARK: - Properties
    weak var delegate: EntryTableViewCellProtocol?
    var entry: Entry?
    
    //When our cell gets deinitialized we want to remove out observer so that it doesn't just sit around in memory
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    /**
     This method sets the local entry of the cell, updates all the UIelements, and passes the average happiness
     
     - Parameter entry uses the passed in entry to update the locally saved entry plus update the UIElements on the cell with data from it
     - Parameter averageHappiness: passes `averageHappiness` to `calculateHappiness`
     */
    func setEntry(entry: Entry, averageHappiness: Int) {
        self.entry = entry
        updateUI(averageHappiness: averageHappiness)
        createObserver()
    }
    
    func updateUI(averageHappiness: Int) {
        guard let entry = entry else {return}
        titleLabel.text = entry.title
        higherOrLowerLabel.text = calculateHappiness(averageHappiness: averageHappiness)
        isEnabledSwitch.isOn = entry.isIncluded
    }
    /**
     Creates the observer for notification key `notificationKey`, declared on entryTableViewController. We add a selector, which is basically telling our observer what function to call when it gets hit, to call `recalculateHappiness`.
     */
    func createObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.recalculateHappiness), name: notificationKey, object: nil)
    }
    
    @objc func recalculateHappiness(notification: NSNotification) {
        guard let averageHappiness = notification.object as? Int else {return}
        higherOrLowerLabel.text = calculateHappiness(averageHappiness: averageHappiness)
        
    }
    /**
     Updates the higherorLowerLabel based on whether the entries happiness is higher, equal to, or lower than the averageHappiness
     */
    func calculateHappiness(averageHappiness: Int) -> String {
        guard let entry = entry else {return "Error: Happines Not Found"}
        print(averageHappiness)
        switch entry.happiness {
            //less than
        case  ..<averageHappiness:
            return "Lower"
            //equal to
        case averageHappiness:
            return "Average"
            //greater than or equal to
        case averageHappiness...:
            return "Higher"
        default:
            return "Error: Happines Not Found"
        }
    }
    
    @IBAction func isEnabledSwitchTapped(_ sender: UISwitch) {
        delegate?.tappedCell(cell: self)
    }
}
