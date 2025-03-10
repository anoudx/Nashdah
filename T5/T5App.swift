////
////  T5App.swift
////  T5
////
////  Created by Alanoud Alamrani on 28/08/1446 AH.
////
//
//import SwiftUI
//
//@main
//struct T5App: App {
//    var body: some Scene {
//        WindowGroup {
//           // homescreenView()
//          //  SplashView()
//            ContentView()
//            //Profile()
//        }
//    }
//}


//
//  T5App.swift
//  T5
//
//  Created by Alanoud Alamrani on 28/08/1446 AH.
//

//import SwiftUI
//
//@main
//struct T5App: App {
//    // ✅ استدعاء تحميل البيانات عند تشغيل التطبيق
//    init() {
//        DataManager.shared.insertPlacesFromJSON()
//    }
//
//    var body: some Scene {
//        WindowGroup {
//           // homescreenView()
//          //  SplashView()
//            ContentView()
//            //Profile()
//        }
//    }
//}


import SwiftUI
import CoreData

@main
struct T5App: App {
    let persistenceController = PersistenceController.shared

    init() {
            DataManager.shared.clearPlacesData() 
           DataManager.shared.insertPlacesFromJSON()
    }

    var body: some Scene {
        WindowGroup {
            SplashView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environment(\.font, Font.custom("SF Arabic", size: 18)) 

        }
    }
}
