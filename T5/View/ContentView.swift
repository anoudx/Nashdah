//
//  ContentView.swift
//  T5
//
//  Created by Alanoud Alamrani on 28/08/1446 AH.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            homescreenView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("الرئيسية")
                }
            
            foryou()
                .tabItem {
                    Image("Image")
                     .resizable()
//                        .renderingMode(.template)
                        .frame(width: 22, height: 22)
                    Text("توصيات لك")
                }
            
            Profile()
                .tabItem {
           Image(systemName: "person.fill")
                    Text("الحساب")
                }

        }

        .accentColor(Color("C1")).navigationBarBackButtonHidden(true)
    }
}

#Preview {
   ContentView()
    }
