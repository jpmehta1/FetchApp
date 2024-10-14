import Foundation

class HomeViewModel: ObservableObject {
    @Published var groupedAndSortedData = [Int: [FetchData]]()
    private var session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
        fetchData()
    }

    func fetchData() {
        let urlString = "https://fetch-hiring.s3.amazonaws.com/hiring.json"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let task = session.dataTask(with: url) { [weak self] data, response, error in
            // Handle potential errors
            if let error = error {
                DispatchQueue.main.async {
                    print("DEBUG: Network Error \(error.localizedDescription)")
                }
                return
            }
            
            // Check if the HTTP response is valid
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

            // Ensure data is received
            guard let data = data else {
                DispatchQueue.main.async {
                    print("DEBUG: No data received")
                }
                return
            }

            // Attempt to decode the JSON data
            do {
                let decodedData = try JSONDecoder().decode([FetchData].self, from: data)
                DispatchQueue.main.async {
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
        var tempData = [Int: [FetchData]]()
        
        // Filter and group data
        for item in fetchedData {
            if let itemName = item.name {
                if itemName.isEmpty {
                    continue // Skip if name is empty
                }
                // Initialize the group if it doesn't exist
                if tempData[item.listID] == nil {
                    tempData[item.listID] = []
                }
                // Append item to the group
                tempData[item.listID]?.append(item)
            }
        }
        
        // Sort each group by name
        for (listID, items) in tempData {
            let sortedItems = items.sorted(by: { ($0.name ?? "") < ($1.name ?? "") })
            tempData[listID] = sortedItems
        }
        
        // Store the processed data
        self.groupedAndSortedData = tempData
        
        // Optionally print each group's details
        for (listID, items) in groupedAndSortedData.sorted(by: { $0.key < $1.key }) {
            print("List ID: \(listID)")
            for item in items {
                print("   ID: \(item.id), Name: \(item.name ?? "No name")")
            }
        }
    }
}
