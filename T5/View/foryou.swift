//
//  myplaces.swift
//  T5
//
//  Created by Abeer on 03/09/1446 AH.
//
import SwiftUI

struct myplaces: View {
    @State private var likedPlaces: [Int: Bool] = [:]
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 15) {
                        ForEach(0..<4, id: \ .self) { index in 
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
                                    
                                    Image(systemName: likedPlaces[index] == true ? "heart.fill" : "heart")
                                        .padding(.leading, 70.0)
                                        .padding(.bottom, 55.0)
                                        .foregroundStyle(Color("C1"))
                                        .onTapGesture {
                                            likedPlaces[index] = !(likedPlaces[index] ?? false)
                                        }
                                } // end hstack
                            }// end zstack
                        }
                    }
                }
            } // end vstack
            .padding(.top, 20)
            .environment(\.layoutDirection, .rightToLeft)
        }
        .navigationTitle("أماكني")
    }
}

#Preview {
    myplaces()
}
