//
//  HabitSelectionView.swift
//  QuitIt
//
//  Created by Upalc on 9/9/25.
//

import SwiftUI
import CoreData

struct HabitSelectionView: View {
    let onNext: () -> Void
    @State private var selectedHabit: HabitType?
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        VStack(spacing: 30) {
            // Title
            VStack(spacing: 16) {
                Text("What habit would you like to quit?")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("Choose the habit you want to break")
                    .font(.body)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 40)
            
            // Habit Options
            VStack(spacing: 16) {
                ForEach(HabitType.allCases, id: \.self) { habitType in
                    HabitSelectionCard(
                        habitType: habitType,
                        isSelected: selectedHabit == habitType,
                        onTap: {
                            selectedHabit = habitType
                        }
                    )
                }
            }
            .padding(.horizontal, 40)
            
            Spacer()
            
            // Continue Button
            Button(action: {
                if let habit = selectedHabit {
                    createHabit(habit)
                    onNext()
                }
            }) {
                Text("Continue")
                    .font(.headline)
                    .foregroundColor(selectedHabit != nil ? .blue : .gray)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.white)
                    .cornerRadius(12)
                    .opacity(selectedHabit != nil ? 1.0 : 0.6)
            }
            .disabled(selectedHabit == nil)
            .padding(.horizontal, 40)
            .padding(.bottom, 50)
        }
    }
    
    private func createHabit(_ habitType: HabitType) {
        let habitRepo = CoreDataHabitRepository()
        do {
            try habitRepo.createHabit(
                name: habitType.displayName,
                type: habitType.rawValue,
                makeActive: true,
                ctx: viewContext
            )
        } catch {
            print("Failed to create habit: \(error)")
        }
    }
}

struct HabitSelectionCard: View {
    let habitType: HabitType
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                Image(systemName: habitType.iconName)
                    .font(.title2)
                    .foregroundColor(isSelected ? .blue : .white)
                    .frame(width: 30)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(habitType.displayName)
                        .font(.headline)
                        .foregroundColor(isSelected ? .blue : .white)
                    
                    Text(habitType.description)
                        .font(.caption)
                        .foregroundColor(isSelected ? .blue.opacity(0.8) : .white.opacity(0.7))
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.white : Color.white.opacity(0.2))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    HabitSelectionView(onNext: {})
        .background(
            LinearGradient(
                colors: [Color.blue, Color.purple],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
}
