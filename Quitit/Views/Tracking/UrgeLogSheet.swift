//
//  UrgeLogSheet.swift
//  QuitIt
//
//  Created by Upalc on 9/9/25.
//

import SwiftUI

struct UrgeLogSheet: View {
    @ObservedObject var viewModel: DashboardViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var resisted = true
    @State private var intensity: Double = 5
    @State private var selectedTriggers: Set<String> = []
    @State private var selectedLocation = "home"
    @State private var selectedTechnique = "Deep breathing"
    @State private var duration = 5
    @State private var activityBefore = ""
    @State private var notes = ""
    @State private var showingConfetti = false
    
    private let triggers = ["Stress", "Boredom", "Anxiety", "Tired", "Angry", "Sad", "Happy", "Other"]
    private let locations = ["home", "work", "school", "commute", "other"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Resistance Status
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Did you resist the urge?")
                            .font(.headline)
                        
                        HStack(spacing: 16) {
                            ResistanceButton(
                                title: "Yes, I resisted",
                                isSelected: resisted,
                                color: .green,
                                action: { resisted = true }
                            )
                            
                            ResistanceButton(
                                title: "No, I gave in",
                                isSelected: !resisted,
                                color: .red,
                                action: { resisted = false }
                            )
                        }
                    }
                    
                    // Intensity
                    VStack(alignment: .leading, spacing: 12) {
                        Text("How intense was the urge?")
                            .font(.headline)
                        
                        VStack(spacing: 8) {
                            Text("\(Int(intensity))")
                                .font(.system(size: 48, weight: .bold))
                                .foregroundColor(intensityColor)
                            
                            Slider(value: $intensity, in: 1...10, step: 1)
                                .accentColor(intensityColor)
                            
                            HStack {
                                Text("1 - Mild")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text("10 - Overwhelming")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(16)
                        .background(intensityColor.opacity(0.1))
                        .cornerRadius(12)
                    }
                    
                    // Triggers
                    VStack(alignment: .leading, spacing: 12) {
                        Text("What triggered the urge?")
                            .font(.headline)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                            ForEach(triggers, id: \.self) { trigger in
                                TriggerChip(
                                    title: trigger,
                                    isSelected: selectedTriggers.contains(trigger),
                                    action: {
                                        if selectedTriggers.contains(trigger) {
                                            selectedTriggers.remove(trigger)
                                        } else {
                                            selectedTriggers.insert(trigger)
                                        }
                                    }
                                )
                            }
                        }
                    }
                    
                    // Location
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Where were you?")
                            .font(.headline)
                        
                        Picker("Location", selection: $selectedLocation) {
                            ForEach(locations, id: \.self) { location in
                                Text(location.capitalized).tag(location)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    
                    // Activity Before
                    VStack(alignment: .leading, spacing: 12) {
                        Text("What were you doing?")
                            .font(.headline)
                        
                        TextField("e.g., watching TV, working, studying", text: $activityBefore)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    // Notes
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Additional notes (optional)")
                            .font(.headline)
                        
                        TextField("Any other details you'd like to remember", text: $notes, axis: .vertical)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .lineLimit(3...6)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
            }
            .navigationTitle("Log Urge")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveUrgeLog()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
        .overlay {
            if showingConfetti {
                ConfettiView()
                    .allowsHitTesting(false)
            }
        }
    }
    
    private var intensityColor: Color {
        switch Int(intensity) {
        case 1...3:
            return .green
        case 4...6:
            return .orange
        case 7...10:
            return .red
        default:
            return .gray
        }
    }
    
    private func saveUrgeLog() {
        viewModel.logUrge(
            intensity: intensity,
            technique: selectedTechnique,
            duration: duration,
            triggers: Array(selectedTriggers),
            location: selectedLocation,
            notes: notes,
            wasResisted: resisted
        )
        
        if resisted {
            showingConfetti = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                dismiss()
            }
        } else {
            dismiss()
        }
    }
}

struct ResistanceButton: View {
    let title: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(isSelected ? .white : color)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(isSelected ? color : color.opacity(0.2))
                .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct TriggerChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(isSelected ? .white : .blue)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(isSelected ? Color.blue : Color.blue.opacity(0.2))
                .cornerRadius(20)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ConfettiView: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            ForEach(0..<50, id: \.self) { _ in
                Circle()
                    .fill(Color.random)
                    .frame(width: 8, height: 8)
                    .position(
                        x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                        y: animate ? UIScreen.main.bounds.height + 100 : -100
                    )
                    .animation(
                        .easeOut(duration: Double.random(in: 2...4))
                        .delay(Double.random(in: 0...0.5)),
                        value: animate
                    )
            }
        }
        .onAppear {
            animate = true
        }
    }
}

extension Color {
    static var random: Color {
        return Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}

#Preview {
    UrgeLogSheet(viewModel: DashboardViewModel(viewContext: PersistenceController.preview().container.viewContext))
}
