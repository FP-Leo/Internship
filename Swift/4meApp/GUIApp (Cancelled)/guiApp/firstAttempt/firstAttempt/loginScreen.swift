//
//  loginScreen.swift
//  guiApp
//
//  Created by Leo on 9.08.2023.
//

import SwiftUI

//the Login screen of the program
struct loginScreen: View{
    //Var that gives info to the screen manager if the screen changed or not
    @Binding var currentScreen: screens
    //Vars that going to hold the user input
    @State var email: String = ""
    @State var password: String = ""
    
    var body: some View {
        ZStack{
            Color.white.ignoresSafeArea(.all)
            //loginPageTemplateOne
            loginTemplateTwo
        }
    }
    
    var loginPageTemplateOne: some View{
        //Simple log in form
        Group{
            VStack{
                //Function Declared in global.swift
                leadingLabelTextFieldCombo(labelText: "Email:", width: 100,textFieldText: "Email...", bindingVar: $email)
                leadingLabelTextFieldCombo(labelText: "Password:", width: 100, textFieldText: "Password...", bindingVar: $password)
                HStack{
                    //Empty frame to align the button with the TextField
                    HStack{
                    }.frame(width: 100)
                    loginButton
                }
            }.padding()
        }
    }
    
    var loginTemplateTwo: some View {
        Group{
            VStack(spacing: 10){
                VStack(spacing: 5){
                    leadingText("Email")
                    customTextField(text: "Email...", bindingVar: $email)
                }
                VStack(spacing: 5){
                    leadingText("Password")
                    customTextField(text: "Password...", bindingVar: $password)
                }
                loginButton
            }.padding()
        }
    }
    
    var loginButton : some View{
        Button {
            withAnimation(.easeInOut){
                currentScreen = screens.main
            }
        } label: {
            Text("Sing In")
             .frame(maxWidth: .infinity)
             .frame(height: 40)
             .background(Color.blue)
             .foregroundColor(Color.white)
             .contentShape(RoundedRectangle(cornerRadius: 5))
             .clipShape(RoundedRectangle(cornerRadius: 5))
        }
    }
}



