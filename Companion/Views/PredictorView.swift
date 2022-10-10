//
//  PredictorView.swift
//  Companion
//
//  Created by Anmol Jain on 10/9/22.
//

// source: https://towardsai.net/p/machine-learning/deploy-a-python-machine-learning-model-on-your-iphone

import SwiftUI
import CoreML
import Foundation

struct PredictorView: View {
  
    @State private var houseAge = 60.0
    @State private var averageRooms = 10.0
    @State private var averageOccupants = 7.0
    
  @State private var alertTitle = ""
  @State private var alertMessage = ""
  @State private var showingAlert = false
    
  var body: some View {
      NavigationView {
        HStack {
            VStack {
                
                Spacer()
            
                Text("House Attributes")
                    .font(.body)
                Stepper(value: $houseAge, in: 1...100, step: 5) {
                    Text("House Age: \(houseAge)")
                }
                    
                Stepper(value: $averageRooms, in: 1...20, step: 1) {
                    Text("Average Rooms: \(averageRooms)")
                }
                
                Stepper(value: $averageOccupants, in: 1...10, step: 1) {
                    Text("Average Occupants: \(averageOccupants)")
                }
                
                Spacer()
                
                Button(action: predictPrice) {
                    Text("Predict Price")
                }
                
                Spacer()
                
              .navigationBarTitle("CoreML Integration")
              .alert(isPresented: $showingAlert) {
                  Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
              }
          }
            
        }
        .padding(20)
      }
  }
            
    func predictPrice() {
        let model = calihousing()
        
        do {
            let prediction = try model.prediction(
                HouseAge: Double(houseAge),
                AveRooms: Double(averageRooms),
                AveOccup: Double(averageOccupants)
            )

            alertMessage = "$\(String((prediction.MedHouseVal * 100000)))"
            alertTitle = "The predicted price is:"
        } catch {
            alertTitle = "Error"
            alertMessage = "Please retry."
        }
        
        showingAlert = true
    }
}

struct PredictorView_Previews: PreviewProvider {
    static var previews: some View {
        PredictorView()
    }
}
