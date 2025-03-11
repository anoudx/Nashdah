import SwiftUI

struct homescreenView: View {
    @State private var places: [Place2] = [] // ✅ تعريف places كمصفوفة
    @State private var selectedCategory: String = "الكل"
    @State private var likedPlaces: [Place2] = []

    var body: some View {
        NavigationStack {
            VStack() {
                // ✅ رأس الصفحة
                HStack {
                    Text("مرحبًا بك")
                       // .font(.title)
                        .foregroundColor(Color("C1"))
                        .font(.custom("SFPro", size: 23))

                    Spacer()

                    NavigationLink(destination: Likes(likedPlaces: $likedPlaces)) {
                        Image(systemName: "heart.fill")
                         .resizable().scaledToFit().frame(width: 20, height: 20)
                         .padding(.leading,20)
                         .foregroundStyle(Color("C1"))
                    }
                }
                .padding(.horizontal)

                Divider()
                    .frame(height: 1)
                    .background(Color.gray.opacity(0.1))
                   // .padding(.horizontal)
                    .padding(.bottom, 8)

                // ✅ السكشن الأفقي للأماكن المميزة
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        FeatureCard(imageName: "basat", title: "في مجلس بساط دايم تسمع", subtitle: "ترا البساط احمدي")
                        FeatureCard(imageName: "IMG_0632", title: "اللوحة الحُلُم", subtitle: "وثبة الحياة")
                    }
                    .padding(.horizontal, 10)
                    .frame(height: 150)
                }

                // ✅ الفلترة
                HStack(spacing: 24) {
//                    Spacer()
                    ForEach(["الكل", "مطاعم", "قهوة", "منتزهات", "مكتبات"], id: \.self) { category in
                        Text(category)
                            .foregroundColor(selectedCategory == category ? Color("C1") : .gray)
                          
                            
                            .onTapGesture {
                                selectCategory(category)
                            }
                    }
                }
                .padding(.trailing, 30)
                .padding(.top, 25)
                .padding(.bottom, 8)

                // ✅ قائمة الأماكن مع التنقل الصحيح
                VStack {
                    ScrollView(.vertical, showsIndicators: false) {
                        ForEach(places, id: \.id) { place in
                            NavigationLink(destination: DetailPage(place: place)) { // ✅ تمرير place فقط
                                PlaceCardView(place: place)
                            }
                            .buttonStyle(PlainButtonStyle()) // ✅ يمنع تغيير التنسيق عند الضغط
                        }
                    }
                }
                .padding(.horizontal, 10)

                Spacer()
            }
            .environment(\.layoutDirection, .rightToLeft)
            .padding()
            .onAppear {
                loadPlaces()
            }
        }
    }
    
    //  تحميل الأماكن عند بدء التشغيل
    private func loadPlaces() {
        places = loadPlacesFromJSON()
    }

    //  تحديث الأماكن عند اختيار تصنيف
    private func selectCategory(_ category: String) {
        selectedCategory = category
        if category == "الكل" {
            loadPlaces()
        } else {
            places = loadPlacesFromJSON().filter { $0.category == category }
        }
    }
}

struct PlaceCardView: View {
    var place: Place2

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color("C2"))
                .frame(width: 359, height: 109)

            HStack {
               
                VStack(alignment: .trailing, spacing: 4) {
                    Text(place.name ?? "اسم غير معروف")
                        .font(.custom("SFPro", size: 18))
                        .foregroundColor(Color.black)
                        .frame(maxWidth: 180, alignment: .leading)
                    
                    Text(place.descriptionText ?? "وصف غير متاح")
                        .font(.custom("SFPro", size: 14))
                        .foregroundColor(.gray)
                        .frame(maxWidth: 180, alignment: .leading)
                        .lineLimit(2)
                    
                    HStack {
                        Image(systemName: "mappin.and.ellipse")
                            .font(.system(size: 11))
                            .foregroundColor(.black)
                            //.frame(width: 12)
                         
                        
                        Text(place.location ?? "مكان غير متاح")
                            .font(.custom("SFPro", size: 11))
                            .foregroundColor(.black)
                    }
                    .frame(maxWidth: 180, alignment: .leading)
                }
                .padding(.trailing, 10)

                //  الصورة في اليسار
                if let imageName = place.imageName, let uiImage = UIImage(named: imageName) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 90)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .padding(.leading, 10)
                } else {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.gray)
                        .frame(width: 120, height: 90)
                        .padding(.leading, 10)
                }
            }
        }
    
    }
}

// ✅ View فرعي للأماكن المميزة
struct FeatureCard: View {
    var imageName: String
    var title: String
    var subtitle: String

    var body: some View {
        ZStack {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 300, height: 150)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(radius: 5)

            VStack(alignment: .trailing) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                    .shadow(radius: 3)
                    .padding(.top, 50)
                    .padding(.trailing, 50)

                Text(subtitle)
                    .font(.headline)
                    .foregroundColor(.white)
                    .bold()
                    .shadow(radius: 3)
                    .padding(.trailing, 50)
            }
            .padding()
        }
    }
}

#Preview {
    homescreenView()
}
