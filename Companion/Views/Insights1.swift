//
//  Insights1.swift
//  Companion
//
//  Created by Shikha Charadva on 11/10/22.
//

import SwiftUI
import Foundation
import UIKit
import HealthKit

struct Insights1: View {

    var body: some View {
      
        NavigationView {
            VStack {
               
                Header1()
                ScrollView(.vertical, showsIndicators: false){
                    
                    Divider()
                    
                    PostHeader1().background(
                     Image("Doctor")
                         .resizable()
                         .aspectRatio( contentMode: .fill)
                         .clipped().opacity(0.075))
                         .edgesIgnoringSafeArea(.all)
                 
                    Spacer()
                    Spacer()
                    Spacer()
                    
                    HStack {
                        Spacer()
                    }
                }
            
                Spacer()
             
            }
        }
    }
}


struct PostHeader1: View {
    
    @EnvironmentObject var store: DataStore
   
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 12) {
                
                Text("Enter your details")
                    .font(.system(size: 20)).fontWeight(.bold).foregroundColor(Color.black).frame(width: 200, height: 60)
                
                Text("AGE")
                    .font(.system(size: 20)).fontWeight(.bold).foregroundColor(Color.black).frame(width: 80, height: 30)
               
                TextField(
                  "Age",
                  text: $store.age
                ).textFieldStyle(.roundedBorder)
                .accessibilityHidden(false)
                .accessibilityLabel(/*@START_MENU_TOKEN@*/"Label"/*@END_MENU_TOKEN@*/)
                .font(.system(size: 25))
                .foregroundColor(.red)
                
                Text("SEX")
                    .font(.system(size: 20)).fontWeight(.bold).foregroundColor(Color.black).frame(width: 80, height: 30)
               
                TextField(
                  "Sex",
                  text: $store.sex
                ).textFieldStyle(.roundedBorder)
                .accessibilityHidden(false)
                .accessibilityLabel(/*@START_MENU_TOKEN@*/"Label"/*@END_MENU_TOKEN@*/)
                .font(.system(size: 25))
                .foregroundColor(.red)
                
                Text("BP")
                    .font(.system(size: 20)).fontWeight(.bold).foregroundColor(Color.black).frame(width: 80, height: 30)
               
                TextField(
                  "Blood Pressure",
                  text: $store.bp
                ).textFieldStyle(.roundedBorder)
                .accessibilityHidden(false)
                .accessibilityLabel(/*@START_MENU_TOKEN@*/"Label"/*@END_MENU_TOKEN@*/)
                .font(.system(size: 25))
                .foregroundColor(.red)
           
                Text("CHOLESTEROL")
                    .font(.system(size: 20)).fontWeight(.bold).foregroundColor(Color.black).frame(width: 170, height: 30)
                
                TextField(
                  "Cholesterol",
                  text: $store.chol
                ).textFieldStyle(.roundedBorder)
                .accessibilityHidden(false)
                .accessibilityLabel(/*@START_MENU_TOKEN@*/"Label"/*@END_MENU_TOKEN@*/)
                .font(.system(size: 25))
                .foregroundColor(.red)
                
                Button(action: store.giveRecommendation, label: {
                    Text("Get Recommendation").font(.system(size: 20)).fontWeight(.bold).foregroundColor(Color.black)
                        .multilineTextAlignment(.center)
                        .padding(0.0)
                        .frame(width: 400, height: 45)
                        .cornerRadius(40)
                        .background(Color.green)
                })
                .alert("Recommendation", isPresented: $store.presentAlert, actions: {
                    
                }, message: {
                    Text("\(store.recommendation)")
                })
              
            }
           
        }
      
    }
}

struct PostContent1: View {
    var image: String = "dog"
    
    var body: some View {
        VStack(spacing: 0.0){
            Image(image)
                .resizable()
              
            HStack{
            
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 9)
        }
    }
}

struct Header1: View {
    @EnvironmentObject var store: DataStore
    
    var body: some View {
        HStack(spacing: -30) {
            VStack(alignment: .leading, spacing: -50){
                Image("logo").resizable().aspectRatio(contentMode: .fit).padding(.vertical).frame(width: 150, height: 120)
                
                Text("Good Day! " + store.name).font(.system(size: 20)).fontWeight(.bold).foregroundColor(Color.gray).frame(width: 150, height: 50)
                
            }
            .padding(.leading)
         
         
           Spacer()
         
        }
    }
}

struct Insights1_Previews: PreviewProvider {
    static var previews: some View {
            Insights1()
     
    }
}

