//
//  ContentView.swift
//  Companion
//
//  Created by Anmol Jain on 10/7/22.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var store: DataStore

    var body: some View {
        TabView(selection: $store.tab) {
            
            HealthKitView()
                .tabItem {
                    HStack{
                        Image("Home")
                       // Spacer()
                         
                    }
                    Text("Welcome")}.tag(2)

           /* PredictorView()
                .tabItem {
                    HStack{
                       
                     //   Image("Search")
                            //.resizable()
                            /*.frame(width: 0
                                   , height: 0)*/
                         //   .cornerRadius(50)
                    }
                  //  Text("Recommendations") }.tag(1)
*/
         Insights1()
                .tabItem {
                    HStack{
                       
                        Image("Search")
                            .resizable()
                          //  .frame(width: 200
                                  // , height:200)
                         //   .cornerRadius(50)
                    }
                    Text("Dashboard") }.tag(1)
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
