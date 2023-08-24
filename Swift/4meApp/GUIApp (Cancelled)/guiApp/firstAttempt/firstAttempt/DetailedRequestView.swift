//
//  DetailedRequestView.swift
//  guiApp
//
//  Created by Leo on 14.08.2023.
//

import SwiftUI

struct DetailedRequestView: View {
    //Print the received request
    let request: Request
    
    var body : some View {
        ScrollView{
            Group{
                //View can hold only up to 10 elements, group counts as one.
                firstTenElements
                remainingElements
            }.padding(.trailing, 10)
        }.padding(EdgeInsets(top: 10, leading: 10, bottom: 40, trailing: 10))
    }
    //Checking if the fields are nil, if they're not print them using custom function from globalFunctions.swift
    var firstTenElements: some View{
         Group {
            customLabelFieldforDisplay(textLabel: "ID", textField: "\(request.id)")
            if(request.sourceID != nil){
                customLabelFieldforDisplay(textLabel: "Source ID", textField: request.sourceID!)
            }
            customLabelFieldforDisplay(textLabel: "Subject", textField: request.subject)
            customLabelFieldforDisplay(textLabel: "Category", textField: request.category.capitalized)
            if(request.impact != nil){
                customLabelFieldforDisplay(textLabel: "Impact", textField: request.impact!.capitalized)
            }
            if request.status != nil {
                customLabelFieldforDisplay(textLabel: "Status", textField: request.status!.capitalized)
            }
            if request.next_target_at != nil {
            customLabelFieldforDisplay(textLabel: "Next Target", textField: request.next_target_at!)
            }
            if request.completed_at != nil {
            customLabelFieldforDisplay(textLabel: "Completed At", textField: request.completed_at!)
            }
            if request.team != nil {
                customLabelFieldforDisplay(textLabel: "Team", textField: request.team!.name)
            }
            if request.member != nil {
                customLabelFieldforDisplay(textLabel: "Member", textField: request.member!.name)
            }
        }
    }
    
    var remainingElements: some View{
        Group{
            if request.grouped_into != nil {
                customLabelFieldforDisplay(textLabel: "Grouped Into", textField: request.grouped_into!)
            }
            if request.service_instance != nil {
                customLabelFieldforDisplay(textLabel: "Service Instance", textField: request.service_instance!.name)
            }
            if request.created_at != nil {
                customLabelFieldforDisplay(textLabel: "Created At", textField: request.created_at!)
            }
            if request.updated_at != nil {
                customLabelFieldforDisplay(textLabel: "Updated At", textField: request.updated_at!)
            }
            if request.nodeID != nil {
                customLabelFieldforDisplay(textLabel: "Node ID", textField: request.nodeID!)
            }
        }
    }
}


//struct DetailedRequestView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailedRequestView()
//    }
//}
