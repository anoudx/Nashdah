//
//  BarView.swift
//  T5
//
//  Created by Abeer on 04/09/1446 AH.
//
import SwiftUI

struct BarView: View {
    var body: some View {
        ZStack{
            
            Rectangle()
                .fill(Color.white.opacity(0.9))
                .frame(height: 60)
                .shadow(radius: 5)
                .edgesIgnoringSafeArea(.bottom)
            
            TabView {
                homescreenView()
                    .tabItem {
                        VStack{
                            Image(systemName: "house.fill")
                                .foregroundColor(.gray)
                            
                            
                            Text("الرئيسية")
                                .font(.caption)
                                .fontWeight(.regular)
                                .foregroundColor(.gray)
                        }
                        
                    }
                
                foryou()
                    .tabItem {
                        VStack {
                            Image("Image")
                                .resizable()
                                .renderingMode(.template) // تتلون
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.gray)
                            
                            Text("توصيات لك")
                                .font(.caption)
                                .fontWeight(.regular)
                                .foregroundColor(.gray)
//                            
                            
                        }
                    }
                
                Profile()
                    .tabItem {
                        VStack{
                            Image(systemName: "person.fill")
                                .foregroundColor(.gray)
                            
                            Text("الحساب")
                                .font(.caption)
                                .fontWeight(.regular)
                                .foregroundColor(.gray)
                            
                        }
                    }
            }
            .accentColor(Color("C1"))

        }
    }
}
