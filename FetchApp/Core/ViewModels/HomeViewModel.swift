//
//  HomeViewModel.swift
//  FetchApp
//
//  Created by Jeet P Mehta on 13/10/24.
//

import Foundation

class HomeViewModel: ObservableObject{
    init(){
        fetchData()
    }
    func fetchData(){
        //API endpoint for fetching data
        let urlString = "https://fetch-hiring.s3.amazonaws.com/hiring.json"
        //convert the url string to a URL object
        
        
        guard let url = URL(string: urlString) else{
            return
        }
        
        
        URLSession.shared.dataTask(with: url){data, response, error in
          
        //error handling while starting a new data task
        if let error = error {
                print("DEBUG: Error  \(error.localizedDescription)")
                return
            }
        
        //printing the response code
        if let response = response as? HTTPURLResponse {
                print("DEBUG: Response code \(response.statusCode)")
        }
            
        
        //take the data and covert it to a string to see whether we're receiving the data properly
        guard let data = data else { return }
            let dataString  = String(data: data,encoding: .utf8)
            print(dataString)
            
        }.resume()
        
    }
    
    
}
