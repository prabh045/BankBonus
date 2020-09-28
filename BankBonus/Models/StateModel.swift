//
//  StateModel.swift
//  BankBonus
//
//  Created by Prabhdeep Singh on 21/09/20.
//  Copyright © 2020 Prabh. All rights reserved.
//

import Foundation

struct StateModel: Codable {
    var id: String
    var fields: Fields
    var createdTime: String
}

struct Fields: Codable {
    var shortName: String
    var fullName: String
    var relatedBankIds: Array<String>?
    
    enum CodingKeys: String, CodingKey {
        case shortName = "State_Short_Name_List"
        case fullName = "State_Full_Name_List"
        case relatedBankIds = "Master_Table"
    }
}
