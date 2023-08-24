//
//  mainScreen.swift
//  guiApp
//
//  Created by Leo on 9.08.2023.
//

import SwiftUI
//The screen that will get displayed after the log in is successful
struct mainScreen: View {
    //Same as in the log in screen, notifies the screenManager if the main screen changess
    @Binding var currentMainScreen: screens
    //Switching views based on the action of the user, building a tree like hiearchy with main screens and their respective subscreens
    @State var mainSubScreen : screens = screens.none

    var body: some View{
        NavigationView {
            ZStack{
                Color.white.ignoresSafeArea(.all)
                //Default screen
                mainScr
                //Switching based on user input
                if mainSubScreen == screens.newRequests{
                    newRequestScreen($mainSubScreen)
                        .transition(.move(edge: .bottom))
                        .zIndex(2)
                }else if mainSubScreen == screens.showRequests{
                    showRequestsScreen(currentSubScreen: $mainSubScreen)
                        .transition(.move(edge: .trailing))
                        .zIndex(2)
                }
            }
            //Customizing the header
            .navigationBarHidden(mainSubScreen == screens.none ? false : true)
            .navigationBarItems(
                leading: leadingButton,
                trailing: trailingButton
            )
        }
    }
    
    var leadingButton : some View {
        //Button that will pop up a navigation menu to have the option to log out, not yet implemented
        //Right now it only redirects to the login screen with no logic applied
        Button(
            action: {
                withAnimation(.easeInOut){
                    currentMainScreen = screens.login
                }
             },  label: {
                 Image(systemName: "gear").foregroundColor(Color.black)
             }
        )
    }
    
    var trailingButton: some View {
        //Button that is supposed to redirect to the profile page. Not yet implemented
        Button(
            action: {
                    
              }, label: {
                 Image(systemName: "person.fill").foregroundColor(Color.black)
              }
        )
    }
    //Main Screen that will be displayed, it will show the options to the user
    var mainScr : some View {
        VStack{
            addSubScreenButton(buttonName: "New Request",
                      screenType: screens.newRequests)
            addSubScreenButton(buttonName: "Show Requests",
                      screenType: screens.showRequests)
        }.padding()
    }
    //Generic function to create more options if needed
    func addSubScreenButton(buttonName: String, screenType: screens) -> some View{
        Button(action: {
            withAnimation(.easeInOut){
                mainSubScreen = screenType
            }
        }){
            Text(buttonName)
                .frame(width: 250, height: 40)
                .background(Color.blue)
                .foregroundColor(Color.white)
                .contentShape(RoundedRectangle(cornerRadius: 10))
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}
