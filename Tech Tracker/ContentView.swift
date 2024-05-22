//
//  ContentView.swift
//  Tech Tracker
//
//  Created by Gabriel Brown on 4/6/24.
//
import SwiftUI
import Foundation
import Combine

// Struct for Technician API
struct Technician: Identifiable, Codable {
    let name: String
    let status: String
    let time: Date
    
    var id: String { name }  // Computed property for Identifiable conformance

    enum CodingKeys: String, CodingKey {
        case name, status, time
    }
}

// Struct for Update API
struct TechnicianUpdate: Codable {
    let name: String
    let status: String
}

// Struct for History API
struct HistoryResponse: Decodable {
    let data: [TechnicianHistory]
    let meta: MetaData
}

// Struct for the technician portion of the history API
struct TechnicianHistory: Identifiable, Codable {
    let name: String
    let status: String
    let time: Date
    var id: UUID { UUID() }
    
    enum CodingKeys: String, CodingKey {
        case name, status, time
    }
}

// Struct for Metadata from History API
struct MetaData: Decodable {
    let current_page: Int
    let per_page: Int
    let total_pages: Int
    let total_count: Int
}

// The Sheet View for updating technician status
struct StatusUpdateView: View {
    @Binding var isPresented: Bool
    var technicianName: (String)
    var technicianStatus: (String)
    var updateAction: (String) -> Void
    
    @State private var newStatus: String = ""

    var body: some View {
        VStack(spacing: 15) {
            
            VStack(alignment: .leading, spacing: 5) {
                Text(technicianName).bold()
                    .font(.largeTitle)
                Text(technicianStatus).lineLimit(2).font(.title)
            }
            
            TextField("New Status", text: $newStatus)
                .padding() // Adds padding inside the TextField, making it taller
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.title3) // Increases the font size of the text field content
                .foregroundColor(.white)
                .padding(.horizontal, 20)
            
            Button(action: {
                updateAction(newStatus)
                isPresented = false
            }) {
                Text("Update")
                    .font(.headline) // Make the button text larger
                    .padding() // Add padding around the button text to make the button larger
                    .frame(minWidth: 0, maxWidth: .infinity) // Makes the button expand to full width
                    .background(Color.accent) // Sets the button background color to blue
                    .foregroundColor(.white) // Sets the button text color to white
                    .cornerRadius(10) // Rounds the corners of the button
            }
            .padding(.top, 10) // Adds some space above the button
            .padding(.horizontal, 30)
            Spacer().frame(width: 0, height: 5)
            HStack(spacing: 5) {
                Button(action: {
                    updateAction("In the Office")
                    isPresented = false
                }) {
                    Text("In the Office")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.accent)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                Spacer().frame(width: 10)
                Button(action: {
                    updateAction("At desk")
                    isPresented = false
                }) {
                    Text("At desk")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.accent)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }.padding(.horizontal, 25)
            HStack(spacing: 5) {
                Button(action: {
                    updateAction("At lunch")
                    isPresented = false
                }) {
                    Text("At lunch")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.accent)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                Spacer().frame(width: 10)
                Button(action: {
                    updateAction("At Hardy")
                    isPresented = false
                }) {
                    Text("At Hardy")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                        .background(Color.accent)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }.padding(.horizontal, 25)
            HStack(spacing: 5) {
                Button(action: {
                    updateAction("At Police Department")
                    isPresented = false
                }) {
                    Text("At Police Dpt")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.accent)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                Spacer().frame(width: 10)
                Button(action: {
                    updateAction("At City Hall")
                    isPresented = false
                }) {
                    Text("At City Hall")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.accent)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }.padding(.horizontal, 25)
            HStack(spacing: 5) {
                Button(action: {
                    updateAction("In a meeting")
                    isPresented = false
                }) {
                    Text("In a meeting")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.accent)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                Spacer().frame(width: 10)
                Button(action: {
                    updateAction("Out today")
                    isPresented = false
                }) {
                    Text("Out today")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.accent)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }.padding(.horizontal, 25)
            HStack(spacing: 5) {
                Button(action: {
                    updateAction("Running late")
                    isPresented = false
                }) {
                    Text("Running late")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.accent)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                Spacer().frame(width: 10)
                Button(action: {
                    updateAction("End of Shift")
                    isPresented = false
                }) {
                    Text("End of Shift")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.accent)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }.padding(.horizontal, 25)
        }
        .padding()
        .padding(.top, 150)
    }
}

// Single class for interpretting all API's. Has fetch functions for all 3.
class TechnicianViewModel: ObservableObject {
    
    // Variables for containing our data from our APIs
    @Published var technicians: [Technician] = []
    @Published var technicianHistories: [TechnicianHistory] = []
    @Published var currentPage = 1
    var totalPageCount = 1
    
    // Fetch technicians function for Technicians API
    func fetchTechnicians() {
        let urlString = "https://techtracker.gibbyb.com/api/technicians?apikey=APIKEYHERE"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    print("Networking error: \(error?.localizedDescription ?? "Unknown error")")
                }
                return
            }
            
            let decoder = JSONDecoder()
            // Had to make my own formatter because I couldn't get the JSON decoding to work right
            // This may have to do with the added ms
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            decoder.dateDecodingStrategy = .formatted(formatter)
            
            // Decode the JSON response.
            do {
                let decodedResponse = try decoder.decode([Technician].self, from: data)
                DispatchQueue.main.async {
                    self?.technicians = decodedResponse
                }
            } catch {
                DispatchQueue.main.async {
                    print("Decoding error: \(error)")
                }
            }
        }.resume()
    }
    
    // Update Technician Status function for the Update API
    func updateTechnicianStatus(name: String, newStatus: String) {
        let urlString = "https://techtracker.gibbyb.com/api/update_technicians?apikey=APIKEYHERE"
        guard let url = URL(string: urlString) else { return }

        let updateData = [TechnicianUpdate(name: name, status: newStatus)]
        // Wrap the array in a dictionary with a key that matches the backend expectation of an array.
        // Even though this app only lets you update one technician at a time, the API was written for a
        // web app that lets you update multiple technicians, so it expects an array.
        let wrappedData = ["technicians": updateData]
        guard let jsonData = try? JSONEncoder().encode(wrappedData) else {
            print("Failed to encode update data")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    print("Error updating technician: \(error.localizedDescription)")
                }
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                DispatchQueue.main.async {
                    print("Error with the response, unexpected status code: \(String(describing: response))")
                }
                return
            }

            // The database automatically adds this update to the history so we do not need to think about that in this app.
            DispatchQueue.main.async {
                print("Technician updated successfully.")
                // Refresh technician data
                self.fetchTechnicians()
            }
        }.resume()
    }
    
    // Fetch Technician History Function for the History API. Very similar to Technician API
    // but with some added metadata
    func fetchTechnicianHistory(page: Int = 1) {
        let urlString = "https://techtracker.gibbyb.com/api/history?apikey=APIKEYHERE&page=\(page)"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    print("Networking error: \(error?.localizedDescription ?? "Unknown error")")
                }
                return
            }
            
            let decoder = JSONDecoder()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            decoder.dateDecodingStrategy = .formatted(formatter)
            
            do {
                let jsonResponse = try decoder.decode(HistoryResponse.self, from: data)
                DispatchQueue.main.async {
                    self?.technicianHistories = jsonResponse.data
                    self?.totalPageCount = jsonResponse.meta.total_pages
                    self?.currentPage = jsonResponse.meta.current_page
                }
            } catch {
                DispatchQueue.main.async {
                    print("Decoding error: \(error)")
                }
            }
        }.resume()
    }

    func nextPage() {
        guard currentPage < totalPageCount else {return}
        currentPage += 1
        fetchTechnicianHistory(page: currentPage)
    }
    
    func previousPage() {
        guard currentPage > 1 else {return}
        currentPage -= 1
        fetchTechnicianHistory(page: currentPage)
    }

}


struct ContentView: View {
    @StateObject var viewModel = TechnicianViewModel()
    @State private var showingUpdateView = false
    @State private var selectedTechnicianName = ""
    @State private var selectedTechnicianCurrStatus = ""
    
    var body: some View {
        HStack {
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height:50)
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Tech Tracker")
                .bold()
                .font(.system(size: 36))
        }
    TabView {
        List {
            ForEach(viewModel.technicians) { technician in
                Button(action: {
                    self.showingUpdateView = true
                    self.selectedTechnicianName = technician.name
                    self.selectedTechnicianCurrStatus = technician.status
                }) {
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(technician.name).bold()
                                .font(.system(size: 23))
                            Text(technician.status).lineLimit(2)
                        }
                        Spacer()
                        VStack(alignment: .trailing, spacing: 5) {
                            VStack {
                                Text(technician.time, format: .dateTime.hour().minute()).font(.system(size: 20))
                                Text(technician.time, format: .dateTime.day().month()).font(.system(size: 18))
                            }
                        }
                    }
                    .foregroundColor(.primary)
                }
            }
        }
        .tabItem {
            Image(systemName: "pencil")
            Text("Update")
        }
        .onAppear {
            viewModel.fetchTechnicians()
        }
        .refreshable {
            viewModel.fetchTechnicians()
        }
        .sheet(isPresented: $showingUpdateView) {
            // Pass the selected technician name directly to an explicitly initialized StatusUpdateView
            StatusUpdateView(isPresented: $showingUpdateView,
                             technicianName: selectedTechnicianName,
                             technicianStatus: selectedTechnicianCurrStatus,
                             updateAction: { newStatus in
                viewModel.updateTechnicianStatus(name: selectedTechnicianName, newStatus: newStatus)
            })
        }
        
        VStack {
            List(viewModel.technicianHistories) { history in
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(history.name).bold().font(.system(size: 22))
                        Text(history.status).lineLimit(2)
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 5) {
                        Text(history.time, format: .dateTime.hour().minute()).font(.system(size: 20))
                        Text(history.time, format: .dateTime.day().month()).font(.system(size: 18))
                    }
                }
            }
            HStack {
                Button("Prev") {
                    viewModel.previousPage()
                }
                .disabled(viewModel.currentPage <= 1)
                .font(.title2)
                Spacer()
                Text("Page \(viewModel.currentPage) of \(viewModel.totalPageCount)").font(.title3)
                Spacer()
                Button("Next") {
                    viewModel.nextPage()
                }
                .disabled(viewModel.currentPage >= viewModel.totalPageCount)
                .font(.title2)
            }.padding()
        }
            .tabItem {
                Image(systemName: "book")
                Text("History")
            }
            .onAppear {
                viewModel.fetchTechnicianHistory()
            }
            .refreshable {
                viewModel.fetchTechnicianHistory()
            }
        }
    }
}

#Preview {
    ContentView()
}
