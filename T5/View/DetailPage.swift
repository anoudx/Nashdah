import SwiftUI
import CloudKit
import MapKit

struct Location: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

struct DetailPage: View {
  

    let location = Location(coordinate: CLLocationCoordinate2D(latitude: 24.7136, longitude: 46.6753))
    @State private var rating = 0
    let place: Place2
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 24.7136, longitude: 46.6753),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack {
                ZStack(alignment: .bottomTrailing) {
                    if let imageName = place.imageName, let uiImage = UIImage(named: imageName) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: UIScreen.main.bounds.width, height: 300)
                            .clipped()
                    } else {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.gray)
                            .frame(width: UIScreen.main.bounds.width, height: 300)
                    }
                    
                    VStack(alignment: .trailing) {
                        Text(place.name)
                            .font(.system(size: 16))
                        // .bold()
                            .foregroundColor(.white)
                            .padding(.bottom, 5)
                        
                        HStack(spacing: 8) { // ✅ تقليل المسافة بين النجوم لتبدو طبيعية أكثر
                            ForEach(1..<6) { index in
                                Image(systemName: index <= rating ? "star.fill" : "star")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 14, height: 14) // ✅ تكبير النجوم قليلًا لجعلها أكثر بروزًا
                                    .foregroundColor(index <= rating ? .yellow : .gray.opacity(0.5)) // ✅ تحسين وضوح النجوم غير المحددة
                                    .scaleEffect(index == rating ? 1.2 : 1.0) // ✅ تأثير تكبير عند الضغط
                                    .animation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0.2), value: rating)
                                    .onTapGesture {
                                        withAnimation {
                                            rating = index
                                            saveRating()
                                        }
                                        UIImpactFeedbackGenerator(style: .light).impactOccurred() // ✅ Haptic Feedback لإحساس واقعي
                                    }
                                
                                
                                
                            }
                        }
                        .padding(.bottom, 10)
                    }
                    .padding()
                    .background(BlurView())
                    .cornerRadius(12)
                    .padding(16)
                }
                
                VStack(alignment: .trailing, spacing: 15) {
                    
                    
                    
                    Text(place.descriptionText)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.trailing)
                        .padding()
                    
                    Divider()
                        .padding(.horizontal)
                    
                    HStack {
                        Image(systemName: "mappin.and.ellipse")
                            .foregroundColor(Color("C1"))
                        
                        Text("الموقع")
                            .font(.title3)
                        
                    }
                    .padding(.top, 10)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.horizontal)
                    
                
                    
                    // إضافة زر لفتح الموقع في خرائط آبل عند الضغط
                    Button(action: {
                        openInAppleMaps()
                    }) {
                        Map(coordinateRegion: $region, annotationItems: [Location(coordinate: CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude))]) { location in
                            MapPin(coordinate: location.coordinate, tint: Color("C1"))
                        }
                        .frame(height: 180)
                        .cornerRadius(15)
                        .padding(.horizontal)
                    }
                }
            }
        }
        //  .environment(\.layoutDirection, .rightToLeft)
        .onAppear {
            fetchRating()
            region.center = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        }
        
        //حذف back
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            dismiss()
        }) {
            Image(systemName: "chevron.backward") // يظهر السهم فقط
                .foregroundColor(Color("C1"))
        })
        
   
    }
    // دالة لفتح الموقع في خرائط آبل
    func openInAppleMaps() {
        let coordinates = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinates))
        mapItem.name = place.name
        mapItem.openInMaps(launchOptions: [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ])
    }
    


  
    private func saveRating() {
        guard let userEmail = UserDefaults.standard.string(forKey: "userEmail") else {
            print("❌ لم يتم العثور على البريد الإلكتروني للمستخدم")
            return
        }

        let record = CKRecord(recordType: "Rating")
        record["placeID"] = place.id
        record["rating"] = rating
        record["userID"] = userEmail // ربط التقييم بالمستخدم

        let database = CKContainer.default().privateCloudDatabase
        database.save(record) { savedRecord, error in
            if let error = error {
                print("❌ خطأ في حفظ التقييم: \(error.localizedDescription)")
            } else {
                print("✅ تم حفظ التقييم بنجاح!")
            }
        }
    }

    private func fetchRating() {
        let database = CKContainer.default().privateCloudDatabase
        
        guard let placeID = place.id else {
            print("❌ place.id هو nil")
            return
        }

        guard let userEmail = UserDefaults.standard.string(forKey: "userEmail") else {
            print("❌ لم يتم العثور على البريد الإلكتروني للمستخدم")
            return
        }

        let predicate = NSPredicate(format: "placeID == %@ AND userID == %@", placeID, userEmail)
        let query = CKQuery(recordType: "Rating", predicate: predicate)

        database.perform(query, inZoneWith: nil) { records, error in
            if let error = error {
                print("❌ خطأ في استرجاع التقييم: \(error.localizedDescription)")
                return
            }

            if let record = records?.first, let fetchedRating = record["rating"] as? Int {
                DispatchQueue.main.async {
                    self.rating = fetchedRating
                    print("✅ تم استرجاع التقييم: \(fetchedRating)")
                }
            } else {
                print("❌ لم يتم العثور على التقييم")
            }
        }
    }}

// ✅ **تأثير BlurView لتطبيقه على الخلفيات**
struct BlurView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}


    struct DetailPage_Previews: PreviewProvider {
            static var previews: some View {
                let place = Place2(
                    id: "1",
                    key: "11",
                    name: "سليب |slip",
                    descriptionText: "قهوة لذيذة، مكان هادئ☕️",
                    category: "قهوة",
                    imageName: "slip.jpg",
                    location: "السعودية",
                    coordinate: Place2.Coordinate(latitude: 24.7455313, longitude: 46.7530438)
                )
                
                return DetailPage(place: place)
                    .previewLayout(.sizeThatFits)
            }
        }
