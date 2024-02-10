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
        VStack (alignment: .leading) {
            Text("Stamina Bar Pro\n")
                .bold()
                .font(.title)
            Text("Use the textbox at the bottom to send a question\n\nAsk questions about your health stats or create a training plan.")
            
            ScrollView {
                ForEach(viewModel.messages.filter({$0.role != .system}), id: \.id) { message in
                    messageView(message: message)
                }
            }
            HStack {
                TextField("Enter a message...", text: $viewModel.currentInput)
                    
                Button {
                    viewModel.sendMessage()
                } label: {
                    Text("Send")
                }
                // Disable the button if the text field is empty or contains only spaces
                .disabled(viewModel.currentInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)

            }
        }
        .fullScreenCover(isPresented: $shouldShowOnboarding, content: {
            OnboardingView(shouldShowOnboarding: $shouldShowOnboarding)
        })
        .padding()
    }

    
    func messageView(message: Message) -> some View {
        HStack {
            if message.role == .user { Spacer()}
            Text(message.content)
                .padding()
                .background(message.role == .user ? Color.blue : Color.gray.opacity(0.2))
            if message.role == .assistant { Spacer()}
        }
    }
}

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

