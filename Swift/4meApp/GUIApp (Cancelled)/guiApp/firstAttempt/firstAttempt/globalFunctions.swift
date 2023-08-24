//
//  globalFunctions.swift
//  guiApp
//
//  Created by Leo on 14.08.2023.
//  Generic functions that are going to get used in different files for the same purpose

import SwiftUI

//Text Label with the Text aligned to the left
func trailingText(_ text: String) -> some View{
    HStack{
        Spacer()
        Text(text).foregroundColor(Color.primary)
    }
}


//Text Label with the Text aligned to the right
func leadingText(_ text: String) -> some View{
    HStack{
        Text(text).foregroundColor(Color.primary)
        Spacer()
    }
}

//Text Field with  custom Padding, Background Color and a corner Radius of 5
func customTextField(text:String ,bindingVar: Binding<String>) -> some View{
    TextField(text, text: bindingVar)
        .foregroundColor(Color.primary)
        .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 0))
        .background(Color(hue: 1.0, saturation: 0.005, brightness: 0.901))
        .cornerRadius(5)
}

// Function that creates a Text Label and Field Combo, Label's text is aligned to the right with a certain frame
func leadingLabelTextFieldCombo(labelText: String, width: CGFloat, textFieldText: String, bindingVar: Binding<String>) -> some View{
    HStack{
        trailingText(labelText).frame(width: width)
        customTextField(text: textFieldText, bindingVar: bindingVar)
    }
}

// Function that removes the padding from the inside of the Picker and aligns it to the left side
func leadingPicker<T: Hashable>(bindingVar: Binding<T>, text:String, content:[String]) -> some View{
    HStack(spacing: 0){
        Picker(selection: bindingVar, label: Text(text), content:{
                ForEach(content.indices, id:\.self){ index in
                    Text(content[index]).tag(index)
                }
        }).padding(EdgeInsets(top: -6, leading: -13, bottom: -8, trailing: -10))
        Spacer()
    }
}

//Function that creates a non editable text field to display data
func customDisplayTextField(label: String) -> some View {
    TextField("", text: .constant(label))
        .foregroundColor(Color.primary)
        .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 0))
        .background(Color(hue: 1.0, saturation: 0.005, brightness: 0.901))
        .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.blue, lineWidth: 2)
            )
        .cornerRadius(5)
        .disabled(true)
}

//Function that combines custom label and custom text field to show data
func customLabelFieldforDisplay(textLabel: String, textField: String) -> some View {
    VStack(spacing: 5){
        leadingText(textLabel)
        customDisplayTextField(label: textField)
    }
}

//Function to add a back button and custom animation
func exitButton(_ currentScreen: Binding<screens>, newScreenValue: screens) -> some View {
    VStack {
        HStack {
            Button {
                withAnimation(.easeInOut) {
                    currentScreen.wrappedValue = newScreenValue
                }
            } label: {
                Image(systemName: "xmark")
                    .foregroundColor(Color.black)
            }.font(.headline)
            .padding()
            Spacer()
        }
        Spacer()
    }
}

