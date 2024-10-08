//
//  ProfileScreenViewModel.swift
//  WorkoutApp(pet)
//
//  Created by Danil Pestov on 05.05.2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import UIKit

final class ProfileViewModel {
    
    private let db = Firestore.firestore()
    
    var userID: String? {
        return Auth.auth().currentUser?.uid
    }
    
    private var userProfile: AppUser?
    var didLogout: (() -> Void)?
    
    func fetchUserProfile(completion: @escaping(AppUser?, String?) -> Void) {
        guard let userID = userID else {
            completion(nil, "User not logged in")
            return
        }
        
        let userStorage = db.collection("users").document(userID)
        userStorage.getDocument(source: .default) { document, error in
            if let document = document, document.exists {
                let data = document.data()
                let name = data?["name"] as? String ?? ""
                let age = data?["age"] as? Int ?? 0
                let weight = data?["weight"] as? Double ?? 0.0
                let height = data?["height"] as? Double ?? 0.0
                let gender = data?["gender"] as? String ?? ""
                
                self.userProfile = AppUser(firstName: name, age: age, gender: gender, weight: weight, height: height)
                
                completion(self.userProfile, nil)
            } else {
                completion(nil, "Document does not exist or offline cache unavailable.......")
            }
        }
    }
    
    var name: String? {
        return userProfile?.firstName
    }
    
    var age: Int? {
        return userProfile?.age
    }
    
    var weight: Double? {
        return userProfile?.weight
    }
    
    var height: Double? {
        return userProfile?.height
    }
    
    var gender: String? {
        return userProfile?.gender
    }
    
    var bmi: Double? {
        guard let weight = weight, let height = height else { return 0 }
        let bmiValue = weight / ((height / 100) * (height / 100))
        return bmiValue
    }
    
    private func getBMIDesctription(bmi: Double) -> String {
        let underweightRange = 0.0..<18.5
        let normalRange = 18.5..<24.9
        let overweightRange = 24.9..<29.9
        let veryOverweightRange = 30.0...
        
        if underweightRange.contains(bmi) {
            return Const.BMILowIntex
        } else if normalRange.contains(bmi) {
            return Const.BMINormalIndex
        } else if overweightRange.contains(bmi) {
            return Const.BMIOverweightIndex
        } else if veryOverweightRange.contains(bmi) {
            return Const.BMIVeryOverweightIndex
        } else {
            return Const.nonHeightAndWeight
        }
    }
    
    var bmiDescription: String? {
        guard let bmi = bmi else { return "No data" }
        let bmiDescriprion = getBMIDesctription(bmi: bmi)
        return bmiDescriprion
    }
    
    var textColor: UIColor {
        guard let bmi = bmi else { return .black }
        
        switch bmi {
        case ..<18.5:
            return ColorResources.customMainBlue
        case 18.5..<24.9:
            return ColorResources.customGreen
        case 24.9..<30.0:
            return ColorResources.customOrange
        case 30.0...:
            return ColorResources.customRed
        default:
            return ColorResources.black
        }
    }

    func logout() {
        do {
            try Auth.auth().signOut()
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
            didLogout?()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
}
