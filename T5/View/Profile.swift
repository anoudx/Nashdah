//
//  Profile.swift
//  T5
//
//  Created by Abeer on 03/09/1446 AH.
//


import SwiftUI
import CloudKit

struct Profile: View {
    @State private var userEmail = ""
    @State private var userName = ""
    @State private var isEditing = false
    @State private var likedPlaces: [Place2] = []
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false // ✅ تحديد هل المستخدم مسجل أم لا
    
    @AppStorage("userEmail") private var storedEmail: String = ""  // edit

        @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            VStack(spacing: 15) {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray)
                
                if isEditing {
                   TextField("أدخل الاسم", text: $userName)
                   .textFieldStyle(RoundedBorderTextFieldStyle())
                   .frame(width: 200)
                   
                       } else {
                           Text(userName)
                         .font(.custom("SFPro", size: 22))
                         .fontWeight(.semibold)
                                              }
                               
                Text(userEmail)
                               .font(.custom("SFPro", size: 12))
                               .foregroundColor(.gray)

                   
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
                
                NavigationLink(destination: Likes(likedPlaces:$likedPlaces)) {
                                    HStack{
                                        Image(systemName: "chevron.left")
                                            .foregroundColor(.gray)
                                            .frame(maxWidth:.infinity, alignment: .leading)
                                        Spacer()
                                        
                                        Text("الأماكن المفضلة")
                                            .font(.custom("SFPro", size: 18))
                                            .foregroundColor(.black)
                                            .frame(maxWidth:.infinity, alignment: .trailing)
                                        
                                        
                                    }
                                    .padding()
                                    
                                    .frame(width: 322, height: 52)
                                    .overlay(
                                        RoundedRectangle(cornerRadius:10)
                                            .stroke(Color("C2"), lineWidth: 1.5))
                                }
                
                ExpandableSection(title: "من نحن", content: "نأخذك في رحلة لاكتشاف أجمل الأماكن السياحية الفريدة وغير المعروفة في السعودية، بعيداً عن الوجهات التقليدية. استعد لتجربة مميزة واستكشاف جديد في كل رحلة لتحقيق مغامرات لا تُنسى!")
                Button(action: {
                                   logout()
                               }) {
                                   Text("تسجيل الخروج")
                                       .font(.custom("SFPro", size: 18))
                                       .foregroundColor(.red)
                                       .frame(width: 300, height:25)
                                       .padding()
                                       .overlay(
                                           RoundedRectangle(cornerRadius: 10)
                                               .stroke(Color.red, lineWidth: 1.5)
                                       )
                               }
                               .padding(.top, 80)
                               
                               Spacer()
                           }
                           .padding(.top, 60)
            
        }
        .onAppear {
       fetchUserData() // تحميل بيانات المستخدم عند الدخول للملف الشخصي

        }
        .fullScreenCover(isPresented: .constant(!isLoggedIn)) { // ✅ إذا لم يكن مسجلًا، انتقل إلى `LoginView`
            Login()
        }
    }
    
    //  دالة لجلب بيانات المستخدم من CloudKit
    func fetchUserByEmail(email: String) async throws -> CKRecord? {
        let predicate = NSPredicate(format: "email == %@", email)
        let query = CKQuery(recordType: "User", predicate: predicate)
        
        let database = CKContainer.default().privateCloudDatabase
        let (matchResults, _) = try await database.records(matching: query)
        
        if let result = matchResults.first?.1 {
            switch result {
            case .success(let record):
                return record
            case .failure(let error):
                throw error
            }
        } else {
            return nil
        }
    }
    func fetchUserData() {
        guard let storedEmail = UserDefaults.standard.string(forKey: "userEmail"), !storedEmail.isEmpty else {
            print("❌ لم يتم العثور على البريد المخزن")
            return
        }

        let predicate = NSPredicate(format: "email == %@", storedEmail)
        let query = CKQuery(recordType: "User", predicate: predicate)
        let database = CKContainer.default().privateCloudDatabase

        database.perform(query, inZoneWith: nil) { results, error in
            if let error = error {
                print("❌ خطأ أثناء جلب البيانات: \(error.localizedDescription)")
                return
            }

            guard let record = results?.first else {
                print("⚠️ لم يتم العثور على بيانات المستخدم")
                return
            }

            DispatchQueue.main.async {
                self.userEmail = record["email"] as? String ?? ""
                self.userName = record["fullName"] as? String ?? "مستخدم مجهول"
                print("✅ تم تحديث البيانات: \(self.userEmail), \(self.userName)")
            }
        }
    }
//    @Environment(\.presentationMode) var presentationMode

       func logout() {
           storedEmail = "" // delete email
           userEmail = ""
           userName = ""
           isLoggedIn = false
           UserDefaults.standard.set(false, forKey: "isAuthenticated")
           
           DispatchQueue.main.async {
               self.presentationMode.wrappedValue.dismiss()
               if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first {
                   window.rootViewController = UIHostingController(rootView: Login())
                   window.makeKeyAndVisible()
               }
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
                                    .font(.custom("SFPro", size: 16))
                                    .multilineTextAlignment(.trailing)
                                    .padding(.horizontal)
                                .padding(.bottom,10)}}
                                .foregroundColor(.gray)

                                    .frame(width:322)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color("C2"), lineWidth: 1.5)
                                    )

                            }
                            
                        }// end vstack
            
    
struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile()
    }
}
