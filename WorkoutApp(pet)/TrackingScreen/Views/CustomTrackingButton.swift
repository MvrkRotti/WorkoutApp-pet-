//
//  SideBottomButton.swift
//  WorkoutApp(pet)
//
//  Created by Danil Pestov on 29.09.2024.
//

import UIKit

enum SideButtonType {
    case bike
    case running
    case start
    case pause
    case finish
}

final class CustomTrackingButton: UIButton {
    init(type: SideButtonType) {
        super.init(frame: .zero)
        configureButtonWith(type: type)
        makeAnimate(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height / 2
    }
}

private extension CustomTrackingButton {
    func configureButtonWith(type: SideButtonType) {
        switch type {
        case .bike:
            setImage(UIImage(named: "bikeImage"), for: .normal)
            backgroundColor = ColorResources.white
            layer.borderWidth = 1
            layer.borderColor = ColorResources.customMainBlue.cgColor
            contentHorizontalAlignment = .center
        case .running:
            setImage(UIImage(named: "runningImage"), for: .normal)
            backgroundColor = ColorResources.white
            layer.borderWidth = 1
            layer.borderColor = ColorResources.customMainBlue.cgColor
            contentHorizontalAlignment = .center
        case .start:
            setTitle(Const.startButtonTitle, for: .normal)
            backgroundColor = ColorResources.customMainBlue
        case .pause:
            setTitle(Const.pauseButtonTitle, for: .normal)
            setTitleColor(ColorResources.black, for: .normal)
            backgroundColor = ColorResources.white
            layer.borderWidth = 1
            layer.borderColor = ColorResources.customMainBlue.cgColor
            isHidden = true
        case .finish:
            setTitle(Const.finishButtonTitle, for: .normal)
            backgroundColor = ColorResources.customRed
            setTitleColor(ColorResources.black, for: .normal)
            isHidden = true
        }
        
    }
}
