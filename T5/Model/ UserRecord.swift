//
//   UserRecord.swift
//  T5
//
//  Created by Noura Alrowais on 03/09/1446 AH.
//

import CloudKit
import CryptoKit

struct UserRecord {
    let recordID: CKRecord.ID
    let email: String
    let fullName: String
    let passwordHash: String
    
    init(record: CKRecord) {
        self.recordID = record.recordID
        self.email = record["email"] as? String ?? ""
        self.fullName = record["fullName"] as? String ?? ""
        self.passwordHash = record["passwordHash"] as? String ?? ""
    }
    
    static func saveUser(email: String, fullName: String, password: String, completion: @escaping (CKRecord?, Error?) -> Void) {
        let salt = UUID().uuidString
        let passwordHash = UserRecord.hashPassword(password, salt: salt)
        let userID = email // استخدام البريد الإلكتروني كمعرف للمستخدم
        
        let record = CKRecord(recordType: "User")
        record["email"] = email
        record["fullName"] = fullName
        record["passwordHash"] = passwordHash
        record["salt"] = salt
        record["userID"] = userID // تخزين معرف المستخدم الفريد
        
        let database = CKContainer.default().privateCloudDatabase
        database.save(record) { savedRecord, error in
            completion(savedRecord, error)
        }
    }
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
    
    static func hashPassword(_ password: String, salt: String) -> String {
        let saltedPassword = password + salt
        let inputData = Data(saltedPassword.utf8)
        let hashed = SHA256.hash(data: inputData)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }
}
