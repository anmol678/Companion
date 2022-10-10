//
//  ContentView.swift
//  Companion
//
//  Created by Anmol Jain on 10/7/22.
//

import SwiftUI

struct HealthKitView: View {

    @EnvironmentObject var store: DataStore

    @State var selectedTag: Int?

    var body: some View {
        NavigationView {
            VStack {
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
                
                .navigationBarTitle("HealthKit Integration")

            }
        }
    }
}

struct HealthKitView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HealthKitView()
                .environmentObject(DataStore())
        }
    }
}
