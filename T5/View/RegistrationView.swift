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

    var body: some View {
        VStack {
            Image("logo")
                .resizable()
                .frame(width: 182.0, height: 187.0)
                .scaledToFit()
            
            Text("تسجيل جديد")
                .font(.system(size: 21))
                .padding(.trailing, 220)

            TextField("الاسم الكامل", text: $viewModel.fullName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("البريد الإلكتروني", text: $viewModel.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            SecureField("كلمة المرور", text: $viewModel.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            if !viewModel.errorMessage.isEmpty {
                Text(viewModel.errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }

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
        }
        .padding()
        .environment(\.layoutDirection, .rightToLeft)
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
