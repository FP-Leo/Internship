//
//  showRequestsScreen.swift
//  guiApp
//
//  Created by Leo on 8.08.2023.
//

import SwiftUI

//Showing Request History
//Custom Classes used here are declared at the globalClasses.swift
struct showRequestsScreen: View {
    @Binding var currentSubScreen: screens
    //Array that will hold all the fetched requests
    @State private var requests: [Request] = []
    //Var that keeps track on which tab the view is on
    @State var tabIndex : Int = 1
    
    var body: some View{
        ZStack{
            Color.white.ignoresSafeArea(.all)
            ZStack{
                exitButton($currentSubScreen, newScreenValue: screens.none)
                VStack{
                    header
                    main
                }.background(RoundedRectangle(cornerRadius: 25).fill(Color.gray.opacity(0.3)))
                 .padding(EdgeInsets(top: 35, leading: 10, bottom: 10, trailing: 10))
            }
        }
    }
    
    var header: some View {
        HStack{
            Spacer()
            backButton // will make tab go one to the left
            currentPageLabel // displays the number of the tab we're on
            forwardButton // will make tab go one to the right
            Spacer()
            filterButton // to be implemented
        }.padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
    }
    
    var main: some View {
        //Display every request on a tab view so it's easly scrollable
        TabView(selection: $tabIndex){
            ForEach(requests.indices, id:\.self) { index in
                DetailedRequestView(request: requests[index]).tag(index + 1)
            }
        }.tabViewStyle(PageTabViewStyle())
         .onAppear {
            fetchData()
        }
    }
    //Go to the left or rotate
    var backButton: some View {
        Button{
            if( tabIndex > 1){
                tabIndex -= 1
            }
            else{
                tabIndex = requests.count
            }
        }label:{
            Image(systemName: "arrow.left")
                .foregroundColor(Color.black)
        }
    }
    //Display tab number
    var currentPageLabel: some View {
        TextField("Current Tab", value: $tabIndex, formatter: NumberFormatter())
            .frame(width: 30, height: 30)
            .padding(.leading, 20)
    }
    //Go to the right or rotate
    var forwardButton: some View {
        Button{
            if( tabIndex < requests.count){
                tabIndex += 1
            }
            else{
                tabIndex = 1
            }
        } label: {
            Image(systemName: "arrow.right")
                .foregroundColor(Color.black)
        }
    }
    //To be implemented
    var filterButton: some View {
        Button{
            
        } label:{
            Image(systemName: "line.3.horizontal.decrease.circle")
                .foregroundColor(Color.black)
        }.padding(.trailing, 10)
    }
    //Submiting GET request using custom API token get request history
    func fetchData() {
        guard let url = URL(string: "https://api.4me.qa/v1/requests") else {
            return
        }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer token", forHTTPHeaderField: "Authorization")
        request.setValue("rint-destek", forHTTPHeaderField: "X-4me-Account")
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let data = data {
                parseJSON(data: data)
            }
        }.resume()
    }
    //Decode the JSON file recieved using the global classes
    func parseJSON(data: Data) {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            requests = try decoder.decode([Request].self, from: data)
        } catch {
            print("Error parsing JSON: \(error)")
        }
    }
}

