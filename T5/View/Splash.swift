//
//  Splash.swift
//  T5
//
//  Created by Noura Alrowais on 03/09/1446 AH.
//

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
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {                     withAnimation {
                        isActive = true
                    }
                }
            }
            .navigationDestination(isPresented: $isActive) {
                onBoarding()
                    .transition(.opacity)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    SplashView()
}
