//
//  TrainNoteCell.swift
//  WorkoutApp(pet)
//
//  Created by Danil Pestov on 06.03.2024.
//

import UIKit

final class TrainNoteCell: UICollectionViewCell {
    
    //MARK: - Variables
    
    static let identifier = "CustomCollectionViewCell"
    let gradientLayer = CAGradientLayer()
    
    //MARK: - UI Components
    
    private let trainDayLabel: UILabel = {
        let label = UILabel()
        label.textColor = Resources.CommonColors.black
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 17)
        return label
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setGradientBackground()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = contentView.frame
        
    }
    //MARK: - Cell Configure
    
    public func configure(with text: String) {
        self.trainDayLabel.text = text
        self.setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.trainDayLabel.text = nil
    }
}

    //MARK: - UI Setup
private extension TrainNoteCell {
    
    func setupUI() {
        setupView(trainDayLabel)
        
        NSLayoutConstraint.activate([
            trainDayLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            trainDayLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func setGradientBackground() {
        let firstColor = Resources.CommonColors.customCoral.cgColor
        
        let secondColor = Resources.CommonColors.white.withAlphaComponent(0.7).cgColor
        
        gradientLayer.colors = [firstColor, secondColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        self.layer.insertSublayer(gradientLayer, at:0)
    }
}
