//
//  myplaces.swift
//  T5
//
//  Created by Abeer & Noura Alrowais on 03/09/1446 AH.

import SwiftUI
import CoreML
import CloudKit
import Foundation

struct foryou: View {
  
    @State private var places: [Place2] = []
    @State private var recommendedCategories: [String] = []
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
                    
                    ForEach(places.filter { recommendedCategories.contains($0.key) }, id: \.id) { place in
                        NavigationLink(destination: DetailPage(place: place)) {
                            ZStack (alignment: .leading){
                                if let imageName = place.imageName,
                                   let uiImage = UIImage(named: imageName) {  // تحميل الصورة من Assets باستخدام اسمها
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 359, height: 109)
                                        .clipShape(RoundedRectangle(cornerRadius: 15))
                                } else {
                                    // في حال لم تكن الصورة موجودة، عرض صورة افتراضية
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color.gray)
                                        .frame(width: 359, height: 109)
                                }
                                
                                HStack {
                                    ZStack(alignment: .leading) {
                                        RoundedRectangle(cornerRadius: 15)
                                            .fill(Color("GrayC"))
                                            .frame(width: 143, height: 90)
                                            .opacity(0.53)
                                            .padding(.trailing, 20)
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(place.name ?? "اسم غير معروف")
                                                .font(.custom("SFPro", size: 16))
                                                .foregroundColor(Color.black)
                                                .frame(maxWidth: .infinity, alignment: .center)
                                            
                                            Text(place.descriptionText ?? "وصف غير متاح")
                                                .font(.custom("SFPro", size: 11))
                                                .foregroundColor(Color.black)
                                                .frame(maxWidth: .infinity, alignment: .center)
                                                .padding(.top, 5)
                                        }
                                        .frame(width: 140, height: 90) // تأكد النص داخل المربع
                                    }
                                    .padding(.leading)
                                    .padding(.trailing, 80)
                                    
                                    Image(systemName: isHeartFilled ? "heart.fill" : "heart")
                                        .padding(.leading, 60)
                                        .padding(.bottom, 55.0)
                                        .foregroundStyle(.white)
                                        .onTapGesture {
                                            isHeartFilled.toggle()
                                        }
                                }
                            }
                        }
                        .padding(.bottom, 9)
                    }


                }
            }
        }
        .environment(\.layoutDirection, .rightToLeft)

        .onAppear {
            Task{
                await loadPlacesAndRecommendations()
            }
        }
    }
    private func loadPlacesAndRecommendations() async {
        places = await loadPlacesFromJSON()
        await loadRecommendations()
    }
    private func loadRecommendations() {
            guard let model = try? MyRecommender4(configuration: MLModelConfiguration()) else {
                print("فشل تحميل النموذج")
                return
            }
            
            // جلب التقييمات من CloudKit
            fetchUserRatings { userRatings in
                // إنشاء مدخلات النموذج باستخدام التقييمات
                let input = MyRecommender4Input(
                    items: userRatings,
                    k: 5 // عدد التوصيات المطلوبة
                )
                
                // توليد التوصيات باستخدام النموذج
                guard let prediction = try? model.prediction(input: input) else {
                    print("فشل في توليد التوصيات")
                    return
                }
                
                // تحويل المفاتيح الموصى بها إلى [String]
                let recommendedKeys = prediction.recommendations.map { String($0) }
                
                // تصفية الأماكن بناءً على المفاتيح الموصى بها
                let recommendedPlaces = places.filter { recommendedKeys.contains($0.key) }
                
                // تحديث التصنيفات الموصى بها
                DispatchQueue.main.async {
                    self.recommendedCategories = recommendedPlaces.map { $0.key }
                }
            }
        }
    private func fetchUserRatings(completion: @escaping ([Int64: Double]) -> Void) {
        // جلب التقييمات من CloudKit (تحتاج لاستبدال userID بمعرف المستخدم الفعلي)
        let predicate = NSPredicate(format: "userID == %@", "user123")
        let query = CKQuery(recordType: "Rating", predicate: predicate)
        
        let database = CKContainer.default().publicCloudDatabase
        database.perform(query, inZoneWith: nil) { results, error in
            if let error = error {
                print("❌ خطأ في جلب التقييمات: \(error.localizedDescription)")
                completion([:])
                return
            }
            
            guard let results = results else {
                completion([:])
                return
            }
            
            var userRatings: [Int64: Double] = [:]  // معجم لتخزين التقييمات
            for record in results {
                if let placeID = record["placeID"] as? String, let rating = record["rating"] as? Int, let placeIDInt64 = Int64(placeID) {
                    userRatings[placeIDInt64] = Double(rating)
                }
            }
            
            // إرسال التقييمات إلى دالة التحميل بعد جمعها
            completion(userRatings)
        }
    }

        }
struct Place2: Identifiable, Codable {
    var id: String? // معرف فريد
    let key: String // المفتاح (يمكن أن يكون String أو Int حسب الحاجة)
    let name: String // اسم المكان
    let descriptionText: String // وصف المكان
    let category: String // التصنيف (مثل "قهوة"، "مطاعم"، إلخ)
    var imageName: String?
  
}
func loadPlacesFromJSON() -> [Place2] {
    guard let url = Bundle.main.url(forResource: "places", withExtension: "json") else {
        print("❌ ملف JSON غير موجود!")
        return []
    }
    
    do {
        let data = try Data(contentsOf: url)
        var places = try JSONDecoder().decode([Place2].self, from: data)
        
        // إضافة معرف فريد إذا لم يكن موجودًا
        for index in places.indices {
            if places[index].id == nil {
                places[index].id = UUID().uuidString
            }
        }
        
        return places
    } catch {
        print("❌ خطأ في قراءة JSON: \(error)")
        return []
    }
}
#Preview {
    foryou()
}

