//
//  Splash.swift
//  T5
//
//  Created by Noura Alrowais on 03/09/1446 AH.
//

import Foundation
import SwiftUI
struct SplashView: View {
    @State private var isActive = false
    var body: some View {
        NavigationStack{
            ZStack{
                
               
                VStack{
                    Image("logo").resizable().scaledToFit().frame(width: 382, height: 393).padding(.top,304.77).padding(.bottom,457.23).padding(.leading, 162.15).padding(.trailing, 162.15).overlay(
                        Text("مسار").font(.custom("SFPro", size: 30))
                            .foregroundColor(Color("C1"))
                            .padding(.top,250))
                }
                
            }.ignoresSafeArea() .navigationDestination(isPresented: $isActive){
                homescreenView()}  .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5){
                        isActive = true
                    }
                    
                }
            
        }.navigationBarBackButtonHidden(true)
    }
}
#Preview {
    SplashView()
}
