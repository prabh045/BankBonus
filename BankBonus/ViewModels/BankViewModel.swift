//
//  BankViewModel.swift
//  BankBonus
//
//  Created by Prabhdeep Singh on 22/09/20.
//  Copyright © 2020 Prabh. All rights reserved.
//

import Foundation

class BankViewModel {
    
    var banks = Box([BankModel]())
    
    func fetchBanks(ids: [String]) {
        BankService.fetchBanks(ids: ids) { (banks, error) in
            
            if let error = error {
                print("Error in fetching banks \(error.localizedDescription)")
                return
            }
            self.banks.value = banks!
            print("Banks are \(self.banks)")
            
        }
    }
    
    func emptyBankArray() {
        self.banks.value = []
    }
    
    func getBankName(forIndex: Int) -> String {
        return banks.value[forIndex].fields.bankName
    }
    
    func getAccountType(index:Int) -> String{
        return banks.value[index].fields.accountName
    }
    
    func getBonusAmount(index:Int) -> Int {
        return banks.value[index].fields.bonusAmount
    }
    
    func getBankDetail(index: Int) -> String{
        let firstPara = getDirectDepostBonusRequirementPara(index: index) + getMaintencanceBalBonusPara(index: index)
        
        let bonus = getBonusAmount(index: index)
        let accountClosureDate = getaccountClosureDate(index: index)
        let bonusPayDate = getBonusPayoutDate(index: index)
        
        let firstSentence = "$\(bonus) will be paid in \(bonusPayDate) days after the bonus requirements are met."
        let secondSentence = accountClosureDate == 0 ? " You can close the bank account once you receive the bonus" : "You must keep the bank account(s) open for \(accountClosureDate) days from the date of account opening"
        let secondPara = firstSentence + secondSentence
        
        return firstPara + "\n" + "\n" + secondPara
    }
    
    private func getDirectDepostBonusRequirementPara(index: Int) -> String{
        guard let directDeposit = banks.value[index].fields.directDeposit.first else {return ""}
       let isDirectRequired = Constants.directDeposit[directDeposit]!
        if isDirectRequired {
           let frequency = banks.value[index].fields.directDepositFrequency
            switch frequency {
            case Constants.aggregate:
                print("Aggregate")
                if banks.value[index].fields.directDepositMinOccurence! > 1 {
                    return "You are required to get a minimum of \( banks.value[index].fields.directDepositMinOccurence ?? -1) direct deposits such that in aggregate you deposit $\( banks.value[index].fields.directDepositAmount ?? -1).The first direct deposit should be made in \( banks.value[index].fields.directDepositInitialWindow ?? -1)) days from the account opening date."
                } else if banks.value[index].fields.directDepositMinOccurence == 1 {
                    return "You are required, in aggregate, to get $\( banks.value[index].fields.directDepositAmount ?? -1)) in direct deposits. The first direct deposit should be made in \(banks.value[index].fields.directDepositInitialWindow ?? -1) days from the account opening date."
                } else {
                    return ""
                }
            case Constants.monthly:
                return "You are required to get \( banks.value[index].fields.directDepositMinOccurence ?? -1) monthly direct deposits such that direct deposits in aggregate exceeds $ \( banks.value[index].fields.directDepositAmount ?? -1) every month for minimum of \( banks.value[index].fields.directDepositMinOccurence ?? -1) months. The first monthly direct deposit should be met within \( banks.value[index].fields.directDepositInitialWindow ?? -1)days of opening the account."
            case Constants.once:
                return "You are required to get at least one direct deposit of an amount greater than $\( banks.value[index].fields.directDepositAmount ?? -1) within \( banks.value[index].fields.directDepositInitialWindow ?? -1) days of opening the account."
            default:
                return ""
            }
        }else {
            return ""
        }
        
        
    }
    
    private func getMaintencanceBalBonusPara(index: Int) -> String {
        guard let mainBalReq = banks.value[index].fields.maintenanceBalance.first else {return ""}
        
        let isMainBalRequired = Constants.directDeposit[mainBalReq]!
        //flow after mainBalRequired
        print("Maintain bal required \(isMainBalRequired)")
        if isMainBalRequired {
            
             guard let directDeposit = banks.value[index].fields.directDeposit.first else {return ""}
            let isDirectRequired = Constants.directDeposit[directDeposit]!
            //flow after directdepo reuired
            if isDirectRequired {
                
                let maintainInitialWindow = banks.value[index].fields.maintenanceDepositInitialWindow!
                
                switch maintainInitialWindow {
                case 0:
                    return "You are also required to open the account with a deposit of $\(banks.value[index].fields.maintenanceBalanceAmount ?? -1) in new money and maintain the daily average account balance for [Maintenance_Balance_Days] days."
                case 0...Int.max:
                    return "You are also required to deposit $ \(banks.value[index].fields.maintenanceBalanceAmount ?? -1) in new money within \(banks.value[index].fields.maintenanceDepositInitialWindow ?? -1) days of opening the account and maintain the daily average account balance for \(banks.value[index].fields.maintenanceBalanceDays ?? -1) days."
                default:
                    return ""
                }

                
            } else {
                let maintainInitialWindow = banks.value[index].fields.maintenanceDepositInitialWindow!
                
                switch maintainInitialWindow {
                case 0:
                    return "You are required to open the account with a deposit of $ \(banks.value[index].fields.maintenanceBalanceAmount ?? -1) in new money and maintain the daily average account balance for \(banks.value[index].fields.maintenanceBalanceDays ?? -1) days."
                case 0...Int.max:
                    return "You are required to deposit $\(banks.value[index].fields.maintenanceBalanceAmount ?? -1) in new money within \(banks.value[index].fields.maintenanceDepositInitialWindow ?? -1) days of opening the account and maintain the daily average account balance for \(banks.value[index].fields.maintenanceBalanceDays ?? -1) days."
                default:
                    return ""
                }
            }
            
        } else {
            return ""
        }
    }
    
    func getBankLink(index: Int) -> String? {
        return banks.value[index].fields.bankLink
    }
    
    func getValidityDate(index: Int) -> String? {
        if let date = banks.value[index].fields.bonusValidityDate {
            return "Apply Before \(dateFormatter(date: date) ?? "")"
        } else {
            return nil
        }
    }
    
    private func getBonusPayoutDate(index: Int) -> Int {
        return banks.value[index].fields.bonusPayOutDate
    }
    
    private func getaccountClosureDate(index: Int) -> Int {
        return banks.value[index].fields.accountClosureDate
    }
    
    private func dateFormatter(date:String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD"
        
        let newFormat = DateFormatter()
        newFormat.dateFormat = "MMM DD, YYYY"
        
        let newDate = dateFormatter.date(from: date)!
    
        return newFormat.string(from: newDate)
    }
    
    
}
