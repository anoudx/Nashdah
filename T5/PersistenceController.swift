//
//  PersistenceController.swift
//  T5
//
//  Created by Alanoud Alamrani on 04/09/1446 AH.
//

import Foundation
import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "PlacesModel") // ✅ تأكد أن الاسم يطابق `xcdatamodeld`
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("❌ فشل تحميل Core Data: \(error), \(error.userInfo)")
            }
        }
    }
}
