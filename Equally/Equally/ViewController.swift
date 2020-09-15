//
//  ViewController.swift
//  Equally
//
//  Created by DIMa on 12.09.2020.
//  Copyright © 2020 DIMa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private let networkManager = NetworkManager()
    var displayedRates: [String: Double] = ["USD": 0, "EUR": 0, "CAD": 0, "GBP": 0] {
        didSet{
        tableView.reloadData()
        }}
    var notDisplayedRates = [String: Double]()
    private var amount: Double = 1.00
    
    var currentCurrency: Currency? {
        didSet{
            if oldValue != nil {
                displayedRates[oldValue!.base] = 0
            }
            self.baseCurrencyLabel.text = self.currentCurrency?.base
            
            for currency in displayedRates.keys {
                displayedRates[currency] = currentCurrency?.rates[currency]
            }
            
            if currentCurrency != nil {
                for currency in currentCurrency!.rates {
                    if !displayedRates.keys.contains(currency.key) {
                        notDisplayedRates["\(currency.key)"] = currency.value
                    }
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    let baseCurrencyLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(25)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let amountTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textAlignment = .right
        textField.placeholder = "enter amount"
        textField.keyboardType = UIKeyboardType.decimalPad
        return textField
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.horizontal
        stackView.distribution = UIStackView.Distribution.fillEqually
        stackView.backgroundColor = .red
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkManager.searchString = "PLN"
        view.translatesAutoresizingMaskIntoConstraints = true
        view.backgroundColor = .white
        
        getData()
        
        amountTextField.addExtraToolbar(onDone: (target: self, action: #selector(self.tapDone)), onCancel: (target: self, action: #selector(self.tapCancel)))
        amountTextField.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        setView()
        setStackView()
        setTableView()
        
    }
    
    func setStackView(){
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(baseCurrencyLabel)
        stackView.addArrangedSubview(amountTextField)
        
        stackView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 15).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    func setView(){
        self.view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setTableView(){
        view.addSubview(tableView)
        
        tableView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 0).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
    
    func getData(){
                networkManager.getCurrency { (data, error) in
            if error == "" {
                DispatchQueue.main.async {
                    self.currentCurrency = data
                    self.baseCurrencyLabel.text = self.currentCurrency?.base
                }
            }
        }
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
        textField.font = textField.font?.withSize(20)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text != nil && textField.text != "" {
            textField.font = textField.font?.withSize(30)
            amount = Double(textField.text!)!
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } else {
            amount = 1
        }
    }
    
    @objc func tapDone(){
        amountTextField.resignFirstResponder()
    }
    
    @objc func tapCancel(){
        amountTextField.text = ""
        amountTextField.resignFirstResponder()
    }
    
    @objc func buttonAction(_ sender: UIButton!) {
        let vc = CurrenciesSelectTableViewController()
        vc.sender = self
        self.present(vc, animated: true)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Exchange rate:"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(displayedRates.count)
        
        return currentCurrency != nil ? displayedRates.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "cellId")
        cell.textLabel?.text = currentCurrency!.getFlag(for: Array(displayedRates.keys)[indexPath.row])
        let notRoundedRateString = Array(displayedRates.values)[indexPath.row]
        cell.detailTextLabel?.text = String(round(notRoundedRateString * amount * 100) / 100)
        cell.detailTextLabel?.textColor = .black
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.networkManager.searchString = Array(displayedRates.keys)[indexPath.row]
        getData()
        
        notDisplayedRates[Array(displayedRates.keys)[indexPath.row]] = Array(displayedRates.values)[indexPath.row]
        displayedRates[Array(displayedRates.keys)[indexPath.row]] = Array(displayedRates.values)[indexPath.row]
        displayedRates.removeValue(forKey: Array(displayedRates.keys)[indexPath.row])
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 75))
        customView.backgroundColor = .gray
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 75))
        button.setTitle("Select to add new", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        customView.addSubview(button)
        
        return customView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "delete") { (action, indexPath) in
            // delete item at indexPath
            self.displayedRates.removeValue(forKey: Array(self.displayedRates.keys)[indexPath.row])
            tableView.reloadData()
        }
        return [delete]
    }
    
}
