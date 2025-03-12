//
//  Signin.swift
//  T5
//
//  Created by Noura Alrowais on 03/09/1446 AH.
//

import SwiftUI
import CloudKit
import CryptoKit

struct Login: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @State private var isAuthenticated = false // للانتقال إلى الصفحة الرئيسية بعد تسجيل الدخول
    @State private var navigateToHome = false // ✅ متغير التحكم بالتخطي
   
    @AppStorage("userEmail") private var storedEmail: String = ""  // edit
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false // ✅ تحديد هل المستخدم مسجل أم لا

    var body: some View {
        NavigationView {
            VStack {
                Text("اهلاً فيك في\n نَشدة")
                    .font(.custom("SFPro", size: 60))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding()
                    .padding(.bottom, 100).frame(width:500,height: 280)
                
                TextField("البريد الإلكتروني", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal,20)
                    .padding(.bottom,8)
                SecureField("كلمة المرور", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal,20)
                
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                
                Button(action: {
                    // استخدام Task لاستدعاء الدالة المتزامنة
                    Task {
                        await loginUser(email: email, password: password)
                    }
                }) {
                    Text("الدخول")
                        .foregroundColor(.black)
                        .padding()
                        .frame(width: 326.0, height: 42.0)
                        .background(Color("C1"))
                        .cornerRadius(18)
                }
                .padding()

                // رابط للانتقال إلى صفحة التسجيل
                NavigationLink(destination: RegistrationView()) {
                    Text("ليس لديك حساب؟ إنشاء حساب جديد")
                        .font(.body)
                        .foregroundColor(Color("C1"))
                }
                
                // رابط للانتقال إلى الصفحة الرئيسية بعد تسجيل الدخول
                NavigationLink(destination: ContentView(), isActive: $isAuthenticated) {
                    EmptyView()
                }
            }
            .padding()
            .environment(\.layoutDirection, .rightToLeft)
            .toolbar {
                // ✅ إضافة زر التخطي
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("تخطي") {
                        navigateToHome = true
                    }
                    .foregroundColor(Color("C1"))
                }
            }
            .fullScreenCover(isPresented: $navigateToHome) { // ✅ الانتقال للصفحة الرئيسية عند الضغط
                ContentView()
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    // دالة لاسترجاع المستخدم بناءً على البريد الإلكتروني
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

    // دالة لتسجيل الدخول
    func loginUser(email: String, password: String) async {
        do {
            guard let record = try await fetchUserByEmail(email: email) else {
                throw NSError(domain: "UserNotFound", code: 404, userInfo: nil)
            }
            
            let storedPasswordHash = record["passwordHash"] as? String ?? ""
            let salt = record["salt"] as? String ?? ""
            let enteredPasswordHash = self.hashPassword(password, salt: salt)
            
            if storedPasswordHash == enteredPasswordHash {
                DispatchQueue.main.async {
                    self.isAuthenticated = true // الانتقال إلى الصفحة الرئيسية
                   
                    self.isLoggedIn = true // تحديث حالة تسجيل الدخول
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                  
                    self.storedEmail = email // حفظ البريد الإلكتروني
                    UserDefaults.standard.set(email, forKey: "userEmail")
                    print("📌 الإيميل المخزن في UserDefaults: \(UserDefaults.standard.string(forKey: "userEmail") ?? "غير موجود")")                }
            } else {
                DispatchQueue.main.async {
                    self.errorMessage = "البريد الإلكتروني أو كلمة المرور غير صحيحة."
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "حدث خطأ أثناء تسجيل الدخول: \(error.localizedDescription)"
            }
        }
    }

    // دالة لتشفير كلمة المرور
    func hashPassword(_ password: String, salt: String) -> String {
        let saltedPassword = password + salt
        let inputData = Data(saltedPassword.utf8)
        let hashed = SHA256.hash(data: inputData)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}
