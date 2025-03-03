//
//  Likes.swift
//  T5
//
//  Created by Noura Alrowais on 03/09/1446 AH.
//

import Foundation
import SwiftUI
struct Likes : View {
    @State private var isHeartFilled = false
    var body: some View {
        NavigationView{
            VStack  {
                
                ScrollView(.vertical, showsIndicators: false) {
                    ZStack {
                        Image("Finaa")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 359.0, height: 109.0)
                        
                        HStack {
                            ZStack {
                                
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color("GrayC"))
                                    .frame(width: 140, height: 90)
                                    .opacity(0.53)
                                
                                VStack {
                                    Text("الفناء الاول")
                                        .font(.headline)
                                        .fontWeight(.regular)
                                    
                                    Text("عالمي يقدم قهوة عالية الجودة ومشروبات مميزة")
                                        .font(.caption)
                                        .fontWeight(.regular)
                                        .frame(width: 137.0, height: 46.0)
                                }
                            }
                            .padding(.trailing, 100.0)
                            
                            Image(systemName: isHeartFilled ? "heart.fill" : "heart")
                                .padding(.leading, 70.0)
                                .padding(.bottom, 55.0)
                                .foregroundStyle(Color("C1"))
                                .onTapGesture {
                                    isHeartFilled.toggle()
                                }
                        }
                    } //END OF ZSTACK
                    ZStack {
                        Image("Finaa")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 359.0, height: 109.0)
                        
                        HStack {
                            ZStack {
                                
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color("GrayC"))
                                    .frame(width: 140, height: 90)
                                    .opacity(0.53)
                                
                                VStack {
                                    Text("الفناء الاول")
                                        .font(.headline)
                                        .fontWeight(.regular)
                                    
                                    Text("عالمي يقدم قهوة عالية الجودة ومشروبات مميزة")
                                        .font(.caption)
                                        .fontWeight(.regular)
                                        .frame(width: 137.0, height: 46.0)
                                }
                            }
                            .padding(.trailing, 100.0)
                            
                            Image(systemName: isHeartFilled ? "heart.fill" : "heart")
                                .padding(.leading, 70.0)
                                .padding(.bottom, 55.0)
                                .foregroundStyle(Color("C1"))
                                .onTapGesture {
                                    isHeartFilled.toggle()
                                }
                        }
                    }//END OF ZSTACK
                    ZStack {
                        Image("Finaa")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 359.0, height: 109.0)
                        
                        HStack {
                            ZStack {
                                
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color("GrayC"))
                                    .frame(width: 140, height: 90)
                                    .opacity(0.53)
                                
                                VStack {
                                    Text("الفناء الاول")
                                        .font(.headline)
                                        .fontWeight(.regular)
                                    
                                    Text("عالمي يقدم قهوة عالية الجودة ومشروبات مميزة")
                                        .font(.caption)
                                        .fontWeight(.regular)
                                        .frame(width: 137.0, height: 46.0)
                                }
                            }
                            .padding(.trailing, 100.0)
                            
                            Image(systemName: isHeartFilled ? "heart.fill" : "heart")
                                .padding(.leading, 70.0)
                                .padding(.bottom, 55.0)
                                .foregroundStyle(Color("C1"))
                                .onTapGesture {
                                    isHeartFilled.toggle()
                                }
                        }
                    } //END OF ZSTACK
                    ZStack {
                        Image("Finaa")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 359.0, height: 109.0)
                        
                        HStack {
                            ZStack {
                                
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color("GrayC"))
                                    .frame(width: 140, height: 90)
                                    .opacity(0.53)
                                
                                VStack {
                                    Text("الفناء الاول")
                                        .font(.headline)
                                        .fontWeight(.regular)
                                    
                                    Text("عالمي يقدم قهوة عالية الجودة ومشروبات مميزة")
                                        .font(.caption)
                                        .fontWeight(.regular)
                                        .frame(width: 137.0, height: 46.0)
                                }
                            }
                            .padding(.trailing, 100.0)
                            
                            Image(systemName: isHeartFilled ? "heart.fill" : "heart")
                                .padding(.leading, 70.0)
                                .padding(.bottom, 55.0)
                                .foregroundStyle(Color("C1"))
                                .onTapGesture {
                                    isHeartFilled.toggle()
                                }
                        }
                    } //END OF ZSTACK
                }
            }.padding(.top,20).environment(\.layoutDirection, .rightToLeft)
        }.navigationTitle("أماكني")
    }
        
}
#Preview {
    Likes()
}
