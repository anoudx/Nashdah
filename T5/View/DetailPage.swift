//
//  DetailPage.swift
//  T5
//
//  Created by Noura Alrowais on 03/09/1446 AH.
//
import Foundation
import SwiftUI
import MapKit
// الستركت حق اللوكيشن مؤقت الين نضيف المواقع
struct Location: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

struct DetailPage : View {
    let location = Location(coordinate: CLLocationCoordinate2D(latitude: 24.7136, longitude: 46.6753)) //الموقع هذا مؤقت
    @State private var rating = 3
    var body: some View {
        VStack{
            ZStack{
                Image("CoffeeAdress").resizable().frame(width: 400.0, height: 374.0).scaledToFit()
                VStack{
                    Text("اسم المكان").font(.system(size: 16)).fontWeight(.bold).padding(.trailing, 60.0).padding(.top,40)
                    HStack {
                                 ForEach(1..<6) { index in
                                     Image(systemName: index <= rating ? "star.fill" : "star")
                                         .foregroundColor(index <= rating ? .yellow : .gray)
                                         .onTapGesture {
                                             rating = index // تحديث التقييم عند الضغط على النجمة
                                         }
                                 }
                             }
                             .padding(.top, 5)
                }.padding(.top,250).padding(.trailing, 230.0)
            }
            
 
            Text("وصف المكان")
                .font(.system(size: 24)) .padding(.top,50)
                .padding(.trailing, 240.0)
            Text("مقهى عالمي يقدم قهوة عالية الجودة ومشروبات مميزة في أجواء مريحة وعصرية. ☕✨")
                .foregroundColor(Color.gray)
                
            Text("الموقع")
                .font(.system(size: 24)) .padding(.top,20)
                .padding(.trailing, 300.0)
            
            Map(coordinateRegion: .constant(MKCoordinateRegion(
                            center: location.coordinate,
                            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                        )), interactionModes: .all, annotationItems: [location]) { location in
                            MapPin(coordinate: location.coordinate, tint: Color("C1"))
                        }
                        .frame(height: 162.0)
                      
            
        }.environment(\.layoutDirection, .rightToLeft)
    }
}
#Preview {
    DetailPage()
}
