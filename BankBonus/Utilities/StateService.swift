//
//  StateService.swift
//  BankBonus
//
//  Created by Prabhdeep Singh on 21/09/20.
//  Copyright © 2020 Prabh. All rights reserved.
//

import Foundation
import os.log

class StateService {
    
    static func fetchStates(completion: @escaping ([StateModel]?, Error?) -> Void) {
        let urlString = "http://localhost:5001/bankbonus-34ec2/us-central1/retrievStates"
        let url = URL(string: urlString)!
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                os_log(.debug, log: .default, "Error Fetching data from server")
                return
            }
            
            guard let data = data else {
                os_log(.debug, log: .default, "No Data available")
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                os_log(.debug, log: .default, "No Response")
                return
            }
            
            guard response.statusCode == 200 else {
                os_log(.debug, log: .default, "Wrong Status Code")
                return
            }
            print(data)
            //let stringData = String(data: data, encoding: .utf8)
            do {
                let dataModel = try JSONDecoder().decode([StateModel].self, from: data)
                print("States are \(dataModel)")
                completion(dataModel,nil)
            } catch let err{
                print(err)
                completion(nil,err)
                os_log(.info, log: .default, "Error in converting Data")
            }
            
        }.resume()
    }
    
    
}
