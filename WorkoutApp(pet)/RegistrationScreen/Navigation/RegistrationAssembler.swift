//
//  RegistrationAssembler.swift
//  WorkoutApp(pet)
//
//  Created by Danilius on 05.02.2024.
//

import UIKit

struct RegistrationAssembler {
    
    static func buildModule() -> UIViewController {
        
        let viewController = RegistrationViewController()
        let router = RegistrationRouter()
        
        viewController.router = router
        router.registrationViewController = viewController
        
        return viewController
    }
}
