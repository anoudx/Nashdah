import CoreData
import UIKit

struct PlaceData: Codable {
    let name: String
    let category: String
    let descriptionText: String
    let imageName: String
    let location: String
}

class DataManager {
    
    static let shared = DataManager()

    let context = PersistenceController.shared.container.viewContext

    func clearPlacesData() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Place.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
            try context.save()
            print("✅ تم حذف جميع الأماكن من Core Data.")
        } catch {
            print("❌ خطأ في حذف الأماكن: \(error)")
        }
    }

    func isDataAlreadyInserted() -> Bool {
        let request: NSFetchRequest<Place> = Place.fetchRequest()
        do {
            return try context.count(for: request) > 0
        } catch {
            return false
        }
    }

    func insertPlacesFromJSON() {
        guard !isDataAlreadyInserted() else { return }

        guard let url = Bundle.main.url(forResource: "places", withExtension: "json") else {
            print("❌ ملف JSON غير موجود!")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let placesArray = try JSONDecoder().decode([PlaceData].self, from: data)

            for place in placesArray {
                let newPlace = Place(context: context)
                newPlace.name = place.name
                newPlace.category = place.category
                newPlace.descriptionText = place.descriptionText
                newPlace.image = loadImage(named: place.imageName)
                newPlace.location = place.location // ✅ تخزين الموقع
                
            }

            try context.save()
            print("✅ تم إدخال الأماكن من JSON بنجاح!")
        } catch {
            print("❌ خطأ في قراءة JSON أو حفظ البيانات: \(error)")
        }
    }

    func loadImage(named imageName: String) -> Data? {
        if let image = UIImage(named: imageName) {
            return image.jpegData(compressionQuality: 0.8)
        }
        return nil
    }

    func fetchPlaces() -> [Place] {
        let request: NSFetchRequest<Place> = Place.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("❌ خطأ في جلب البيانات: \(error)")
            return []
        }
    }

    func fetchPlaces(by category: String) -> [Place] {
        let request: NSFetchRequest<Place> = Place.fetchRequest()
        request.predicate = NSPredicate(format: "category == %@", category)

        do {
            return try context.fetch(request)
        } catch {
            print("❌ خطأ في جلب البيانات: \(error)")
            return []
        }
    
   
    }
}
