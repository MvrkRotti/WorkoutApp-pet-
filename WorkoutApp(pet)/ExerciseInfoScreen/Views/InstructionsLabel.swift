//
//  InstrucnionsLabel.swift
//  WorkoutApp(pet)
//
//  Created by Danil Pestov on 01.03.2024.
//

import UIKit

final class InstructionsLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAppearence()
        
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension InstructionsLabel {
    func setupAppearence() {
        textColor = Resources.CommonColors.white
        textAlignment = .left
        font = Resources.CommonFonts.cellNameLabelFont
        text = "Error"
        contentMode = .scaleAspectFit
        numberOfLines = 0
    }
}