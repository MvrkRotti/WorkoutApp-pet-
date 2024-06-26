//
//  EmailTextField.swift
//  WorkoutApp(pet)
//
//  Created by Danilius on 04.02.2024.
//

import UIKit

final class LogInEmailTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAppearance()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension LogInEmailTextField {
    
    func setupAppearance() {
        layer.cornerRadius = 15
        textContentType = .emailAddress
        placeholder = Const.email
        textColor = ColorResources.white
        autocorrectionType = .no
        backgroundColor = ColorResources.customDarkGrey
        clearButtonMode = .whileEditing
        addSystemIconToLeft(systemName: "person.circle")
    }
}

