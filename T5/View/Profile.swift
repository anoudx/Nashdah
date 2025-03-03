//
//  Profile.swift
//  T5
//
//  Created by Abeer on 03/09/1446 AH.
//


import SwiftUI

struct Profile: View {
    @State private var name = " عبير العلي"
    @State private var isEditing = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 15) {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray)
                
                if isEditing {
                    TextField("أدخل الاسم", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 200)
                } else {
                    Text(name)
                        .font(.custom(".system", size: 22))
                        .fontWeight(.semibold)
                }
                
                Text("mood231@gmail.com")
                    .font(.system(size: 12))
//                    .foregroundColor(.gray)
                
                
                Button(action: {
                    isEditing.toggle()
                }) {
                    Text(isEditing ? "حفظ" : "تعديل الحساب")
                        .font(.custom(".system", size: 13))
                        .foregroundColor(.black)
//                        .padding()
                        .frame(width: 90, height: 32)
                        .background(Color("C1"))
                        .cornerRadius(23)
                }
                
                Spacer()
                .frame(height: 30)
                

                ExpandableSection(title: "من نحن",  content: "نكتب المحتوى هنا")
                ExpandableSection(title: "شاركنا رحلتنا", content: "نكتب المحتوى هنا")
                
                Spacer()
            }
            .padding(.top, 60)
        }
    }
}

struct ExpandableSection: View {
    let title: String
    let  content: String

    @State private var isExpanded = false
    
    var body: some View {
        VStack {
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.gray)

                    Spacer()

                    Text(title)
                        .font(.custom(".system", size: 18))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    
                    
                }

                .padding()
                .frame(width: 322, height:52)
                .overlay(
                    RoundedRectangle(cornerRadius:10)
                        .stroke(Color("C2"), lineWidth: 1.5))
                
            }
            
            if isExpanded {
                Text(content)
                    .font(.custom(".system", size: 16))
                  //  هنا تنسيق المحتوى

            }
            
        }// end vstack
        
    }
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile()
    }
}
