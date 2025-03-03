//
//   UserRecord.swift
//  T5
//
//  Created by Noura Alrowais on 03/09/1446 AH.
//

import CloudKit

struct UserRecord {
    let recordID: CKRecord.ID
    let email: String
    let fullName: String
    let password: String
    
    init(record: CKRecord) {
        self.recordID = record.recordID
        self.email = record["email"] as? String ?? ""
        self.fullName = record["fullName"] as? String ?? ""
        self.password = record["password"] as? String ?? ""
    }
    
    // دالة لحفظ مستخدم جديد
    static func saveUser(email: String, fullName: String, password: String, completion: @escaping (CKRecord?, Error?) -> Void) {
        let record = CKRecord(recordType: "User")
        record["email"] = email
        record["fullName"] = fullName
        record["password"] = password
        
        let database = CKContainer.default().publicCloudDatabase
        database.save(record) { savedRecord, error in
            completion(savedRecord, error)
        }
    }
    
    // دالة لاسترجاع المستخدم بناءً على البريد الإلكتروني وكلمة المرور
    static func fetchUserByEmailAndPassword(email: String, password: String, completion: @escaping (UserRecord?, Error?) -> Void) {
        let predicate = NSPredicate(format: "email == %@ AND password == %@", email, password)
        let query = CKQuery(recordType: "User", predicate: predicate)

        let database = CKContainer.default().publicCloudDatabase
        database.perform(query, inZoneWith: nil) { results, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            if let results = results, let record = results.first {
                let user = UserRecord(record: record)
                completion(user, nil)
            } else {
                completion(nil, nil)
            }
        }
    }
}

