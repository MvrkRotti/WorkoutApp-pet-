//
//  Resources.swift
//  WorkoutApp(pet)
//
//  Created by Danilius on 03.02.2024.
//

import UIKit

enum Resources {
    
    enum TextField {
        enum Colors {
            static let borderColor = UIColor(hexString: "#007FFF")
        }
        
        enum Strings {
            static let firstName = "First Name"
            static let lastName = "Last Name"
            static let email = "Email"
            static let password = "Password"
            static let confirmPassword = "Confirm Password"
        }
        
        enum Images {
            static let userLogo = UIImage(named: "userLogoLogIn")
            static let passLogo = UIImage(named: "passwordSignLogIn")
        }
    }
    
    enum Colors {
        static let customOrange = UIColor(hexString: "#FB7445")
        static let customRed = UIColor(hexString: "#EE373F")
        static let customGrey = UIColor(hexString: "#393939")
        static let customWhite = UIColor(hexString: "#FFFFFF")
    }
    
    enum Fonts {
        static let mainLogoFont = UIFont.boldSystemFont(ofSize: 40)
        static let autLabelFont = UIFont.systemFont(ofSize: 15)
        static let registrationLabelFont = UIFont.systemFont(ofSize: 26, weight: .bold)
    }
    
    enum Images {
        static let mainLogo = UIImage(named: "mainLogoImage")
        static let firstBackgroundImage = UIImage(named: "backGroundImage")
    }
    
    enum autorizedScreen {
        static let signIn = "Sign In"
        static let signUp = "Sign Up"
        static let alreadyHaveAcc = "Already have an account?"
    }
    
    enum RegistrationScreen {
        static let navBarText = "Registration"
        static let registrationLabel = "Create your account"
    }
    
    enum TabBar {
        enum TabBarIcons {
            static let homeIcon = UIImage(named: "homeTabIcon")
            static let progressIcon = UIImage(named: "progressTabIcon")
            static let notesIcon = UIImage(named: "notesTabIcon")
            static let profileIcon = UIImage(named: "porfileTabIcon")
        }
        enum TabBarHeaders {
            static let homeHeader = "Home"
            static let progressHeader = "My Progress"
            static let notesHeader = "My Notes"
            static let profileHeader = "My Profile"
        }
    }
}
