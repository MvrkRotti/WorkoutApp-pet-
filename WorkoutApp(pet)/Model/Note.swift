//
//  NoteModel.swift
//  WorkoutApp(pet)
//
//  Created by Danil Pestov on 31.03.2024.
//

import Foundation
import FirebaseFirestoreSwift

struct Note: Identifiable, Codable {
    @DocumentID var id: String?
    var title: String
    var content: String
    var category: NoteCategory
    var userID: String
}

enum NoteCategory: String, Codable, CaseIterable{
    case sport = "Sport"
    case nutrition = "Nutrition"
    case others = "Others"
    
    var localizedName: String {
        switch self {
        case .sport:
            return NSLocalizedString("sport", comment: "")
        case .nutrition:
            return NSLocalizedString("nutrition", comment: "")
        case .others:
            return NSLocalizedString("others", comment: "")
        }
    }
}
