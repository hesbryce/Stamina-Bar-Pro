//
//  ChatView.swift
//  Stamina Bar Pro
//
//  Created by Bryce Ellis on 1/22/24.
//

import SwiftUI

struct ChatView: View {
    @ObservedObject var viewModel: ViewModel
    @AppStorage("shouldShowOnboarding") var shouldShowOnboarding: Bool = true
    @EnvironmentObject var workoutManager: WorkoutManager
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Stamina Bar Pro\n")
                .bold()
                .font(.title)
            Text("Use the textbox at the bottom to ask questions about your health stats or create a training plan.")
            
            ScrollView {
                ForEach(viewModel.messages.filter({$0.role != .system}), id: \.id) { message in
                    messageView(message: message)
                }
            }
            
            // Chat input field and send button
            HStack {
                TextField("⌨️ Enter a message...", text: $viewModel.currentInput)
                    .padding(10) // Padding inside the text field
                    .background(Color.white) // Background color of the text field
                    .cornerRadius(20) // Rounded corner radius
                    .overlay(
                        RoundedRectangle(cornerRadius: 20) // Overlaying a rounded rectangle for the border
                            .stroke(Color.blue, lineWidth: 1) // Border color and width
                    )
                    .padding(.horizontal, 5) // External padding from the text field to other elements
                    .shadow(color: .gray, radius: 1, x: 0, y: 1) // Adding a shadow for depth

                Button(action: viewModel.sendMessage) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(viewModel.currentInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? .gray : .blue) // Change color based on input
                        .background(Circle().fill(Color.white))
                }
                .disabled(viewModel.currentInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) // Disable button based on input

                
            }
        }
        .fullScreenCover(isPresented: $shouldShowOnboarding, content: {
            OnboardingView(shouldShowOnboarding: $shouldShowOnboarding)
        })
        .padding()
    }
    
    
    func messageView(message: Message) -> some View {
        HStack(alignment: .top, spacing: 10) {
            if message.role == .assistant {
                Image("Splash")
                    .resizable() // Allows the image to be resized
                    .scaledToFit() // Keeps the aspect ratio
                    .frame(width: 30, height: 30) // Specify the frame to control the size
                    .padding(5) // Provides visual spacing around the icon
            } else {
                Spacer() // Pushes user messages to the opposite side
            }
            
            Text(message.content)
                .padding()
                .background(message.role == .user ? Color.blue : Color.gray.opacity(0.2))
                .cornerRadius(15)
                .foregroundColor(message.role == .user ? .white : .black)
                .textSelection(.enabled)
            
            if message.role == .user {
                Image(systemName: "person.crop.circle.fill")
                    .resizable() // Makes the system image resizable
                    .scaledToFit() // Keeps the aspect ratio intact
                    .frame(width: 30, height: 30) // Ensures the system image matches the custom image size
                    .foregroundColor(.blue)
                    .padding(5)
            } else {
                Spacer() // Ensures alignment of the assistant's messages
            }
        }
    }


}

// Assume ViewModel and Message definitions are provided


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a dummy or mock WorkoutManager instance for preview purposes
        let mockWorkoutManager = WorkoutManager()
        // Create a ViewModel instance with the mock WorkoutManager
        let viewModel = ChatView.ViewModel(workoutManager: mockWorkoutManager)
        // Pass the ViewModel instance to ChatView
        ChatView(viewModel: viewModel)
    }
}

