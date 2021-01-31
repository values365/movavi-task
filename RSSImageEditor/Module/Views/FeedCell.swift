//
//  FeedCell.swift
//  RSSImageEditor
//
//  Created by Владислав Банков on 26.01.2021.
//

import UIKit

final class FeedCell: UITableViewCell {
	
	// MARK: - Properties
	
	static let identifier = "feed-cell"
	
	// MARK: - UI Components
	
	private let titleLabel = UILabel()
	private let contentImage = UIImageView()
	
	// MARK: - Init
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		setupAppearances()
		setupLayouts()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		if selected {
			self.setSelected(false, animated: false)
		}
	}
	
	// MARK: - Public Methods
	
	func setTitle(_ title: String) {
		titleLabel.text = title
	}
	
	func setImage(_ image: UIImage) {
		contentImage.image = image
	}
}

// MARK: - Appearances

private extension FeedCell {
	func setupAppearances() {
		contentImage.layer.cornerRadius = Constants.imageCornerRadius.rawValue
		contentImage.layer.masksToBounds = true
		
		titleLabel.numberOfLines = 0
		titleLabel.font = .systemFont(ofSize: Constants.titleSize.rawValue)
		titleLabel.textAlignment = .center
	}
}

// MARK: - Layouts

private extension FeedCell {
	func setupLayouts() {
		addSubview(contentImage)
		contentImage.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			contentImage.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.defaultSpacing.rawValue),
			contentImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.defaultSpacing.rawValue),
			contentImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -Constants.defaultSpacing.rawValue),
			contentImage.widthAnchor.constraint(equalToConstant: Constants.imageWidth.rawValue),
			contentImage.heightAnchor.constraint(equalToConstant: Constants.imageHeight.rawValue)
		])
		
		addSubview(titleLabel)
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.defaultSpacing.rawValue),
			titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -Constants.defaultSpacing.rawValue),
			titleLabel.leadingAnchor.constraint(equalTo: contentImage.trailingAnchor, constant: Constants.regularSpacing.rawValue),
			titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.defaultSpacing.rawValue)
		])
	}
}
