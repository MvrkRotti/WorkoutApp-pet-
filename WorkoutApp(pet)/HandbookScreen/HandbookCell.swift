//
//  ExerciseCell.swift
//  WorkoutApp(pet)
//
//  Created by Danilius on 18.02.2024.
//

import UIKit

final class HandbookCell: UITableViewCell {
    
    //MARK: - Variables
    
    static let identifier = "ExerciseCell"
    private(set) var exercise: HandbookExercise!
    
    //MARK: - UI Components
    
    private let cellView: UIView = {
       let view = UIView()
        view.layer.cornerRadius = 15
        view.backgroundColor = ColorResources.customCoral
        return view
    }()
    private let cellNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = ColorResources.customDarkGrey
        label.textAlignment = .left
        label.font = FontResources.cellNameLabelFont
        label.text = "Error"
        return label
    }()
    
    private let arrowImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = ImageResources.cellArrow
        return iv
    }()
    
    //MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with exercise: HandbookExercise) {
        self.exercise = exercise
        
        self.cellNameLabel.text = exercise.muscle.uppercased().replacingOccurrences(of: "_", with: " ")
    }
    
    //MARK: - PrepareForReuse
    override func prepareForReuse() {
        super.prepareForReuse()
        self.cellNameLabel.text = nil
    }
    
    //MARK: - UI Setup

    private func setupUI() {
        self.setupView(cellView)
        cellView.setupView(cellNameLabel)
        cellView.setupView(arrowImage)
        
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            cellView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.95),
            cellView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1),

            cellNameLabel.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 25),
            cellNameLabel.centerYAnchor.constraint(equalTo: cellView.centerYAnchor),
            
            arrowImage.centerYAnchor.constraint(equalTo: cellView.centerYAnchor),
            arrowImage.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -10)

        ])
    }
}
