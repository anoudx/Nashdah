//
//  RegistrationView.swift
//  T5
//
//  Created by Noura Alrowais on 03/09/1446 AH.
//

import SwiftUI
import CloudKit

struct RegistrationView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var fullName = ""
    @State private var errorMessage = ""
    @State private var successMessage = ""
    @State private var isAuthenticated = false // للانتقال إلى الصفحة الرئيسية بعد التسجيل

    var body: some View {
        VStack {
            Image("logo")
                .resizable()
                .frame(width: 182.0, height: 187.0)
                .scaledToFit()
            
            Text("تسجيل جديد")
                .font(.system(size: 21))
                .padding(.trailing, 220)

            TextField("الاسم الكامل", text: $fullName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

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

            if !successMessage.isEmpty {
                Text(successMessage)
                    .foregroundColor(.green)
                    .padding()
            }

            Button(action: {
                registerUser(email: email, fullName: fullName, password: password)
            }) {
                Text("تسجيل")
                    .foregroundColor(.black)
                    .padding()
                    .frame(width: 362.0, height: 42.0)
                    .background(Color("C1"))
                    .cornerRadius(18)
            }
            .padding()
            
            // رابط للانتقال إلى صفحة تسجيل الدخول
            NavigationLink(destination: Login(), isActive: $isAuthenticated) {
                EmptyView()
            }
        }
        .padding()
        .environment(\.layoutDirection, .rightToLeft)
    }

    func registerUser(email: String, fullName: String, password: String) {
        let record = CKRecord(recordType: "User")
        record["email"] = email
        record["fullName"] = fullName
        record["password"] = password

        let database = CKContainer.default().publicCloudDatabase
        database.save(record) { savedRecord, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "حدث خطأ أثناء التسجيل: \(error.localizedDescription)"
                }
                return
            }

            DispatchQueue.main.async {
                self.successMessage = "تم إنشاء الحساب بنجاح!"
                self.isAuthenticated = true // الانتقال إلى الصفحة الرئيسية
            }
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
