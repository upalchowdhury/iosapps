//
//  HabitType.swift
//  QuitIt
//
//  Created by Upalc on 9/9/25.
//

import Foundation

enum HabitType: String, CaseIterable {
    case nailBiting = "nail_biting"
    case skinPicking = "skin_picking"
    case hairPulling = "hair_pulling"
    case other = "other"
    
    var displayName: String {
        switch self {
        case .nailBiting:
            return "Nail Biting"
        case .skinPicking:
            return "Skin Picking"
        case .hairPulling:
            return "Hair Pulling"
        case .other:
            return "Other"
        }
    }
    
    var description: String {
        switch self {
        case .nailBiting:
            return "Stop biting and picking at nails"
        case .skinPicking:
            return "Stop picking at skin or scabs"
        case .hairPulling:
            return "Stop pulling out hair"
        case .other:
            return "Track any other habit"
        }
    }
    
    var iconName: String {
        switch self {
        case .nailBiting:
            return "hand.raised.fill"
        case .skinPicking:
            return "bandage.fill"
        case .hairPulling:
            return "scissors"
        case .other:
            return "questionmark.circle.fill"
        }
    }
}
