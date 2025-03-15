
import SwiftUI

struct UserRecommendations: View {
    @State private var selectedInterests: Set<InterestItem> = []
    @State private var navigateToHome = false
    @AppStorage("isFirstLaunchR") private var isFirstLaunchR: Bool = true
    
    struct InterestItem: Hashable {
        let id = UUID()
        let name: String
    }

    let interests: [[InterestItem]] = [
        [InterestItem(name: "الأكلات الشعبية"), InterestItem(name: "المقاهي و الحلويات"), InterestItem(name: "مواقع تراثية")],
        [InterestItem(name: "كلاسيكيات"), InterestItem(name: "فن"), InterestItem(name: "مغامرة")],
        [InterestItem(name: "طبيعة"), InterestItem(name: "هادئ"), InterestItem(name: "استجمام")],
        [InterestItem(name: "محامص "), InterestItem(name: "اكلات أوروبية"), InterestItem(name: "أكلات آسيويه")]
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 30) {
                    Text("اخبرنا عن اهتماماتك لنقترح لك وجهاتك المثالية !")
                        .multilineTextAlignment(.center)
                        .font(.custom("SFPro", size: 23))
//                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 40)
                        .padding(.top, 20)
                        .padding(.bottom, 20)

                    VStack(spacing: 15) {
                        ForEach(interests, id: \.self) { row in
                            HStack(spacing: 25) {
                                ForEach(row, id: \.self) { interest in
                                    CircleButton(interest: interest, isSelected: selectedInterests.contains(interest)) {
                                        if selectedInterests.contains(interest) {
                                            selectedInterests.remove(interest)
                                        } else {
                                            selectedInterests.insert(interest)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .navigationBarBackButtonHidden(true)
                    .interactiveDismissDisabled(true)
                    .toolbar{
                        // عرض زر التالي إذا تم اختيار 3 اهتمامات
                        if selectedInterests.count == 3 {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button("التالي") {
                                    isFirstLaunchR = false // تحديث الحالة بعد إتمام الاختيارات
                                    navigateToHome = true
                                }
                                .foregroundColor(Color("C1"))
                                .padding(.trailing, 10)
                            }
                        }
                    }
                    .navigationDestination(isPresented: $navigateToHome) {
                        ContentView()
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct CircleButton: View {
    var interest: UserRecommendations.InterestItem
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(interest.name)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(isSelected ? .white : .black)
                .frame(width: 100, height: 100)
                .background(isSelected ? Color("C1") : Color.gray.opacity(0.2))
                .clipShape(Circle())
        }
    }
}

struct UserRecommendations_Previews: PreviewProvider {
    static var previews: some View {
        UserRecommendations()
    }
}
