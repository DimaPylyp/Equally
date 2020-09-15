//
//  CurrencyManager.swift
//  Equally
//
//  Created by DIMa on 13.09.2020.
//  Copyright © 2020 DIMa. All rights reserved.
//

import Foundation

class NetworkManager: NSObject {
    private let baseURLString = "https://api.exchangeratesapi.io/latest"
    var searchString = ""
    private let urlSession = URLSession.shared
    
    var queryURL: URL? {
        URL(string: "\(baseURLString)?base=\(searchString)")
    }
    
    func getCurrency(completion: @escaping (Currency?, String) -> ()) {
        guard let url = queryURL else {
            completion(nil, "URL not valid")
            return
        }
        
        let dataTask = urlSession.dataTask(with: url) { data, response, error in
            if error != nil {
                completion(nil, error?.localizedDescription ?? "Connection error")
                return
            }
            
            if let data = data {
                do {
                    let currency = try JSONDecoder().decode(Currency.self, from: data)
                    completion(currency, "")
                } catch {
                    completion(nil, "Result can't be decoded")
                    return
                }
            } else {
                completion(nil, "Data is empty")
                return
            }
        }
        
        dataTask.resume()
    }
}
