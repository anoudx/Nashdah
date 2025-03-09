//
//  Signin.swift
//  T5
//
//  Created by Noura Alrowais on 03/09/1446 AH.
//

import SwiftUI
import CloudKit

struct Login: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @State private var isAuthenticated = false // للانتقال إلى الصفحة الرئيسية بعد تسجيل الدخول

    var body: some View {
        NavigationView {
            VStack {
                Text("اهلاً فيك في\n مسار")
                    .font(.custom("SFPro", size: 60))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding()
                    .padding(.bottom, 100)
                
                TextField("البريد الإلكتروني", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                SecureField("كلمة المرور", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                
                Button(action: {
                    loginUser(email: email, password: password)
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
        }.navigationBarBackButtonHidden(true)
    }
    
    func loginUser(email: String, password: String) {
        let predicate = NSPredicate(format: "email == %@ AND password == %@", email, password)
        let query = CKQuery(recordType: "User", predicate: predicate)
        
        let database = CKContainer.default().publicCloudDatabase
        database.perform(query, inZoneWith: nil) { results, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "حدث خطأ أثناء تسجيل الدخول: \(error.localizedDescription)"
                }
                return
            }
            
            if let results = results, !results.isEmpty {
                DispatchQueue.main.async {
                    self.isAuthenticated = true // الانتقال إلى الصفحة الرئيسية
                }
            } else {
                DispatchQueue.main.async {
                    self.errorMessage = "البريد الإلكتروني أو كلمة المرور غير صحيحة."
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}

