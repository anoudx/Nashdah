import SwiftUI

struct onBoarding: View {
    @State private var currentPage = 0
    @AppStorage("isFirstLaunch") private var isFirstLaunch: Bool = true
    @State private var navigateToSignUp = false 

    let pages = [
        (" استكشف أماكن جديدة✨", "نساعدك في العثور على أفضل الوجهات في الرياض!", "mappin.and.ellipse"),
        (" توصيات مخصصة🎯", "نحلل اهتماماتك لنقدم لك أفضل التجارب.", "star.fill"),
        ("ابدأ رحلتك الآن🚀 ", "أنشئ حسابك واستمتع بخدماتنا الفريدة.", "person.fill.checkmark")
    ]

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        VStack {
                            Image(systemName: pages[index].2)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .foregroundColor(Color("C1"))

                            Text(pages[index].0)
                                .font(.title2)
                                .bold()

                            Text(pages[index].1)
                                .font(.body)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding()
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
               
                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .frame(width: 10, height: 10)
                            .foregroundColor(currentPage == index ? Color("C1") : Color.gray.opacity(0.5))
                            .opacity(currentPage == index ? 1 : 0.5)
                    }
                }
                .padding(.bottom, 20)
                
                if currentPage == pages.count - 1 {
                    Button(action: {
                        isFirstLaunch = false
                        navigateToSignUp = true
                    }) {
                        Text("ابدأ الآن")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(width: 200, height: 50)
                            .background(Color("C1"))
                            .cornerRadius(10)
                    }
                    .padding(.bottom, 30)
                }
            }
            .navigationBarBackButtonHidden(true)
            .interactiveDismissDisabled(true)
            .toolbar {
              
                if currentPage < pages.count - 1 {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("تخطي") {
                            isFirstLaunch = false
                            navigateToSignUp = true
                        }
                        .foregroundColor(Color("C1"))
                        .padding(.trailing, 10)
                    }
                }
            }
            .navigationDestination(isPresented: $navigateToSignUp) {
            Login()
            }
        }
    }
}

#Preview {
    NavigationStack {
        onBoarding()
    }
}
