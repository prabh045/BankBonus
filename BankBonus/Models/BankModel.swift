//
//  BankModel.swift
//  BankBonus
//
//  Created by Prabhdeep Singh on 22/09/20.
//  Copyright © 2020 Prabh. All rights reserved.
//

import Foundation

struct BankModel: Codable {
    var id: String
    var fields: BankFields
    var createdTime: String
}

struct BankFields: Codable {
    
    var bankName: String
    var accountName: String
    var bonusAmount: Int
    var bankLink: String?
    var bonusValidityDate: String?
    var bonusPayOutDate: Int
    var accountClosureDate: Int
    var directDeposit: Array<String>
    var directDepositAmount: Int?
    var directDepositFrequency: String?
    var directDepositMinOccurence: Int?
    var directDepositInitialWindow: Int?
    var maintenanceBalance: Array<String>
    var maintenanceDepositInitialWindow: Int?
    var maintenanceBalanceAmount: Int?
    var maintenanceBalanceDays: Int?
    
    
    enum CodingKeys: String, CodingKey {
        case bankName = "Bank_Name"
        case accountName = "Account_Name"
        case bonusAmount = "Bonus_Amount"
        case bankLink = "Link"
        case bonusValidityDate = "Bonus_Validity_Date"
        case bonusPayOutDate = "Bonus_Payout_Date"
        case accountClosureDate = "Account_Closure_Date"
        case directDeposit = "Direct_Deposit"
        case directDepositAmount = "Direct_Deposit_Amount"
        case directDepositFrequency = "Direct_Deposit_Frequency"
        case directDepositMinOccurence = "Direct_Deposit_Mimimum_Occurence"
        case directDepositInitialWindow = "Direct_Deposit_Initial_Window"
        case maintenanceBalance = "Maintenance_Balance"
        case maintenanceDepositInitialWindow = "Maintenance_Deposit_Initial_Window"
        case maintenanceBalanceAmount = "Maintenance_Balance_Amt"
        case maintenanceBalanceDays = "Maintenance_Balance_Days"
        
    }
    
    
}




