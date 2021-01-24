//
//  RoundedCollectionViewCell.swift
//  Project1
//
//  Created by Vsevolod Pavlovskyi on 15.01.2021.
//

import UIKit

final class RoundedCollectionViewCell: UICollectionViewCell {

    // MARK: - Variables

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
        label.numberOfLines = 4

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

    private let gradientLayer = CAGradientLayer()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = bounds
        gradientLayer.frame = bounds
    }
}

extension RoundedCollectionViewCell {

    // MARK: - Setup

    private func setupCell() {

        translatesAutoresizingMaskIntoConstraints = false

        setBlurBackground()
        roundCorner()

        self.addSubview(iconImageView)
        self.addSubview(titleLabel)
        self.addSubview(secondaryLabel)
        self.addSubview(editButton)

        editButton.isHidden = true

        setLayoutConstraints()
    }

    private func setLayoutConstraints() {
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

    private func setCellShadow() {
        layer.needsDisplayOnBoundsChange = true
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 1.0
        layer.masksToBounds = false
        layer.cornerRadius = 3
        clipsToBounds = false
    }

    private func setBlurBackground() {
        if !UIAccessibility.isReduceTransparencyEnabled {
            backgroundColor = .clear

            let blurEffect = UIBlurEffect(style: .systemThinMaterialDark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)

            contentView.addSubview(blurEffectView)

            blurEffectView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                blurEffectView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                blurEffectView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                blurEffectView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 10),
                blurEffectView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 10)
            ])

            blurEffectView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)

        } else {
            setGradientBackgroundColor(colorOne: .systemPurple, colorTwo: .systemIndigo)
            setCellShadow()
        }
    }

    private func setGradientBackgroundColor(colorOne: UIColor, colorTwo: UIColor) {
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.0, 1.1]
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.cornerRadius = 3

        contentView.layer.insertSublayer(gradientLayer, at: 0)
    }

    private func roundCorner() {
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.clear.cgColor
    }
}
