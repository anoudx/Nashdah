import SwiftUI

struct ContentView: View {
    @State private var isFirstLaunch = UserDefaults.standard.bool(forKey: "isFirstLaunch")
    @State private var shouldNavigate = false

    var body: some View {
        NavigationStack {
            if shouldNavigate {
                MainTabView() // ✅ سيتم التنقل إلى `MainTabView` إذا كان `isFirstLaunch = false`
            } else {
                onBoarding()
            }
        }
        .onAppear {
            print("🔄 ContentView ظهر - isFirstLaunch: \(isFirstLaunch)")
            if !isFirstLaunch {
                DispatchQueue.main.async {
                    shouldNavigate = true // ✅ إجبار التنقل إلى `MainTabView`
                }
            }
        }
    }
}
