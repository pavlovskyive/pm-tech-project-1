//
//  RoundedCollectionViewCell.swift
//  Project1
//
//  Created by Vsevolod Pavlovskyi on 15.01.2021.
//

import UIKit

class RoundedCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Variables
    
    var imageName: String = "" {
        didSet {
            // TODO: implement imageView from imageName
        }
    }

    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "sparkles")
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "List"
        label.textColor = UIColor.white
        label.font = .preferredFont(forTextStyle: .headline)
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = false
        label.lineBreakMode = .byTruncatingTail
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var secondaryLabel: UILabel = {
        let label = UILabel()
        label.text = "List"
        label.textColor = UIColor.white
        label.font = .preferredFont(forTextStyle: .footnote)
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = false
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 3
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var editButton: UIButton = {
        let button = UIButton(type: .custom) as UIButton
        button.setBackgroundImage(UIImage(systemName: "ellipsis.circle.fill"), for: .normal)
        button.tintColor = .white
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    // MARK:- Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RoundedCollectionViewCell {
    
    // MARK: Setup Cell
    fileprivate func setupCell() {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        roundCorner()
        gradientBackgroundColor()
        setCellShadow()
        
        self.addSubview(iconImageView)
        self.addSubview(titleLabel)
        self.addSubview(secondaryLabel)
        self.addSubview(editButton)
        
        // TODO: CHANGE LATER
        editButton.isHidden = true
        
        setLayoutConstraints()
    }
    
    func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: 8),
            iconImageView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: 8),
            iconImageView.widthAnchor.constraint(equalToConstant: 28),
            iconImageView.heightAnchor.constraint(equalToConstant: 28),
            
            secondaryLabel.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor, constant: -3),
            secondaryLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: 8),
            secondaryLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor, constant: -8),
            
            titleLabel.bottomAnchor.constraint(equalTo: secondaryLabel.topAnchor, constant: -3),
            titleLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor, constant: -8),
            
            editButton.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: 8),
            editButton.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor, constant: -3),
            editButton.widthAnchor.constraint(equalToConstant: 28),
            editButton.heightAnchor.constraint(equalToConstant: 28)
        ])
    }
    
    func setCellShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 1.0
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 3
        self.clipsToBounds = false
    }
    
    func gradientBackgroundColor() {
        self.contentView.setGradientBackgroundColor(colorOne: .systemPurple, colorTwo: .systemIndigo)
    }
    
    func roundCorner() {
        self.contentView.layer.cornerRadius = 12
        self.contentView.layer.masksToBounds = true
        self.contentView.layer.borderWidth = 1
        self.contentView.layer.borderColor = UIColor.clear.cgColor
    }
}

