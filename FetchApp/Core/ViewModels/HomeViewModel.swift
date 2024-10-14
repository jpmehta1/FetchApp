//
//  HomeViewModel.swift
//  FetchApp
//
//  Created by Jeet P Mehta on 13/10/24.
//
import Foundation

class HomeViewModel: ObservableObject {
    //the main array which has the sorted ListID's pointing to the array of Fetch Data models which have the same ListIDs
    @Published var groupedAndSortedData = [Int: [FetchData]]()
    
    //url session declared
    private var session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
        fetchData()
    }

    func fetchData() {
        //endpoint
        let urlString = "https://fetch-hiring.s3.amazonaws.com/hiring.json"
        
        //convert string to url object with error handling
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        //using weak self to avoid memory leaks through retain cycles
        let task = session.dataTask(with: url) { [weak self] data, response, error in
            // Handling potential errors
            if let error = error {
                DispatchQueue.main.async {
                    print("DEBUG: Network Error \(error.localizedDescription)")
                }
                return
            }
            
            // Checking if the HTTP response is valid
            if let httpResponse = response as? HTTPURLResponse {
                DispatchQueue.main.async {
                    print("DEBUG: Response code \(httpResponse.statusCode)")
                }
            } else {
                DispatchQueue.main.async {
                    print("DEBUG: No HTTP response")
                }
                return
            }

            // Ensuring data is received
            guard let data = data else {
                DispatchQueue.main.async {
                    print("DEBUG: No data received")
                }
                return
            }

            // Attempting to decode the JSON data
            do {
                let decodedData = try JSONDecoder().decode([FetchData].self, from: data)
                DispatchQueue.main.async {
                    //calling the processData method on the weak self
                    self?.processData(decodedData)
                }
            } catch {
                DispatchQueue.main.async {
                    print("DEBUG: Failed to decode with error \(error)")
                }
            }
        }
        
        task.resume()
    }
    
    func processData(_ fetchedData: [FetchData]) {
        //initialising a temporary data 2d array instance
        var tempData = [Int: [FetchData]]()
        
        // Filter and group data
        for item in fetchedData {
            //checks if name is nil
            if let itemName = item.name {
                if itemName.isEmpty {
                    continue // Skip if name is empty string
                }
                // Initializing the group if it doesn't exist
                if tempData[item.listID] == nil {
                    tempData[item.listID] = []
                }
                // Appending item to the group accroding to the listID
                tempData[item.listID]?.append(item)
            }
        }
        
        // Sort each group by name
        for (listID, items) in tempData {
            let sortedItems = items.sorted(by: { ($0.name ?? "") < ($1.name ?? "") })
            //replace the items in the tempData with the sorted data
            tempData[listID] = sortedItems
        }
        
        // Store the processed data
        self.groupedAndSortedData = tempData
        
       
    }
}
