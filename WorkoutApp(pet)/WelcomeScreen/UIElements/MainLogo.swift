//
//  logo.swift
//  WorkoutApp(pet)
//
//  Created by Danilius on 03.02.2024.
//

import UIKit

final class MainLogo: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAppearence()
        
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension MainLogo {
    func setupAppearence() {
        contentMode = .scaleAspectFit
        image = Resources.Images.mainLogo
    }
}
