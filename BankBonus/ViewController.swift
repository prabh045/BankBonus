//
//  ViewController.swift
//  BankBonus
//
//  Created by Prabhdeep Singh on 20/09/20.
//  Copyright © 2020 Prabh. All rights reserved.
//

import UIKit
import iOSDropDown

class ViewController: UIViewController {
    
    //MARK: Properties
    @IBOutlet weak var locationTextField: DropDown!
    @IBOutlet weak var bankDetailsTableView: UITableView!
    
    var stateViewModel = StateViewModel()
    var bankViewModel = BankViewModel()
    
    //MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setuUpTableView()
        stateViewModel.retrieveStates()
        
        stateViewModel.states.bind { [weak self] (_) in
            self?.setupDropDown()
        }
        bankViewModel.banks.bind { [weak self] (_) in
            DispatchQueue.main.async {
                self?.bankDetailsTableView.reloadData()
            }
        }
        
       
    }
    
    func setupDropDown() {
        
        locationTextField.optionArray = stateViewModel.states.value.map({ (state) -> String in
            return state.fields.fullName
        })
        
        if locationTextField.optionArray.count > 0 {
            if let bankIds = self.stateViewModel.getBankIds(index: 0) {
                print("Bank Ids are \(bankIds)")
                self.bankViewModel.fetchBanks(ids: bankIds)
            } else {
                self.bankDetailsTableView.reloadData()
                print("No ids found")
            }
        }
        
        locationTextField.didSelect { (state, index, id) in
            if let bankIds = self.stateViewModel.getBankIds(index: index) {
                print("Bank Ids are \(bankIds)")
                self.bankViewModel.fetchBanks(ids: bankIds)
            } else {
                self.bankViewModel.emptyBankArray()
                self.bankDetailsTableView.reloadData()
                print("No ids found")
            }
        }
        
        locationTextField.checkMarkEnabled = false
    }
    
    func setuUpTableView() {
        bankDetailsTableView.delegate = self
        bankDetailsTableView.dataSource = self
        bankDetailsTableView.register(UINib(nibName: "BankDetailCell", bundle: nil), forCellReuseIdentifier: "bankCell")
        bankDetailsTableView.contentInset = UIEdgeInsets.zero
        bankDetailsTableView.automaticallyAdjustsScrollIndicatorInsets = false
    }


}

//MARK: TableView Extension
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bankViewModel.banks.value.count == 0 ? 1 : self.bankViewModel.banks.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Just a Simple UI to display when no bank is available
        if self.bankViewModel.banks.value.count == 0 {
            let emptyCell = UITableViewCell()
            emptyCell.textLabel?.text = "No Results Available"
            return emptyCell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "bankCell", for: indexPath) as? BankDetailCell else {
            fatalError("Could not find cell")
        }
        
        cell.bankViewModel = self.bankViewModel
        cell.configureCell(forIndex: indexPath.row)
        cell.closure = { [weak self] (vc) in
            self?.present(vc, animated: true, completion: nil)
        }
        cell.alertClosure = { [weak self] (alert) in
            print("clouure ran")
            self?.present(alert, animated: true, completion: nil)
        }
//        cell.bankNameLabel.text = self.bankViewModel.getBankName(forIndex: indexPath.row)
//        cell.accountTypeLabel.text = self.bankViewModel.getAccountType(index: indexPath.row)
//        cell.bonusAmountLabel.text = "\(self.bankViewModel.getBonusAmount(index: indexPath.row))"
//        cell.bankDetailLabel.text = self.bankViewModel.getBankDetail(index: indexPath.row)
//        cell.validityLabel.text = self.bankViewModel.getValidityDate(index: indexPath.row)
        return cell
    }
}

