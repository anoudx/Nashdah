//
//  RegistrationView.swift
//  T5
//
//  Created by Noura Alrowais on 03/09/1446 AH.
//

import SwiftUI
import CloudKit
import CryptoKit

class RegistrationViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var fullName = ""
    @Published var errorMessage = ""
    @Published var successMessage = ""
    @Published var isAuthenticated = false

    func registerUser() {
        // تحقق من الحقول الفارغة
        if email.isEmpty || password.isEmpty || fullName.isEmpty {
            self.errorMessage = "يرجى تعبئة جميع الحقول"
            return
        }
        
        let passwordHash = hashPassword(password)

        let record = CKRecord(recordType: "User")
        record["email"] = email
        record["fullName"] = fullName
        record["passwordHash"] = passwordHash

        let database = CKContainer.default().privateCloudDatabase
        database.save(record) { savedRecord, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = "حدث خطأ أثناء التسجيل: \(error.localizedDescription)"
                } else {
                    self.successMessage = "تم إنشاء الحساب بنجاح!"
                    self.isAuthenticated = true
                }
            }
        }
    }

    private func hashPassword(_ password: String) -> String {
        let inputData = Data(password.utf8)
        let hashed = SHA256.hash(data: inputData)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }
}

struct RegistrationView: View {
    @StateObject private var viewModel = RegistrationViewModel()
    
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            Image("logo")
                .resizable()
                .frame(width: 182.0, height: 187.0)
                .scaledToFit()
            
            Text("تسجيل جديد")
                .font(.system(size: 21))
                .padding(.trailing, 220)
                .padding(.bottom,8)
            TextField("الاسم الكامل", text: $viewModel.fullName)
                .padding().frame(width: 326, height: 53).cornerRadius(18)  .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(Color("C2"), lineWidth: 1) // إضافة حد بلون محدد وحجمه
                )
                .padding(.bottom,32)
            TextField("البريد الإلكتروني", text: $viewModel.email)
                .padding().frame(width: 326, height: 53).cornerRadius(18)  .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(Color("C2"), lineWidth: 1) // إضافة حد بلون محدد وحجمه
                )
                .padding(.bottom,32)
            SecureField("كلمة المرور", text: $viewModel.password)
                .padding().frame(width: 326, height: 53).cornerRadius(18)  .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(Color("C2"), lineWidth: 1) // إضافة حد بلون محدد وحجمه
                )
            // عرض رسالة الخطأ إذا كانت الحقول فارغة
            if !viewModel.errorMessage.isEmpty {
                Text(viewModel.errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }

            // عرض رسالة النجاح
            if !viewModel.successMessage.isEmpty {
                Text(viewModel.successMessage)
                    .foregroundColor(.green)
                    .padding()
            }

            Button(action: {
                viewModel.registerUser()
            }) {
                Text("تسجيل")
                    .foregroundColor(.black)
                    .padding()
                    .frame(width: 362.0, height: 42.0)
                    .background(Color("C1"))
                    .cornerRadius(18)
            }
            .padding()
            
            NavigationLink(destination: Login(), isActive: $viewModel.isAuthenticated) {
                EmptyView()
            }
            // حذف back
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action: {
                dismiss()
            }) {
                Image(systemName: "chevron.left") // يظهر السهم فقط
                    .foregroundColor(Color("C1"))
            })
        }
        .padding(.bottom,150)
        .environment(\.layoutDirection, .rightToLeft)
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
