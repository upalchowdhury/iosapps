//
//  CheckInSheet.swift
//  QuitIt
//
//  Created by Upalc on 9/9/25.
//

import SwiftUI

struct CheckInSheet: View {
    @ObservedObject var viewModel: DashboardViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var isSuccessful = true
    @State private var moodRating: Int = 3
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false
    @State private var journalEntry = ""
    @State private var challengesNoted = ""
    @State private var tomorrowsGoal = ""
    @State private var gratitudeNote = ""
    @State private var showingCamera = false
    
    private let moodEmojis = ["😢", "😕", "😐", "😊", "😄"]
    private let moodLabels = ["Terrible", "Bad", "Okay", "Good", "Great"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Day Success
                    VStack(alignment: .leading, spacing: 12) {
                        Text("How did today go?")
                            .font(.headline)
                        
                        HStack(spacing: 16) {
                            SuccessButton(
                                title: "I stayed strong today",
                                emoji: "💪",
                                isSelected: isSuccessful,
                                color: .green,
                                action: { isSuccessful = true }
                            )
                            
                            SuccessButton(
                                title: "I had a setback",
                                emoji: "🔄",
                                isSelected: !isSuccessful,
                                color: .orange,
                                action: { isSuccessful = false }
                            )
                        }
                    }
                    
                    // Mood Rating
                    VStack(alignment: .leading, spacing: 12) {
                        Text("How are you feeling?")
                            .font(.headline)
                        
                        VStack(spacing: 16) {
                            Text(moodEmojis[moodRating - 1])
                                .font(.system(size: 60))
                            
                            Text(moodLabels[moodRating - 1])
                                .font(.title2)
                                .fontWeight(.medium)
                            
                            HStack(spacing: 8) {
                                ForEach(1...5, id: \.self) { rating in
                                    Button(action: { moodRating = rating }) {
                                        Circle()
                                            .fill(rating <= moodRating ? Color.blue : Color.gray.opacity(0.3))
                                            .frame(width: 20, height: 20)
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(20)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(16)
                    }
                    
                    // Photo Progress (Premium Feature)
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Progress Photo")
                                .font(.headline)
                            
                            Spacer()
                            
                            Image(systemName: "crown.fill")
                                .foregroundColor(.orange)
                                .font(.caption)
                        }
                        
                        if let selectedImage = selectedImage {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 200)
                                .clipped()
                                .cornerRadius(12)
                                .onTapGesture {
                                    showingImagePicker = true
                                }
                        } else {
                            Button(action: { showingImagePicker = true }) {
                                VStack(spacing: 12) {
                                    Image(systemName: "camera.fill")
                                        .font(.system(size: 30))
                                        .foregroundColor(.gray)
                                    
                                    Text("Take Progress Photo")
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    
                                    Text("Document your journey visually")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 120)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.gray.opacity(0.3), style: StrokeStyle(lineWidth: 2, dash: [5]))
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    
                    // Journal Sections
                    VStack(alignment: .leading, spacing: 20) {
                        JournalSection(
                            title: "What helped you today?",
                            placeholder: "Describe strategies, activities, or thoughts that supported you...",
                            text: $journalEntry
                        )
                        
                        if !isSuccessful {
                            JournalSection(
                                title: "What was challenging?",
                                placeholder: "What made it difficult? What can you learn from this?",
                                text: $challengesNoted
                            )
                        }
                        
                        JournalSection(
                            title: "What will you do differently tomorrow?",
                            placeholder: "Set an intention or goal for tomorrow...",
                            text: $tomorrowsGoal
                        )
                        
                        JournalSection(
                            title: "One thing you're grateful for",
                            placeholder: "What brought you joy or peace today?",
                            text: $gratitudeNote
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
            }
            .navigationTitle("Daily Check-in")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveCheckIn()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(selectedImage: $selectedImage, sourceType: .camera)
        }
    }
    
    private func saveCheckIn() {
        let fullJournalEntry = [
            journalEntry.isEmpty ? nil : "What helped: \(journalEntry)",
            challengesNoted.isEmpty ? nil : "Challenges: \(challengesNoted)",
            tomorrowsGoal.isEmpty ? nil : "Tomorrow's goal: \(tomorrowsGoal)",
            gratitudeNote.isEmpty ? nil : "Grateful for: \(gratitudeNote)"
        ].compactMap { $0 }.joined(separator: "\n\n")
        
        viewModel.saveCheckIn(
            mood: moodRating,
            hasPhoto: selectedImage != nil,
            journalEntry: fullJournalEntry,
            wasSuccessful: isSuccessful,
            photoPath: nil
        )
        dismiss()
    }
}

struct SuccessButton: View {
    let title: String
    let emoji: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(emoji)
                    .font(.system(size: 30))
                
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
            }
            .foregroundColor(isSelected ? .white : color)
            .frame(maxWidth: .infinity)
            .frame(height: 100)
            .background(isSelected ? color : color.opacity(0.2))
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct JournalSection: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
            
            TextField(placeholder, text: $text, axis: .vertical)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .lineLimit(3...6)
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    let sourceType: UIImagePickerController.SourceType
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

#Preview {
    CheckInSheet(viewModel: DashboardViewModel(viewContext: PersistenceController.preview().container.viewContext))
}
