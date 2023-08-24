//
//  newRequestScreen.swift
//  guiApp
//
//  Created by Leo on 9.08.2023.
//

import SwiftUI
//Submit New Request screen ( First Template/Design)
struct newRequestScreen: View {
    //Var that notifies mainScreen for any changes to the screen i.e. user wants to go back
    @Binding var currentSubScreen: screens
    //Vars that will hold the user input
    @State var subjectText: String
    @State var bodyText: String
    @State var categoryIndex: Int = 0
    @State var impactIndex: Int = 0
    @State var teamIndex: Int = 0
    @State var memberIndex: Int = 0
    @State var statusIndex: Int = 0
    @State var currentService: String = "Configure..."
    
    //String Arrays that will get displayed in pickers.
    let categoryOptions: [String] = ["Incident", "RFC", "RFI", "Complaint", "Compliment", "Other"]
    
    let impactOptions: [String] = ["Low", "Medium", "High", "Top"]
    
    let teamList: [String] = ["None", "Yardım Masası Ekibi", "Data Center Destek"]
    
    let yardimMasasiEkibi: [String] = ["Ahmet Demirel", "Ali Kalafat", "Berkay Hapçıoğlu", "Burak Aydoğan", "Burak Demirtaş", "Eda", "Leonit Shabani", "Oğuzhan Üzüm"]
    
    let dataCenterEkibi: [String] = ["Ali Kalafat", "Eda", "Oğuzhan Üzüm"]

    let Status: [String] = ["Assigned", "Accepted", "In Progress", "Waiting For...", "Waiting For Customer", "Completed"]
    //The only reason for this constructor to exist is that there s no other way to customize TextEditBox
    init(_ currentSubScreen: Binding<screens>) {
        self._currentSubScreen = currentSubScreen
        self.subjectText = ""
        self.bodyText = ""
        //Customizing TextEditBox
        UITextView.appearance().textContainerInset =
            UIEdgeInsets(top: 12, left: 10, bottom: 0, right: 0)
        //UITextView.appearance().backgroundColor = .clear
    }

    var body: some View{
        ZStack{
            Color.white.ignoresSafeArea(.all)
            //Back button
            exitButton($currentSubScreen, newScreenValue: screens.none)
            VStack(){
                Spacer()
                //Input form
                //Used group because a Stack can't hold more that 10 elements and a group counts as one.
                Group{
                    firstSection // The subject and Internal Note section
                    customDivider
                    secondSection // Request by, Requested for
                    customDivider
                }
                thirdSection // Category (and Impact)
                if categoryIndex == 0 || categoryIndex == 1 || categoryIndex == 2{
                    customDivider
                    fourthSection // Service Instance and Configuration Items
                }
                customDivider
                fifthSection // Team, Member, Status
                customDivider
                Spacer()
                customButton // Submit Button
                Spacer()
            }.padding()
        }
    }
    
    var customDivider : some View {
        Divider().padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 13))
    }
    // First section is designed to take the Subject and Internal Note input for the user
    var firstSection : some View {
        HStack(spacing: 5){
            VStack(alignment: .trailing, spacing: 30){
                //Custom functions from the globalFunctions.swift
                trailingText("Subject:").padding(.top, 7)
                trailingText("Internal Note:")
                Spacer()
            }
            .frame(width: 120)
            VStack(){
                TextField("Subject", text: $subjectText)
                    .foregroundColor(Color.primary)
                    .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 0))
                    .background(Color(hue: 1.0, saturation: 0.005, brightness: 0.901))
                    .cornerRadius(15)
                TextEditor(text: $bodyText)
                    .colorMultiply(Color(hue: 1.0, saturation: 0.005, brightness: 0.901))
                    .cornerRadius(15)
                    .frame(height: 200)
                Spacer()
            }
            Spacer()
        }.frame(height: 250)
    }
    //Second section that displays from whom this request is requested (automatic to be implemented) and should take user input as to for who is it requesting it for. ( right now it's static, to be implemented)s
    var secondSection: some View {
        HStack(spacing: 5){
            VStack(spacing: 10){
                //globalFunctions.swift
                trailingText("Requested by:")
                trailingText("Requested for:")
            }.frame(width: 120)
            VStack(alignment: .leading, spacing: 10){
                //To be implemented
                Text("Leonit Shabani").foregroundColor(Color.primary)
                Text("Leonit Shabani").foregroundColor(Color.primary)
            }
            Spacer()
        }
    }
    //Third section takes the Category and Impact input. Uses functions from globalFunctions.swift
    var thirdSection: some View {
        HStack(spacing: 5){
            VStack(spacing: 10){
                trailingText("Category:")
                if categoryIndex == 0{
                    trailingText("Impact:")
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
    //Fourth section redirects to the Service Instance and/or Configuration Items page to get input on those fields.
    var fourthSection: some View {
        HStack(spacing: 0){
            VStack(spacing: 10){
                //globalFunctions.swift
                leadingText("Service Instance:")
                leadingText("Configuration Items:")
            }.frame(width: 163)
            VStack(spacing: 13){
                NavigationLink(destination: serviceInstanceScreen(currentService: $currentService)){
                    HStack{
                        Text(currentService)
                            .foregroundColor(Color.blue)
                            .font(.custom("test", fixedSize: 14))
                        Spacer()
                    }
                }
                NavigationLink(destination: configurationItemsScreen()){
                    HStack{
                        Text("Configure...")
                            .foregroundColor(Color.blue)
                            .font(.custom("test", fixedSize: 14))
                        Spacer()
                    }
                }
            }.frame(width: 177).padding(.top, 5)
        }
    }
    //Final section. Takes input for the team field, member, and the status of the request. Uses functions from globalFunctions.swift
    var fifthSection : some View {
        HStack{
            VStack(spacing: 10){
                trailingText("Team:")
                if teamIndex != 0{
                   trailingText("Member:")
                }
                trailingText("Status:")
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
    //Button that is suppose to submit the request, to be implemented.
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

//struct newRequest_Previews: PreviewProvider {
//    static var previews: some View {
//        newRequestScreen()
//    }
//}

