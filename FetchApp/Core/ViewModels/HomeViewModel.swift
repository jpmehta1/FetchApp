import Foundation

class HomeViewModel: ObservableObject {
    @Published var groupedAndSortedData = [Int: [FetchData]]()

    init() {
        fetchData()
    }

    func fetchData() {
        let urlString = "https://fetch-hiring.s3.amazonaws.com/hiring.json"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    print("DEBUG: Network Error \(error.localizedDescription)")
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    print("DEBUG: No HTTP response")
                }
                return
            }
            DispatchQueue.main.async {
                print("DEBUG: Response code \(httpResponse.statusCode)")
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    print("DEBUG: No data received")
                }
                return
            }

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
        }.resume()
    }
    
    func processData(_ fetchedData: [FetchData]) {
        var tempData = [Int: [FetchData]]()
        
        // Group and filter data
        for item in fetchedData {
            guard let itemName = item.name, !itemName.isEmpty else {
                continue // Skip items with null or empty names
            }

            tempData[item.listID, default: []].append(item)
        }
        
        // Sort each group by name
        for (listID, items) in tempData {
            tempData[listID] = items.sorted(by: { $0.name! < $1.name! })
        }
        
        // Store sorted and grouped data
        self.groupedAndSortedData = tempData
        
        // Print each item in a detailed format
        for (listID, items) in groupedAndSortedData.sorted(by: { $0.key < $1.key }) {
            print("List ID: \(listID)")
            for item in items {
                print("   ID: \(item.id), Name: \(item.name ?? "No name")")
            }
        }
    }
}
