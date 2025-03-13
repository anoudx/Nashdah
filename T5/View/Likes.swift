//
//  Likes.swift
//  T5
//
//  Created by Noura Alrowais on 03/09/1446 AH.
//
import SwiftUI
import CloudKit


//add comment
struct Likes: View {
    @Binding var likedPlaces: [Place2] // Binding لقائمة الأماكن المفضلة
    @State private var heartStates: [String: Bool] = [:] // حالة الإعجاب لكل مكان
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
//                Text("الأماكن المفضلة")
//                    .font(.system(size: 24))
//                    .padding(.top, 16)
                
                Divider()
                    .frame(height: 1)
                    .background(Color.gray.opacity(0.1))
                
                if isLoggedIn && !likedPlaces.isEmpty {
                    ScrollView(.vertical, showsIndicators: false) {
                        ForEach(likedPlaces, id: \.id) { place in
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
                                        
                                        // زر القلب لإزالة الإعجاب
                                        Image(systemName: "heart.fill").resizable().scaledToFit().frame(width: 25, height: 25)
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
                            }
                            .padding(.bottom, 9)
                        }}
                    
                }
                else {
                    // ✅ المستخدم غير مسجل، عرض اللوجو مع دعوة للتسجيل
                    VStack() {
                        Image("logo") // تأكدي من وجود صورة اللوجو في الـ Assets
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .padding(.top, 150)
                        
                  
                        
                        Text( "ما عندك أماكن مفضلة للحين")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30)
                        
                            .padding(.bottom, 300)
                        
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
        //
        //        .navigationBarItems(leading: Button(action: {
        //                dismiss()
        //        }) {
        //            Image(systemName: "chevron.backward") // يظهر السهم فقط
        //                .foregroundColor(Color("C1"))
        //        })
        //
        .navigationBarTitleDisplayMode(.inline) // لجعل العنوان بمحاذاة السهم
        .toolbar {
            ToolbarItem(placement: .principal) {
                
                Text("الأماكن المفضلة") // استبدل النص بعنوان الصفحة
                    .font(.custom("SFPro", size: 23))
            }
            ToolbarItem(placement: .navigationBarLeading) {

                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color("C1"))
                
                    
                }

            }
        }
    }// end body

    
    
    
    // دالة لتحميل الأماكن المفضلة (التي تم إعجابها) من CloudKit
    private func loadLikedPlaces() async {
        do {
            // جلب placeID للأماكن المفضلة
            let likedPlaceIDs = await fetchLikedPlaceIDs()
            print("✅ الأماكن المفضلة (placeID): \(likedPlaceIDs)")
            
            // تحميل الأماكن المفضلة (Place2) بناءً على placeID
            var places: [Place2] = []
            for placeID in likedPlaceIDs {
                if let place = fetchPlace(by: placeID) {
                    places.append(place)
                    print("✅ تم تحميل المكان المفضل: \(place.name ?? "اسم غير معروف")")
                }
            }
            
            // تحديث likedPlaces
            DispatchQueue.main.async {
                self.likedPlaces = places
                print("✅ الأماكن المفضلة بعد التحميل: \(self.likedPlaces)")
            }
        } catch {
            print("❌ خطأ في جلب الإعجابات: \(error.localizedDescription)")
        }
    }
    private func fetchPlace(by placeID: String) -> Place2? {
        let places = loadPlacesFromJSON()
        let place = places.first { $0.id == placeID }
        print("✅ Fetched Place: \(place?.name ?? "No Place Found")")
        return place
    }
    private func fetchLikedPlaceIDs() async -> [String] {
        var likedPlaceIDs: [String] = []
        do {
            guard let userEmail = UserDefaults.standard.string(forKey: "userEmail") else {
                print("❌ لم يتم العثور على البريد الإلكتروني للمستخدم")
                return []
                
            }
            print("✅ البريد الإلكتروني للمستخدم: \(userEmail)")
            let predicate = NSPredicate(format: "userID == %@", userEmail)
            let query = CKQuery(recordType: "Likes", predicate: predicate)
            
            let database = CKContainer.default().privateCloudDatabase
            let records = try await database.records(matching: query)
            
            for result in records.matchResults {
                if let record = try? result.1.get(),
                   let placeID = record["placeID"] as? String {
                    
                    likedPlaceIDs.append(placeID)
                    
                    
                }
            }
        } catch {
            print("❌ خطأ في جلب الإعجابات: \(error.localizedDescription)")
        }
        
        return likedPlaceIDs
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
  

    // دالة لإزالة الإعجاب
    private func removeLike(_ place: Place2) async {
        do {
            guard let userEmail = UserDefaults.standard.string(forKey: "userEmail") else {
                print("❌ لم يتم العثور على البريد الإلكتروني للمستخدم")
                return
            }
            
            let predicate = NSPredicate(format: "placeID == %@ AND userID == %@", place.id ?? "", userEmail)
            let query = CKQuery(recordType: "Likes", predicate: predicate)
            
            let database = CKContainer.default().privateCloudDatabase
            let records = try await database.records(matching: query)
            
            for result in records.matchResults {
                if let record = try? result.1.get() {
                    try await database.deleteRecord(withID: record.recordID)
                    print("✅ تم حذف الإعجاب بنجاح!")
                    
                    // تحديث likedPlaces بعد الحذف
                    DispatchQueue.main.async {
                        self.likedPlaces.removeAll { $0.id == place.id }
                        print("✅ تم تحديث الأماكن المفضلة بعد الحذف: \(self.likedPlaces)")
                    }
                }
            }
        } catch {
            print("❌ خطأ في حذف الإعجاب: \(error.localizedDescription)")
        }
    }
}
