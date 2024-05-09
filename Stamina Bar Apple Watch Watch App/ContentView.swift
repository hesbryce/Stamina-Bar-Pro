//
//  ContentView.swift
//  Stamina Bar Apple Watch Watch App
//
//  Created by Bryce Ellis on 5/8/24.
//

import HealthKit
import SwiftUI

struct ContentView: View {
    @State private var isHealthKitAuthorized = false

    var body: some View {
        VStack {

            // Stamina Bar Placeholder
            RoundedRectangle(cornerRadius: 10)
                .fill(isHealthKitAuthorized ? Color.green : Color.gray)
                .frame(height: 20)
                .padding()

            // Start Button
            Button(action: {
                    requestHealthKitAuthorization()
                
            }) {
                Text(isHealthKitAuthorized ? "Tap here to workout" : "Tap here to start")
                    .foregroundColor(.blue)
                    .padding()
            }
            .background(Color.clear)
            .cornerRadius(10)
            .buttonStyle(PlainButtonStyle())
        }
        
    }

    private func requestHealthKitAuthorization() {
        let healthStore = HKHealthStore()
        let allTypes = Set([HKObjectType.quantityType(forIdentifier: .heartRate)!])

        healthStore.requestAuthorization(toShare: nil, read: allTypes) { (success, error) in
            DispatchQueue.main.async {
                if success {
                    self.isHealthKitAuthorized = true
                } else {
                    // Handle the error or the case where user denies authorization
                }
            }
        }
    }
}



#Preview {
    ContentView()
}
