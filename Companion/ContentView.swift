//
//  ContentView.swift
//  Companion
//
//  Created by Anmol Jain on 10/7/22.
//

import SwiftUI

struct ContentView: View {
   
    @EnvironmentObject var store: DataStore
    
    @State var selectedTag: Int?
    
    var body: some View {
        VStack {
            Text("Companion")
                .padding()
            Spacer()
            
            Button("Authorize HealthKit") {
                store.authorizeHealthKit()
            }
            
            Spacer()
            
            Button("Print Today's Step Count") {
                store.printStepCount()
            }
            
            Text("\(store.steps)")
            
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .environmentObject(DataStore())
                .preferredColorScheme(.dark)
        }
    }
}
