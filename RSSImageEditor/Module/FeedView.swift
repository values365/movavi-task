//
//  FeedView.swift
//  RSSImageEditor
//
//  Created by Владислав Банков on 26.01.2021.
//

import UIKit

final class FeedView: UIView {

	// MARK: - Properties

	var tableViewDataSource: UITableViewDataSource? {
		get { tableView.dataSource }
		set { tableView.dataSource = newValue }
	}

	// MARK: - Root View

	private let tableView = UITableView()

	// MARK: - Init

	init() {
		super.init(frame: .zero)

		setupAppearance()
		setupLayout()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// MARK: - Appearance & Layout

private extension FeedView {
	func setupAppearance() {
		backgroundColor = .systemBackground
		tableView.register(FeedCell.self, forCellReuseIdentifier: FeedCell.identifier)
	}

	func setupLayout() {
		addSubview(tableView)
		tableView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
			tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
			tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
		])
	}
}
