//
//  CurrenciesSelectTableViewController.swift
//  Equally
//
//  Created by Alexey Antonov on 15/09/2020.
//  Copyright © 2020 DIMa. All rights reserved.
//

import UIKit

class CurrenciesSelectTableViewController: UITableViewController {
    
    var sender: ViewController?

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sender == nil ? 0 : sender!.notDisplayedRates.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "cellId")

        cell.textLabel?.text = Array(sender!.notDisplayedRates.keys)[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sender!.displayedRates[Array(sender!.notDisplayedRates.keys)[indexPath.row]] = Array(sender!.notDisplayedRates.values)[indexPath.row]
        sender!.notDisplayedRates.removeValue(forKey: Array(sender!.notDisplayedRates.keys)[indexPath.row])
        self.dismiss(animated: true, completion: nil)
    }

}
