//
//  screenManager.swift
//  guiApp
//
//  Created by Leo on 8.08.2023.
//

import Foundation
import SwiftUI

//The screen that will manage the main views
struct screenManager: View {
    //Var that keeps info on which screen should be displayed, by default the first screen is the login one
    @State var currentScreen: screens = screens.login
    
    var body: some View {
        ZStack {
            //Get log in info
            loginScreen(currentScreen: $currentScreen)
            //Switch screens if the log in was successful, logic to be implemented later
            if currentScreen == screens.main{
                mainScreen(currentMainScreen: $currentScreen)
                    .transition(.move(edge: .trailing))
                    .zIndex(2)
            }
        }
    }
}


struct screenManager_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            screenManager().preferredColorScheme(.light)
            screenManager().preferredColorScheme(.dark)
        }
    }
}

