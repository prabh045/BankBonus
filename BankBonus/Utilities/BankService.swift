//
//  BankService.swift
//  BankBonus
//
//  Created by Prabhdeep Singh on 22/09/20.
//  Copyright © 2020 Prabh. All rights reserved.
//

import Foundation
import os.log

class BankService {
    
    static func fetchBanks(ids: [String],completion: @escaping ([BankModel]?, Error?) -> Void) {
        let urlString = "https://us-central1-bank-bonus.cloudfunctions.net/retrieveBanks"
        let url = URL(string: urlString)!
        
        var json = [String:Any]()
        json["bankIdArray"] = ids
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        do {
            let data = try JSONSerialization.data(withJSONObject: json, options: [])
            request.httpBody = data
        } catch{
            
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
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
                let dataModel = try JSONDecoder().decode([BankModel].self, from: data)
                completion(dataModel,nil)
            } catch let err{
                print(err)
                completion(nil,err)
                os_log(.info, log: .default, "Error in converting Data")
            }
            
        }.resume()
    }
    
    
}


