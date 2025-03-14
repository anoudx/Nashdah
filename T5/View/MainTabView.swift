//
//  MainTabView.swift
//  T5
//
//  Created by Alanoud Alamrani on 13/09/1446 AH.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        NavigationStack {
            TabView {
                NavigationStack {
                    homescreenView()
                }
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("الرئيسية")
                }
                
                NavigationStack {
                    foryou()
                }
                .tabItem {
                    Image("Image")
                        .resizable()
                        .frame(width: 22, height: 22)
                    Text("توصيات لك")
                }
                
                NavigationStack {
                    Profile()
                }
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("الحساب")
                }
            }
            .accentColor(Color("C1"))
            .navigationBarBackButtonHidden(true)
        }
    }
}


