//
//  Likes.swift
//  T5
//
//  Created by Noura Alrowais on 03/09/1446 AH.
//
import SwiftUI
import CloudKit



struct Likes: View {
    @Binding var likedPlaces: [Place2] // Binding لقائمة الأماكن المفضلة
    @State private var heartStates: [String: Bool] = [:] // حالة الإعجاب لكل مكان

    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                Text("الأماكن المفضلة")
                    .font(.system(size: 24))
                    .padding(.top, 16)
                
                Divider()
                    .frame(height: 1)
                    .background(Color.gray.opacity(0.1))
                
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(likedPlaces, id: \.id) { place in
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
                                
                                // زر القلب لإزالة الإعجاب
                                Image(systemName: "heart.fill").resizable().scaledToFit().frame(width: 30, height: 30)
                                    .padding(.leading, 50)
                                    .padding(.bottom, 55.0)
                                    .foregroundStyle(Color("C1"))
                                    .onTapGesture {
                                        Task {
                                            await removeLike(place)
                                        }
                                    }
                            }
                        }
                        .padding(.bottom, 9)
                    }
                }
            }
            .onAppear {
                Task {
                    await loadLikedPlaces() // تحميل الأماكن المفضلة عند ظهور الصفحة
                }
            }
        }
        .environment(\.layoutDirection, .rightToLeft)
        
        //حذف back
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
                dismiss()
        }) {
            Image(systemName: "chevron.backward") // يظهر السهم فقط
                .foregroundColor(Color("C1"))
        })
        
        
    }// end body

    
    
    
    // دالة لتحميل الأماكن المفضلة (التي تم إعجابها) من CloudKit
    private func loadLikedPlaces() async {
        let database = CKContainer.default().publicCloudDatabase
        
        // استرجاع معرف المستخدم
        CKContainer.default().fetchUserRecordID { userRecordID, error in
            if let error = error {
                print("❌ خطأ في جلب معرف المستخدم: \(error.localizedDescription)")
                return
            }
            
            guard let userRecordID = userRecordID else {
                print("❌ لم يتم العثور على معرف المستخدم")
                return
            }
            
            let predicate = NSPredicate(format: "userID == %@", userRecordID.recordName)
            let query = CKQuery(recordType: "Likes", predicate: predicate) // استخدام "Likes" كـ recordType
            
            database.perform(query, inZoneWith: nil) { results, error in
                if let error = error {
                    print("❌ خطأ في جلب سجلات الإعجاب: \(error.localizedDescription)")
                    return
                }
                
                var places: [Place2] = []
                for record in results ?? [] {
                    if let placeID = record["placeID"] as? String, let liked = record["liked"] as? Bool, liked {
                        // إذا كان قد تم الإعجاب بهذا المكان، نقوم بإضافته
                        if let place = fetchPlace(by: placeID) {
                            places.append(place)
                        }
                    }
                }

                DispatchQueue.main.async {
                    self.likedPlaces = places
                }
            }
        }
    }
    private func fetchUserRecordID() async throws -> CKRecord.ID {
        return try await withCheckedThrowingContinuation { continuation in
            CKContainer.default().fetchUserRecordID { recordID, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let recordID = recordID {
                    continuation.resume(returning: recordID)
                } else {
                    continuation.resume(throwing: NSError(domain: "UnknownError", code: -1, userInfo: nil))
                }
            }
        }
    }
    // دالة جلب مكان باستخدام placeID (يمكنك تعديل هذه الدالة حسب طريقة تخزين الأماكن لديك)
    private func fetchPlace(by placeID: String) -> Place2? {
        // جلب الأماكن من ملف JSON (إذا لم تكن قد قمت بتحميلها مسبقًا، يمكنك استدعاء دالة loadPlacesFromJSON هنا)
        let places = loadPlacesFromJSON() // التأكد من أن الأماكن محملة من JSON
      

        // الآن نبحث عن المكان باستخدام placeID
        return places.first { $0.id == placeID }
    }

    // دالة لإزالة الإعجاب
    private func removeLike(_ place: Place2) async {
        do {
            let userRecordID = try await fetchUserRecordID()
            let predicate = NSPredicate(format: "placeID == %@ AND userID == %@", place.id ?? "", userRecordID.recordName)
            let query = CKQuery(recordType: "Likes", predicate: predicate)
            
            let database = CKContainer.default().publicCloudDatabase
            let records = try await database.records(matching: query)
            
            for result in records.matchResults {
                if let record = try? result.1.get() {
                    try await database.deleteRecord(withID: record.recordID)
                    print("✅ تم حذف الإعجاب بنجاح!")
                }
            }
            
            // تحديث القائمة بعد الحذف
            DispatchQueue.main.async {
                self.likedPlaces.removeAll { $0.id == place.id }
            }
        } catch {
            print("❌ خطأ في حذف الإعجاب: \(error.localizedDescription)")
        }
    }
}
