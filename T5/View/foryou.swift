//
//  myplaces.swift
//  T5
//
//  Created by Abeer on 03/09/1446 AH.

import SwiftUI

struct foryou: View {
    @StateObject private var viewModel = foryouViewModel()
    
    @State private var isHeartFilled = false

    var body: some View {
        NavigationStack {
            VStack(spacing:12){
                Text("توصيات لك")
                    .font(.system(size: 24))
                
                Divider()
                    .frame(height: 1)
                    .background(Color.gray.opacity(0.1))
                
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(viewModel.places, id: \.self) { place in
                        
                        ZStack (alignment: .leading){
                            if let imageData = place.image, let uiImage = UIImage(data: imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 359, height: 109)
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                            } else {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.gray)
                                    .frame(width: 359, height: 109)
                            }
                            
                            HStack{
                                ZStack(alignment: .leading){
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color("GrayC"))
                                        .frame(width: 143, height: 90)
                                        .opacity(0.53)
                                        .padding(.trailing,20)
                                    
                                    VStack(alignment: .leading, spacing: 4){
                                        Text(place.name ?? "اسم غير معروف")
                                            .font(.custom("SFPro", size: 16))
                                            .frame(maxWidth:.infinity, alignment:.center)
                                                                                
                                        Text(place.descriptionText ?? "وصف غير متاح")
                                            .font(.custom("SFPro", size: 11))
                                            .frame(maxWidth:.infinity, alignment:.center)
                                            .padding(.top,5)
                                    }
                                    .frame(width: 140, height: 90) //تاكد النص داخل المربع
                                    
                                }
                                .padding(.leading)
                                .padding(.trailing, 80)


                                     Image(systemName: isHeartFilled ? "heart.fill" : "heart")
                                        .padding(.leading, 60)
                                        .padding(.bottom, 55.0)
                                        .foregroundStyle(.white)
//                                        .foregroundStyle(Color("C1"))

                                    
                                        .onTapGesture {
                                            isHeartFilled.toggle()
                            }
                                
                            }}
                            .padding(.bottom, 9)

                    }
                }
            }
        }
        .environment(\.layoutDirection, .rightToLeft)

        .onAppear {
            viewModel.fetchPlaces()
        }
    }}


#Preview {
    foryou()
}
