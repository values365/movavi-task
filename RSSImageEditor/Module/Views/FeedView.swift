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

	var tableViewDelegate: UITableViewDelegate? {
		get { tableView.delegate }
		set { tableView.delegate = newValue }
	}

	var delegate: IFeedViewController?

	// MARK: - UI Components

	private let tableView = UITableView()
	private let buttonsView = UIView()

	private let filterButton1 = UIButton()
	private let filterButton2 = UIButton()
	private let filterButton3 = UIButton()

	// MARK: - Init

	init() {
		super.init(frame: .zero)

		setupAppearance()
		setupLayout()
		setupTargets()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Public Methods

	func reloadData() {
		tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: true)
		DispatchQueue.main.async { [weak self] in
			guard let self = self else { return assertionFailure("self reference is nil") }
			self.tableView.reloadData()
		}
	}
}

// MARK: - Internal Methods

private extension FeedView {
	func setupTargets() {
		filterButton1.addTarget(self, action: #selector(filterButton1DidTapped), for: .touchUpInside)
		filterButton2.addTarget(self, action: #selector(filterButton2DidTapped), for: .touchUpInside)
		filterButton3.addTarget(self, action: #selector(filterButton3DidTapped), for: .touchUpInside)
	}

	@objc func filterButton1DidTapped() {
		delegate?.tapButtonHandler?(FilterType.Mono)
	}

	@objc func filterButton2DidTapped() {
		delegate?.tapButtonHandler?(FilterType.Chrome)
	}

	@objc func filterButton3DidTapped() {
		delegate?.tapButtonHandler?(FilterType.Fade)
	}
}

// MARK: - Appearance & Layout

private extension FeedView {
	func setupAppearance() {
		backgroundColor = .systemBackground
		buttonsView.backgroundColor = .systemBackground
		tableView.register(FeedCell.self, forCellReuseIdentifier: FeedCell.identifier)

		// buttons setting
		filterButton1.setTitle(FilterType.MonoName.rawValue, for: UIControl.State.normal)
		filterButton2.setTitle(FilterType.ChromeName.rawValue, for: UIControl.State.normal)
		filterButton3.setTitle(FilterType.FadeName.rawValue, for: UIControl.State.normal)

		filterButton1.titleLabel?.font = .systemFont(ofSize: Constants.titleSize.rawValue)
		filterButton2.titleLabel?.font = .systemFont(ofSize: Constants.titleSize.rawValue)
		filterButton3.titleLabel?.font = .systemFont(ofSize: Constants.titleSize.rawValue)

		filterButton1.setTitleColor(.systemIndigo, for: UIControl.State.normal)
		filterButton2.setTitleColor(.systemIndigo, for: UIControl.State.normal)
		filterButton3.setTitleColor(.systemIndigo, for: UIControl.State.normal)

		filterButton1.titleLabel?.textAlignment = .center
		filterButton2.titleLabel?.textAlignment = .center
		filterButton3.titleLabel?.textAlignment = .center


	}

	func setupLayout() {
		addSubview(buttonsView)
		buttonsView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			buttonsView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: Constants.defaultSpacing.rawValue),
			buttonsView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
			buttonsView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
			buttonsView.heightAnchor.constraint(equalToConstant: Constants.buttonsViewHeight.rawValue)
		])

		addSubview(tableView)
		tableView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
			tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
			tableView.bottomAnchor.constraint(equalTo: buttonsView.topAnchor)
		])

		// buttons setting
		buttonsView.addSubview(filterButton1)
		buttonsView.addSubview(filterButton2)
		buttonsView.addSubview(filterButton3)
		filterButton1.translatesAutoresizingMaskIntoConstraints = false
		filterButton2.translatesAutoresizingMaskIntoConstraints = false
		filterButton3.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			filterButton1.topAnchor.constraint(equalTo: buttonsView.topAnchor),
			filterButton1.leadingAnchor.constraint(equalTo: buttonsView.leadingAnchor),
			filterButton1.bottomAnchor.constraint(equalTo: buttonsView.bottomAnchor),
			filterButton1.widthAnchor.constraint(equalTo: buttonsView.widthAnchor, multiplier: Constants.buttonWidthMultiplier.rawValue),

			filterButton2.topAnchor.constraint(equalTo: buttonsView.topAnchor),
			filterButton2.centerXAnchor.constraint(equalTo: buttonsView.centerXAnchor),
			filterButton2.bottomAnchor.constraint(equalTo: buttonsView.bottomAnchor),
			filterButton2.widthAnchor.constraint(equalTo: buttonsView.widthAnchor, multiplier: Constants.buttonWidthMultiplier.rawValue),

			filterButton3.topAnchor.constraint(equalTo: buttonsView.topAnchor),
			filterButton3.trailingAnchor.constraint(equalTo: buttonsView.trailingAnchor),
			filterButton3.bottomAnchor.constraint(equalTo: buttonsView.bottomAnchor),
			filterButton3.widthAnchor.constraint(equalTo: buttonsView.widthAnchor, multiplier: Constants.buttonWidthMultiplier.rawValue),
		])
	}
}
