//
//  StateViewModel.swift
//  BankBonus
//
//  Created by Prabhdeep Singh on 22/09/20.
//  Copyright © 2020 Prabh. All rights reserved.
//

import Foundation

class StateViewModel {
    
    var states = Box([StateModel]())
    
    func retrieveStates() {
        StateService.fetchStates { (states, error) in
            
            if let error = error {
                print("Error fetching states \(error)")
                return
            }
            
            self.states.value = states!
            print("States are \(self.states)")
        }
    }
    
    func getBankIds(index: Int) -> Array<String>? {
        return states.value[index].fields.relatedBankIds
    }
}
