//
//  DetailPage.swift
//  T5
//
//  Created by Noura Alrowais on 03/09/1446 AH.
//
import SwiftUI
import CloudKit
import MapKit

// تعريف هيكل الموقع
struct Location: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}



struct DetailPage: View {
    let location = Location(coordinate: CLLocationCoordinate2D(latitude: 24.7136, longitude: 46.6753)) // الموقع مؤقت
    @State private var rating = 0
    let place: Place2 // المكان المحدد
    
    // تعريف منطقة الخريطة
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 24.7136, longitude: 46.6753),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    
    var body: some View {
        VStack {
            ZStack {
                // هنا استخدم اسم الصورة من `place.image`
                if let imageName = place.imageName, let uiImage = UIImage(named: imageName) {
                    Image(uiImage: uiImage) // هنا نعرض الصورة من `Assets`
                        .resizable()
                        .frame(width: 400.0, height: 374.0)
                        .scaledToFit()
                } else {
                    // في حال لم تكن الصورة موجودة، يمكن عرض صورة افتراضية
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.gray)
                        .frame(width: 400.0, height: 374.0)
                }
                
                VStack {
                    Text(place.name)
                        .font(.system(size: 16))
                        .fontWeight(.bold)
                        .padding(.trailing, 60.0)
                        .padding(.top, 20)
                    
                    HStack {
                        ForEach(1..<6) { index in
                            Image(systemName: index <= rating ? "star.fill" : "star")
                                .foregroundColor(index <= rating ? .yellow : .black)
                                .onTapGesture {
                                    rating = index // تحديث التقييم عند الضغط على النجمة
                                    saveRating()
                                }
                        }
                    }
                    .padding(.top, 5)
                }
                .padding(.top, 250)
                .padding(.trailing, 230.0)
            }
            
            Text("وصف المكان")
                .font(.system(size: 24))
                .padding(.top, 50)
                .padding(.trailing, 240.0)
            
            Text(place.descriptionText)
                .foregroundColor(Color.gray)
            
            Text("الموقع")
                .font(.system(size: 24))
                .padding(.top, 20)
                .padding(.trailing, 300.0)
            
            // استخدام Map مع المعاملات الصحيحة
            Map(coordinateRegion: $region, interactionModes: .all, annotationItems: [location]) { location in
                MapMarker(coordinate: location.coordinate, tint: Color("C1"))
            }
            .frame(height: 162.0)
            
     
        }
        .environment(\.layoutDirection, .rightToLeft)
        .onAppear {
            fetchRating() // استرجاع التقييم عند تحميل الصفحة
        }
    }
    
    private func saveRating() {
        // أولًا: جلب معرف المستخدم الفعلي
        CKContainer.default().fetchUserRecordID { userRecordID, error in
            if let error = error {
                print("❌ خطأ في جلب معرف المستخدم: \(error.localizedDescription)")
                return
            }

            guard let userRecordID = userRecordID else {
                print("❌ لم يتم العثور على معرف المستخدم")
                return
            }
            print("❗️ محاولة استرجاع التقييم باستخدام placeID: \(place.id), userID: \(userRecordID.recordName)")

            // ثانيًا: حفظ التقييم مع معرف المستخدم الفعلي
            let record = CKRecord(recordType: "Rating")
            record["placeID"] = place.id // تأكد من أن place.id ليس nil
            record["rating"] = rating
            record["userID"] = userRecordID.recordName // تأكد من حفظ userID بشكل صحيح

            let database = CKContainer.default().publicCloudDatabase
            database.save(record) { savedRecord, error in
                if let error = error {
                    print("❌ خطأ في حفظ التقييم: \(error.localizedDescription)")
                } else {
                    print("✅ تم حفظ التقييم بنجاح!")
                    print("✅ التقييم المحفوظ: \(rating)")
                }
            }
        }
    }

    private func fetchRating() {
        let database = CKContainer.default().publicCloudDatabase
        
        // تأكد من أن place.id يحتوي على قيمة صالحة
        guard let placeID = place.id else {
            print("❌ place.id هو nil")
            return
        }

        // جلب معرف المستخدم
        CKContainer.default().fetchUserRecordID { userRecordID, error in
            if let error = error {
                print("❌ خطأ في جلب معرف المستخدم: \(error.localizedDescription)")
                return
            }

            guard let userRecordID = userRecordID else {
                print("❌ لم يتم العثور على معرف المستخدم")
                return
            }

            // الاستعلام باستخدام placeID و userID
            let predicate = NSPredicate(format: "placeID == %@ AND userID == %@", placeID, userRecordID.recordName)
            let query = CKQuery(recordType: "Rating", predicate: predicate)

            database.perform(query, inZoneWith: nil) { records, error in
                if let error = error {
                    print("❌ خطأ في استرجاع التقييم: \(error.localizedDescription)")
                    return
                }

                if let record = records?.first, let fetchedRating = record["rating"] as? Int {
                    DispatchQueue.main.async {
                        self.rating = fetchedRating
                        print("✅ تم استرجاع التقييم: \(fetchedRating)")
                    }
                } else {
                    print("❌ لم يتم العثور على التقييم")
                }
            }
        }
    }





    
    
    struct DetailPage_Previews: PreviewProvider {
        static var previews: some View {
            DetailPage(place: Place2(id: "1", key: "11", name: "سليب |slip", descriptionText: "قهوة لذيذة، مكان هادئ☕️", category: "قهوة",imageName: "slip"))
        }
    }
}
