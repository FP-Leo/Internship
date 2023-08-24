//
//  newRequestScreen#2.swift
//  guiApp
//
//  Created by Leo on 14.08.2023.
//  Same logic as the newRequestScreen.swift, simmilar code just different alignment.
//  Not yet decided which one will get used.
//  Code explanation is on the newRequestScreen.swift

import SwiftUI

struct newRequestScreen_2: View {
    
    @Binding var currentSubScreen: screens
    //user input
    @State var subjectText: String
    @State var bodyText: String
    @State var categoryIndex: Int = 0
    @State var impactVisibility: Bool = false
    @State var impactIndex: Int = 0
    @State var teamIndex: Int = 0
    @State var memberIndex: Int = 0
    @State var statusIndex: Int = 0
    @State var currentService: String = "Configure..."
    
    let categoryOptions: [String] = ["Incident", "RFC", "RFI", "Complaint", "Compliment", "Other"]
    
    let impactOptions: [String] = ["Low", "Medium", "High", "Top"]
    
    let teamList: [String] = ["None", "Yardım Masası Ekibi", "Data Center Destek"]
    
    let yardimMasasiEkibi: [String] = ["Ahmet Demirel", "Ali Kalafat", "Berkay Hapçıoğlu", "Burak Aydoğan", "Burak Demirtaş", "Eda", "Leonit Shabani", "Oğuzhan Üzüm"]
    
    let dataCenterEkibi: [String] = ["Ali Kalafat", "Eda", "Oğuzhan Üzüm"]

    let Status: [String] = ["Assigned", "Accepted", "In Progress", "Waiting For...", "Waiting For Customer", "Completed"]
    
    init(_ currentSubScreen: Binding<screens>) {
        self._currentSubScreen = currentSubScreen
        self.subjectText = ""
        self.bodyText = ""
        //customizing TextEditBox
        UITextView.appearance().textContainerInset =
            UIEdgeInsets(top: 12, left: 10, bottom: 0, right: 0)
        //UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        ZStack{
            Color.white.ignoresSafeArea(.all)
            //Back button
            exitButton($currentSubScreen, newScreenValue: screens.none)
            VStack{
                firstSection
                secondSection
                thirdSection
                Divider()
                fourthSection
                if categoryIndex == 0 || categoryIndex == 1 || categoryIndex == 2{
                    Divider()
                    fifthSection
                }
                Divider()
                sixthSection
                Divider()
                customButton
                //Spacer()
            }.padding()
        }
    }
    
    var firstSection : some View {
        VStack(spacing: 5){
            leadingText("Subject").font(.body)
            TextField("Subject", text: $subjectText)
                .foregroundColor(Color.primary)
                .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 0))
                .background(Color(hue: 1.0, saturation: 0.005, brightness: 0.901))
                .cornerRadius(5)
        }
    }
    
    var secondSection : some View {
        VStack(spacing: 5){
            leadingText("Internal Message").font(.body)
            TextEditor(text: $bodyText)
                .colorMultiply(Color(hue: 1.0, saturation: 0.005, brightness: 0.901))
                .cornerRadius(5)
                .frame(height: 200)
        }
    }
    
    var thirdSection: some View {
        HStack(spacing: 5){
            VStack(spacing: 5){
                leadingText("Requested by:")
                leadingText("Requested for:")
            }.frame(width: 120)
            VStack(alignment: .leading, spacing: 5){
                Text("Leonit Shabani").foregroundColor(Color.primary)
                Text("Leonit Shabani").foregroundColor(Color.primary)
            }
            Spacer()
        }
    }
    
    var fourthSection: some View {
        HStack(spacing: 5){
            VStack(spacing: 10){
                leadingText("Category:")
                if categoryIndex == 0{
                    leadingText("Impact:")
                }
            }.frame(width: 120)
            VStack(spacing: 10){
                leadingPicker(bindingVar: $categoryIndex, text: "Category", content: categoryOptions)
                if categoryIndex == 0{
                    leadingPicker(bindingVar: $impactIndex, text: "Impact", content: impactOptions)
                }
            }
        }
    }
    
    var fifthSection: some View {
        HStack(spacing: 5){
            VStack(spacing: 10){
                leadingText("Service Instance:")
                leadingText("Configuration Items:")
            }.frame(width: 170)
            VStack(spacing: 10){
                NavigationLink(destination: serviceInstanceScreen(currentService: $currentService)){
                    Text(currentService)
                        .foregroundColor(Color.blue)
                }
                NavigationLink(destination: configurationItemsScreen()){
                    Text("Configure...")
                        .foregroundColor(Color.blue)
                }
            }.padding(.top, 3)
            Spacer()
        }
    }
    
    var sixthSection : some View {
        HStack{
            VStack(spacing: 10){
                leadingText("Team:")
                if teamIndex != 0{
                   leadingText("Member:")
                }
                leadingText("Status:")
            }.frame(width: 120)
            VStack(spacing: 10){
                leadingPicker(bindingVar: $teamIndex, text: "Team", content: teamList)
                if teamIndex != 0{
                    leadingPicker(bindingVar: $memberIndex, text: "Members", content: teamIndex == 1 ? yardimMasasiEkibi : dataCenterEkibi)
                }
                
                leadingPicker(bindingVar: $statusIndex, text: "Status", content: Status)
            }
            Spacer()
        }
    }
    
    var customButton : some View {
        Button {
            
        } label: {
            Text("Submit")
                .frame(width: 250, height: 40)
                .background(Color.blue)
                .foregroundColor(Color.white)
                .contentShape(RoundedRectangle(cornerRadius: 10))
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

//struct newRequestScreen_2_Previews: PreviewProvider {
//    static var previews: some View {
//        newRequestScreen_2()
//    }
//}
