//
//  SplashView.swift
//  TheCatAPISwiftUI
//
//  Created by joan on 7/04/25.

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var scale = AnimationValues.initialScale
    @State private var opacity = AnimationValues.initialOpacity
    
    var body: some View {
        Group {
            if isActive {
                MainTabView()
            } else {
                splashContent
                    .background(Color.beige)
                    .onAppear {
                        startAnimationSequence()
                    }
            }
        }
    }
        
    private var splashContent: some View {
        ZStack {
            Color.beige
            splashImage
            appTitle
        }
    }
    
    private var splashImage: some View {
        Image(splashImageName.splash)
            .font(.system(size: Dimensions.splashIconSize))
            .foregroundColor(.red)
            .scaleEffect(scale)
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeIn(duration: AnimationValues.scaleDuration)) {
                    scale = AnimationValues.targetScale
                    opacity = AnimationValues.targetOpacity
                }
            }
    }
    
    private var appTitle: some View {
        Text(LocalizedStrings.appName)
            .font(.system(
                size: Dimensions.titleSize,
                weight: .bold
            ))
            .foregroundStyle(Color.darkGray)
    }
        
    private func startAnimationSequence() {
        DispatchQueue.main.asyncAfter(
            deadline: .now() + AnimationValues.transitionDelay
        ) {
            withAnimation(.easeInOut) {
                isActive = true
            }
        }
    }
}

// MARK: - Constants

private extension SplashScreenView {
    enum Dimensions {
        static let splashIconSize: CGFloat = 10
        static let titleSize: CGFloat = 60
    }
    
    enum AnimationValues {
        static let initialScale: CGFloat = 0.8
        static let targetScale: CGFloat = 0.9
        static let initialOpacity: Double = 0.5
        static let targetOpacity: Double = 1.0
        static let scaleDuration: Double = 1.2
        static let transitionDelay: Double = 2.0
    }
    
    enum splashImageName {
        static let splash = "Splash"
    }
    
    enum LocalizedStrings {
        static let appName = "The Cat API"
    }
}


#Preview("Splash Screen") {
    SplashScreenView()
}


