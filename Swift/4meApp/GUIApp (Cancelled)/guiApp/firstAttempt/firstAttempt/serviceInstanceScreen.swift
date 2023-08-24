//
//  serviceInstanceScreen.swift
//  guiApp
//
//  Created by Leo on 11.08.2023.
//

import SwiftUI

struct serviceInstanceScreen: View {
    //To go back to the nav page that linked here
    @Environment(\.presentationMode) var goBack
    
    //To inform the newRequestScreen on what the user picked
    @Binding var currentService: String
    //Default nothing picked.
    @State var listIndex: Int = -1
    
    var rowHeight: CGFloat = 44
    
    let header: [String] = ["Rint Yardım Masası", "Bina Yönetimi Hizmetleri", "Bordro ve Özlük Hizmetleri", "Data Center Upgrade", "Muhasebe", "Satış Talepleri", "Şirket Aracı Hizmetleri", "None"]
    let footer: [String] = ["Yardım Masası", "Muhasebe", "Muhasebe", "Satış", "Muhasebe", "Satış", "Muhasebe", ""]
    
    var body: some View {
        VStack{
            Spacer()
            //Display Choices
            dataList
            //Get the selected
            submitButton
            Spacer()
        }
    }
    
    var dataList: some View {
        List{
            ForEach(header.indices, id:\.self) { index in
                addElement(text: header[index], footnote: footer[index], index: index).onTapGesture {
                    listIndex = index
                }
            }
        }
    }
    
    var submitButton: some View {
        Button{
            if listIndex != -1{
                currentService = header[listIndex]
                goBack.wrappedValue.dismiss()
            }
        } label:{
            Text("Submit")
                .frame(width: 150, height: 50)
                .background(Color.blue)
                .foregroundColor(Color.white)
                .contentShape(RoundedRectangle(cornerRadius: 5))
                .clipShape(RoundedRectangle(cornerRadius: 5))
        }
    }
    //Custom Function to align an Icon with a text and a footnote
    func addElement(text: String, footnote: String, index: Int) -> some View{
        HStack{
            Image(systemName: "gearshape.2").foregroundColor(Color.blue)
            VStack{
                leadingText(text)
                leadingText(footnote).font(.footnote)
            }
            Spacer()
            //Make it clear which one is selected
            if(listIndex == index){
                Image(systemName: "checkmark.seal")
                    .foregroundColor(Color.blue)
            }
        }
    }
}

