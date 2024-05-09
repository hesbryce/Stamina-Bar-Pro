//
//  OnboardingView.swift
//  Stamina Bar Apple Watch Watch App
//
//  Created by Bryce Ellis on 5/8/24.
//

import Foundation
import SwiftUI
import HealthKit

struct OnboardingView: View {
    @State private var selection = 0
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        TabView(selection: $selection) {
            // First onboarding screen
            VStack {
                Text("Welcome to Stamina Bar")
                    .font(.largeTitle)
                    .padding()

                Text("Swipe right to learn more")
                    .font(.title3)
                    .foregroundColor(.gray)
            }
            .tag(0)

            // Second onboarding screen - HealthKit authorization
            VStack {
                Text("Health Access Required")
                    .font(.largeTitle)
                    .padding()

                Text("We need access to your health data like heart rate to personalize your experience.")
                    .font(.title3)
                    .padding()

                Button("Authorize HealthKit") {
                    requestHealthKitAuthorization()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .tag(1)
        }
        .tabViewStyle(.carousel)
    }
    
    private func requestHealthKitAuthorization() {
        let healthStore = HKHealthStore()
        guard let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate) else {
            return
        }
        let readTypes = Set([heartRateType])

        healthStore.requestAuthorization(toShare: [], read: readTypes) { (success, error) in
            DispatchQueue.main.async {
                if success {
                    self.presentationMode.wrappedValue.dismiss()
                } else {
                    // Handle the error or the case where user denies authorization
                }
            }
        }
    }
}
