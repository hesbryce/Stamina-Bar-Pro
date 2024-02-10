//
//  Onboarding.swift
//  Stamina Bar Pro
//
//  Created by Bryce Ellis on 1/4/24.
//

import Foundation
import SwiftUI

struct OnboardingView: View {
    @Binding var shouldShowOnboarding: Bool
    @State private var currentPage = 0
    @EnvironmentObject var workoutManager: WorkoutManager
    
    var body: some View {
        TabView(selection: $currentPage) {
                        
            PageView(pageNumber: 0, title: "Set up Health Access", subTitle: "Stamina Bar Pro uses Apple Health, an offical source for managing health data. When prompted ensure, to Turn On All for reading for health stats.", imageName: "Icon - Apple Health copy", showsDismissButton: false, shouldShowOnboarding: $shouldShowOnboarding)
                        
            let attributedString = try! AttributedString(markdown:
            """
            Stamina Bar Pro cites information trusted resources that will be included at the end of each response. Resources are cited from but not limited to American Heart Association [AHA](https://www.heart.org/en/healthy-living/fitness/fitness-basics/target-heart-rates), [Mayo Clinic](https://www.mayoclinicproceedings.org), and the American College of Sports Medicine [ACSM](https://www.acsm.org)
            """)
            
            PageView(pageNumber: 1, title: "Cited Sources", subTitle: attributedString, imageName: "Splash", showsDismissButton: false, shouldShowOnboarding: $shouldShowOnboarding)
            
            PageView(pageNumber: 2, title: "Set to Go!", subTitle: "You're all set up. Start asking questions to guide your Health+Fitness journey with Stamina Bar Pro", imageName: "check", showsDismissButton: true, shouldShowOnboarding: $shouldShowOnboarding)
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
    }
}

struct PageView: View {
    let pageNumber: Int  // Page number
    let title: String
    let subTitle: AttributedString
    let imageName: String
    let showsDismissButton: Bool
    @Binding var shouldShowOnboarding: Bool
    @EnvironmentObject var workoutManager: WorkoutManager
    
    
    var body: some View {
        VStack (spacing: 20) {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 150, height: 150)
            Text(title)
                .font(.system(size: 24))
            Text(subTitle)
                .font(.system(size: 18))
                .foregroundStyle(Color.secondary)
                .multilineTextAlignment(.center)
            // Law to dissmiss onboarding
            if showsDismissButton {
                
                Button(action: {
                    shouldShowOnboarding.toggle()
                }) {
                    Text("Get Started")
                        .bold()
                        .foregroundColor(.white)
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50) // Apply to Button, not Text
                .background(LinearGradient(gradient: Gradient(colors: [Color.cyan, Color.blue]), startPoint: .leading, endPoint: .trailing)) // Apply to Button
                .cornerRadius(25) // Apply to Button
                //.shadow(color: .gray, radius: 5, x: 0, y: 5) // Apply to Button
            }
        }
        .onAppear {
                workoutManager.requestAuthorization { authorized, error in }
        }
    }
}
