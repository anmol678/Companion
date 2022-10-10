//
//  ContentView.swift
//  Companion
//
//  Created by Anmol Jain on 10/7/22.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        TabView {

            HealthKitView()
                .tabItem { Text("HealthKit") }.tag(2)

            PredictorView()
                .tabItem { Text("CoreML") }.tag(1)

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
