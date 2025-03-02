import SwiftUI

struct homescreenView: View {
    @State private var selectedCategory: String = ""

    var body: some View {
        
        NavigationStack{
            VStack{
                HStack {
                    Image(systemName: "heart.fill")
                        .foregroundColor(Color("C1"))
                        .frame(width: 45.0)
                    
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
                        Image("basat")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 300, height: 150)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .shadow(radius: 5)
                            .overlay(
                                VStack(alignment: .trailing) {
                                    Text("في مجلس بساط دايم تسمع ")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .shadow(radius: 3)
                                        .padding(.top, 60.0)
                                        .padding(.trailing, 75.0)
                                    Text("\"ترا البساط احمدي\"")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .bold()
                                        .shadow(radius: 3)
                                        .padding(.trailing, 100.0)
                                        .bold()
                                        .shadow(radius: 3)
                                }
                                    .padding()
                            )
                        
                        Image("basat")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 300, height: 150)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .shadow(radius: 5)
                            .overlay(
                                VStack(alignment: .trailing) {
                                    Text("في مجلس بساط دايم تسمع ")
                                        .font(.headline)
                                        .fontWeight(.regular)
                                        .foregroundColor(.white)
                                        .shadow(radius: 3)
                                        .padding(.top, 60.0)
                                        .padding(.trailing, 75.0)
                                        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                                    Text("\"ترا البساط احمدي\"")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                       // .padding(.top, 90.0)
                                        .padding(.trailing, 100.0)
                                        .bold()
                                        .shadow(radius: 3)
                                        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                                }
                                    .padding()
                            )
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, 20)
                    .frame(height: 150)
                    
                   // Spacer()
                }.environment(\.layoutDirection, .rightToLeft)
                    .padding()
                
                

                HStack(spacing: 35) {
                    Text("مكتبات")
                        .foregroundColor(selectedCategory == "مكتبات" ? .C_1 : .gray)
                        .font(.body)
                        .onTapGesture { selectedCategory = "مكتبات" }

                    Text("منتزهات")
                        .foregroundColor(selectedCategory == "منتزهات" ? .C_1 : .gray)
                        .font(.body)
                        .onTapGesture { selectedCategory = "منتزهات" }

                    Text("قهوة")
                        .foregroundColor(selectedCategory == "قهوة" ? .C_1 : .gray)
                        .font(.body)
                        .onTapGesture { selectedCategory = "قهوة" }

                    Text("مطاعم")
                        .foregroundColor(selectedCategory == "مطاعم" ? .C_1 : .gray)
                        .font(.body)
                        .onTapGesture { selectedCategory = "مطاعم" }

                    Text("الكل")
                        .foregroundColor(selectedCategory == "الكل" ? .C_1 : .gray)
                        .font(.body)
                        .padding(.trailing, 20)
                        .onTapGesture { selectedCategory = "الكل" }
                }
                
                VStack{
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        ZStack{
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.C_2)
                                .frame(width: 359, height: 109)
                            HStack{
                                
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.gray)
                                    .frame(width: 140, height: 90)
                                
                                VStack{
                                    Text("اسم المكان")
                                        .font(.headline)
                                        .fontWeight(.regular)
                                        .padding(.leading, 40.0)
                                    
                                    Text(" عالمي يقدم قهوة عالية الجودة ومشروبات مميزة ")
                                        .font(.caption)
                                        .fontWeight(.regular)
                                        .foregroundColor(Color.gray)
                                        .padding(.leading, 40.0)
                                        .multilineTextAlignment(.leading) // محاذاه لليسار
                                        .frame(width: 200)
                                }
                                
                                
                            }
                            
                        } //END OF ZSTACK
                        ZStack{
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.C_2)
                                .frame(width: 359, height: 109)
                            HStack{
                                
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.gray)
                                    .frame(width: 140, height: 90)
                                
                                VStack{
                                    Text("اسم المكان")
                                        .font(.headline)
                                        .fontWeight(.regular)
                                        .padding(.leading, 40.0)
                                    
                                    Text(" عالمي يقدم قهوة عالية الجودة ومشروبات مميزة ")
                                        .font(.caption)
                                        .fontWeight(.regular)
                                        .foregroundColor(Color.gray)
                                        .padding(.leading, 40.0)
                                        .multilineTextAlignment(.leading) // محاذاه لليسار
                                        .frame(width: 200)
                                }
                                
                                
                            }
                            
                        } //END OF ZSTACK
                        ZStack{
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.C_2)
                                .frame(width: 359, height: 109)
                            HStack{
                                
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.gray)
                                    .frame(width: 140, height: 90)
                                
                                VStack{
                                    Text("اسم المكان")
                                        .font(.headline)
                                        .fontWeight(.regular)
                                        .padding(.leading, 40.0)
                                    
                                    Text(" عالمي يقدم قهوة عالية الجودة ومشروبات مميزة ")
                                        .font(.caption)
                                        .fontWeight(.regular)
                                        .foregroundColor(Color.gray)
                                        .padding(.leading, 40.0)
                                        .multilineTextAlignment(.leading) // محاذاه لليسار
                                        .frame(width: 200)
                                }
                                
                                
                            }
                            
                        } //END OF ZSTACK
                        ZStack{
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.C_2)
                                .frame(width: 359, height: 109)
                            HStack{
                                
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.gray)
                                    .frame(width: 140, height: 90)
                                
                                VStack{
                                    Text("اسم المكان")
                                        .font(.headline)
                                        .fontWeight(.regular)
                                        .padding(.leading, 40.0)
                                    
                                    Text(" عالمي يقدم قهوة عالية الجودة ومشروبات مميزة ")
                                        .font(.caption)
                                        .fontWeight(.regular)
                                        .foregroundColor(Color.gray)
                                        .padding(.leading, 40.0)
                                        .multilineTextAlignment(.leading) // محاذاه لليسار
                                        .frame(width: 200)
                                }
                                
                                
                            }
                            
                        } //END OF ZSTACK
                    }
                }
            }

        }
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                   
                }) {
                    VStack{
                        Image(systemName: "house.fill")
                            .foregroundColor(.gray)
                           
                        
                        Text("الرئيسية")
                            .font(.caption)
                            .fontWeight(.regular)
                            .foregroundColor(.gray)
                    }
                }
                Spacer()

     
                Button(action: {

                }) {
                    VStack{
                        Image(.image)
                            .resizable()
                            .frame(width: 22, height: 22)
                            .foregroundColor(.gray)
                        
                        Text("توصيات لك")
                            .font(.caption)
                            .fontWeight(.regular)
                            .foregroundColor(.gray)
                    }
                   
                }
                Spacer()


                Button(action: {
             
                }) {
                   VStack{
                       Image(systemName: "person.fill")
                           .foregroundColor(.gray)
                       
                       Text("الحساب")
                           .font(.caption)
                           .fontWeight(.regular)
                           .foregroundColor(.gray)
                       
                    }
                }
                Spacer()
            }
           
        }.frame(height: 30)
    }
}

#Preview {
    homescreenView()
}
