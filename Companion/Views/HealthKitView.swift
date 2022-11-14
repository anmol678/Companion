//
//  ContentView.swift
//  Companion
//
//  Created by Anmol Jain on 10/7/22.
//

import SwiftUI

struct HealthKitView: View {

    @EnvironmentObject var store: DataStore
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    @State var selectedTag: Int?
    
   

    var body: some View {
        
        NavigationView {
            VStack {
               
                Spacer()
                Header()
                ScrollView(.vertical, showsIndicators: false){
                    // Stories()
                    
                    Divider()
                    
                    Post()
                    
                    //   Post(image: "dog", description: "Almost 2 years old")
                    Spacer()
                    Spacer()
                    Spacer()
                    
                    HStack {     /* Button(action: {
                        store.authorizeHealthKit()
                    }, label: {
                        Text("Authorize Health Data ").bold()
                            .padding()
                            .background(Color.cyan)
                            .foregroundColor(Color.white)
                            .cornerRadius(20)
                    })
                        
                                  */
                        
                        
                        Spacer()
                        
                   /*     Button(action: {
                            store.printStepCount()
                        }, label: {
                            Text("Get Today's Health Data").bold()
                                .padding()
                                .background(Color.cyan)
                                .foregroundColor(Color.white)
                                .cornerRadius(20)
                        })
                        */
                          
                    }
                }
             //   Text("\(store.steps)")
                
              // alertMessage = "\(store.steps)"
                //alertTitle = "The step count is:"
                //showingAlert = true
                Spacer()
              //  TabBar()
               // .navigationBarTitle("HealthKit Integration")
                    
            }
        }
    }
}
struct PostHeader: View {

    @EnvironmentObject var store: DataStore
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0){
                
                Spacer()
                Spacer()
                Spacer()
                
                Text("    1")
                    .font(.system(size: 20)).fontWeight(.bold).foregroundColor(Color.black).frame(width: 40, height: 30)
                Text("  What should we call you?")
                    .font(.system(size: 20)).fontWeight(.bold).foregroundColor(Color.black).frame(width: 270, height: 50)
               
                TextField(
                  "Preferred Name",
                  text: $store.name
                ).textFieldStyle(.roundedBorder)
               // .padding(1.0)
                .accessibilityHidden(false)
                //.frame(width: 200.0, height: 40)
                .accessibilityLabel(/*@START_MENU_TOKEN@*/"Label"/*@END_MENU_TOKEN@*/)
                .accessibilityHint("Enter Your Name")
                .font(.system(size: 25))
                .foregroundColor(.black)
                
                Text("     2")
                    .font(.system(size: 20)).fontWeight(.bold).foregroundColor(Color.black).frame(width: 40, height: 90)
                Text("    Link your health data")
                    .font(.system(size: 20)).fontWeight(.bold).foregroundColor(Color.black).frame(width: 230, height: 20)
              //  Spacer()
               
                //Spacer()
                Text("Your data never leaves your phone").frame(width: 300, height: 30).foregroundColor(Color.gray)
                
                 // Spacer()
                
                
                Button(action: store.authorizeHealthKit, label: {
                    Text("Authorize Health Data ").font(.system(size: 20)).fontWeight(.bold).foregroundColor(Color.black)
                        .multilineTextAlignment(.center)
                        .padding(0.0)
                        .frame(width: 400, height: 45)
                        .cornerRadius(40)
                        .background(Color.green)
                })
           
                
                
                    //.background(.red)
                   // .cornerRadius(10)
            }
            Spacer()
            
           // Image("more")
        }
       // .padding(.vertical, 9)
        // .padding(.horizontal, 12)
    }
}

struct PostContent: View {
    var image: String = "dog"
    
    var body: some View {
        VStack(spacing: 0.0){
            Image(image)
                .resizable()
                //.frame(width: .infinity)
                
            
            HStack{
              /*  HStack(spacing: 10.0) {
                    Image("heart")
                    Image("messenger")
                    Image("search")
                    
                }*/
             //   Spacer()
               // Image("bookmark")
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 9)
        }
    }
}

struct Post: View {
    var image: String = "profile"
    var image1: String = "Doctor"
    var description: String = "1. What should we call you"
    
    var body: some View {
       PostHeader().background(
        Image(image1)
            .resizable()
            .aspectRatio( contentMode: .fill)
            .clipped()
            .opacity(0.075))
            .edgesIgnoringSafeArea(.all)
       /* Text("Learn how your body works and what it needs")
            .font(.title2)
            .padding(.horizontal, 9)
            .padding(.vertical, 5)*/
        
     //   PostContent(image: image)
        
       
        /*Text("Come back later for trends and recommendations").lineLimit(3).padding(/*@START_MENU_TOKEN@*/[.top, .leading, .trailing], 0.0/*@END_MENU_TOKEN@*/).frame(width: 375, height: 50).multilineTextAlignment(.leading)*/
        Text("The application has not yet requested authorization for all of the specified data types")
            .font(.system(size: 20)).fontWeight(.bold).foregroundColor(Color.black).lineLimit(3).padding(/*@START_MENU_TOKEN@*/[.top, .leading, .trailing], 0.0/*@END_MENU_TOKEN@*/).frame(width: 406, height: 110).multilineTextAlignment(.leading)
       
        Image("Phone").resizable()
            .aspectRatio(contentMode: .fill).padding(.vertical)
            .frame(width: 120, height: 120)
      //  PostContent()
        
    }
}
struct Header: View {
    var body: some View {
        HStack(spacing: -30
        ) {
            VStack(alignment: .leading, spacing: -50){Image("logo").resizable().aspectRatio(contentMode: .fit).padding(.vertical).frame(width: 150, height: 120)
                
                Text("Welcome! lets begin your health journey").font(.system(size: 20)).fontWeight(.bold).foregroundColor(Color.gray).frame(width: 250, height: 130)
                
              //  Text("Hello, \(textInput)!")
            }
         
            
           // Text("Companion").font(.subheadline).fontWeight(.heavy).foregroundColor(Color(hue: 1.0, saturation: 0.866, brightness: 0.628)).frame(width: 150, height: 100)
           Spacer()
                .frame(width: 150,height: 70)
            
          /*  HStack(spacing: 20.0) {
                Image("add")
                Image("heart")
                Image("messenger")
            }*/
         
        }    .frame(width: 100,height: 130)
       // .padding(.horizontal, 10)
       // .padding(.vertical, 0)
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
/*struct TabBar: View {
    var body: some View {
        VStack(spacing: 0.0) {
            Divider()
            HStack{
                Image("Home")
               // Spacer()
                Image("Search")
                    //.resizable()
                    /*.frame(width: 0
                           , height: 0)*/
                 //   .cornerRadius(50)
            }
            .padding(.horizontal, 25)
            .padding(.top, 10)
            
            
            
        }
    }
}
*/
