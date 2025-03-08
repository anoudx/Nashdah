//
//  foryouViewModel.swift
//  T5
//
//  Created by Abeer on 07/09/1446 AH.
//
import Foundation
import CoreData
import SwiftUI

class foryouViewModel: ObservableObject {
    @Published var places: [Place] = []

    init() {
        fetchPlaces()
    }

    func fetchPlaces() {
        places = DataManager.shared.fetchPlaces()
        print("done\(places.count) in forview")
    }
}
