//
//  StringResources.swift
//  WorkoutApp(pet)
//
//  Created by Danil Pestov on 11.04.2024.
//

import UIKit

enum StringResources {
    enum CommonStrings {
        static let selectPhoto = "Select\nPhoto"
        static let sets = "Sets"
        static let reps = "Reps"
        static let min = "Min"
        static let save = "SAVE"
        static let cancel = "CANCEL"
        static let resetPassLabelText = "This email address will used for reset your password."
    }
    
    enum NavigationBarHeaders {
        static let exerciseScreen = "Handbook"
        static let notesScreen = "My Notes"
        static let profileScreen = "My Profile"
        static let resetPassword = "Reset Password"
    }
    

    
    enum AutorizedScreenStrings {
        static let signIn = "Sign In"
        static let signUp = "Sign Up"
        static let alreadyHaveAcc = "Already have an account?"
    }
    
    enum RegistrationScreenStrings {
        static let navBarText = "Registration"
        static let registrationLabel = "Create your account"
    }
    
    enum AlertResources {
        static let fillAllFields = "Please, fill in all fields"
        static let emptyField = "Email or password is empty"
        static let incorrectFilling = "Check your email or password"
        static let alertTitle = "Alert"
        static let cancelAction = "Try Again"
        static let enterEmail = "Enter your Email"
        static let resetPassInfo = "Password reset instructions sent to your email."
    }
}