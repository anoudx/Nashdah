//
//  homescreenViewModel.swift
//  T5
//
//  Created by Alanoud Alamrani on 04/09/1446 AH.
//


import Foundation
import CoreData
import SwiftUI

class homescreenViewModel: ObservableObject {
    @Published var selectedCategory: String = "الكل"
    @Published var places: [Place] = []

    init() {
        fetchPlaces()
    }

    func fetchPlaces() {
        if selectedCategory == "الكل" {
            places = DataManager.shared.fetchPlaces()
        } else {
            places = DataManager.shared.fetchPlaces(by: selectedCategory)
        }
    }

    func selectCategory(_ category: String) {
        selectedCategory = category
        fetchPlaces()
    }
}
