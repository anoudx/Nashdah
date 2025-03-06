import SwiftUI

struct homescreenView: View {
    @StateObject private var viewModel = homescreenViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    NavigationLink(destination: Likes()) {
                        Image(systemName: "heart.fill")
                            .foregroundColor(Color("C1"))
                            .frame(width: 45.0)
                    }
                    Spacer()
                    Text("مرحبًا بك")
                        .font(.title)
                        .foregroundColor(Color("C1"))
                        .padding()
                }
                
                Divider()
                    .frame(height: 1)
                    .background(Color.gray.opacity(0.1))
                
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        // المكان الأول
                        ZStack {
                            Image("basat")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 300, height: 150)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .shadow(radius: 5)
                            
                            VStack(alignment: .trailing) {
                                Text("في مجلس بساط دايم تسمع")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .shadow(radius: 3)
                                    .padding(.top, 50)
                                    .padding(.trailing, 50)
                                
                                Text("\"ترا البساط احمدي\"")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .bold()
                                    .shadow(radius: 3)
                                    .padding(.trailing, 50)
                            }
                            .padding()
                        }
                        
                        // المكان الثاني
                        ZStack {
                            Image("IMG_0632")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 300, height: 150)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .shadow(radius: 5)
                            
                            VStack(alignment: .trailing) {
                                Text("\"اللوحة الحُلُم\"")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .shadow(radius: 3)
                                    .padding(.top, 50)
                                    .padding(.trailing, 20)
                                
                                Text("وثبة الحياة")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .bold()
                                    .shadow(radius: 3)
                                    .padding(.trailing, 30)
                            }
                            .padding()
                }
                
            }
            .padding(.trailing, 20)
            .frame(height: 150)
        }
        .environment(\.layoutDirection, .rightToLeft)
        .padding()
    
                HStack(spacing: 35) {
                    ForEach(["مكتبات", "منتزهات", "قهوة", "مطاعم", "الكل"], id: \.self) { category in
                        Text(category)
                            .foregroundColor(viewModel.selectedCategory == category ? Color("C1") : .gray)
                            .font(.body)
                            .onTapGesture {
                                viewModel.selectCategory(category)
                            }
                    }
                }
                
                VStack {
                    ScrollView(.vertical, showsIndicators: false) {
                        ForEach(viewModel.places, id: \.self) { place in
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color("C2"))
                                    .frame(width: 359, height: 109)
                                
                                HStack {
                                    if let imageData = place.image, let uiImage = UIImage(data: imageData) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 140, height: 90)
                                            .clipShape(RoundedRectangle(cornerRadius: 15))
                                    } else {
                                        RoundedRectangle(cornerRadius: 15)
                                            .fill(Color.gray)
                                            .frame(width: 140, height: 90)
                                    }
                                    
                                    VStack(alignment: .leading) {
                                        Text(place.name ?? "اسم غير معروف")
                                            .font(.headline)
                                            .fontWeight(.regular)
                                          //  .padding(.leading, 50)
                                            .frame(maxWidth: 190, alignment: .trailing)
                                  
                                            
                                        
                                        Text(place.descriptionText ?? "وصف غير متاح")
                                            .font(.caption)
                                            .fontWeight(.regular)
                                            .foregroundColor(Color.gray)
                                            .frame(maxWidth: 180, alignment: .trailing)
                                            .multilineTextAlignment(.trailing)
                                            .lineLimit(nil)
                                        
                                        
                                        HStack{
                                            Text(place.location ?? "مكان غير متاح")
                                                .font(.caption)
                                                .fontWeight(.regular)
                                               
                                            Image(systemName: "mappin.and.ellipse")
                                                .frame(width:12)
                                        } .frame(maxWidth: 190, alignment: .trailing)
                                    }
                                }
                            }
                            .padding(.bottom, 10)
                        }
                    }
                }
            }
        }
    }
}


//        VStack {
//            Spacer()
//            HStack {
//                Spacer()
//                Button(action: {
//                   
//                }) {
//                    VStack{
//                        Image(systemName: "house.fill")
//                            .foregroundColor(.gray)
//                           
//                        
//                        Text("الرئيسية")
//                            .font(.caption)
//                            .fontWeight(.regular)
//                            .foregroundColor(.gray)
//                    }
//                }
//                Spacer()
//
//                NavigationLink(destination: foryou()){
////                Button(action: {
////
////                }) {
//                    VStack{
//                        Image(.image)
//                            .resizable()
//                            .frame(width: 22, height: 22)
//                            .foregroundColor(.gray)
//                        
//                        Text("توصيات لك")
//                            .font(.caption)
//                            .fontWeight(.regular)
//                            .foregroundColor(.gray)
//                    }
//                   
//                }
//                Spacer()
//  
//                NavigationLink(destination: Profile()){
////                Button(action: {
////
////                }) {
//                    VStack{
//                        Image(systemName: "person.fill")
//                            .foregroundColor(.gray)
//                        
//                        Text("الحساب")
//                            .font(.caption)
//                            .fontWeight(.regular)
//                            .foregroundColor(.gray)
//                        
//                    }
//                }
//                Spacer()
//            }
//           
//        }.frame(height: 30)
    
     


#Preview {
    homescreenView()
}
