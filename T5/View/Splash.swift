import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    @State private var logoOpacity = 0.0
    @State private var logoScale: CGFloat = 0.8

    var body: some View {
        NavigationStack {
            ZStack {
                Color.white.ignoresSafeArea()
                
                VStack {
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 382, height: 393)
                        .opacity(logoOpacity)
                        .scaleEffect(logoScale)
                        .onAppear {
                            withAnimation(.easeOut(duration: 1.5)) {
                                logoOpacity = 1.0
                                logoScale = 1.0
                            }
                        }
                    
                    Text("نَشدة")
                        .font(.custom("SFPro", size: 30))
                        .foregroundColor(Color("C1"))
                        .opacity(logoOpacity)
                }
            }
            .onAppear {
                // ✅ التأكد من ضبط `isFirstLaunch` فقط إذا لم يكن قد تم ضبطه من قبل
                if UserDefaults.standard.object(forKey: "isFirstLaunch") == nil {
                    UserDefaults.standard.set(true, forKey: "isFirstLaunch")
                    UserDefaults.standard.synchronize()
                    print("🔄 تم ضبط isFirstLaunch لأول مرة: \(UserDefaults.standard.bool(forKey: "isFirstLaunch"))")
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation {
                        isActive = true
                    }
                }
            }
            .navigationDestination(isPresented: $isActive) {
                if UserDefaults.standard.bool(forKey: "isFirstLaunch") {
                    onBoarding()
                } else {
                    MainTabView()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
