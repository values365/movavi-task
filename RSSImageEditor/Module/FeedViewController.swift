//
//  FeedViewController.swift
//  RSSImageEditor
//
//  Created by Владислав Банков on 26.01.2021.
//

import UIKit

protocol IFeedViewController: AnyObject {
	var tapButtonHandler: ((FilterType) -> Void)? { get set }
	func fillData(with feed: [String], images: [String])
}

final class FeedViewController: UIViewController {

	// MARK: - Properties

	var tapButtonHandler: ((FilterType) -> Void)?

	private var currentFilter = FilterType.Default
	private var presenter: IFeedPresenter
	private var feed: [String] = []
	private var images: [String] = []

	// MARK: - Main View

	private let feedView = FeedView()

	// MARK: - Init

	init(presenter: IFeedPresenter) {
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
		self.presenter.viewDidLoad(with: self)
		self.tapButtonHandler = { [weak self] filterType in
			guard let self = self else { return assertionFailure("self is nil") }
			self.currentFilter = filterType
			self.feedView.reloadData()
		}
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Life Cycle

	override func loadView() {
		self.view = feedView
		feedView.tableViewDataSource = self
		feedView.tableViewDelegate = self
		feedView.delegate = self
	}
}

// MARK: - Table View Data Source

extension FeedViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return feed.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: FeedCell.identifier, for: indexPath) as! FeedCell
		guard let url = URL(string: images[indexPath.row]) else {
			assertionFailure("couldn't cast 'String' into 'URL'")
			return cell
		}
		guard let data = try? Data(contentsOf: url) else {
			assertionFailure("couldn't fetch data from 'URL'")
			return cell
		}
		guard let image = UIImage(data: data) else {
			assertionFailure("couldn't build an 'UIImage' from 'Data'")
			return cell
		}
		cell.setTitle(feed[indexPath.row])
		cell.setImage(image.addFilter(filter: currentFilter))
		return cell
	}
}

// MARK: - Table View Delegate

extension FeedViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		if indexPath.row == feed.count - 1 {
			let alert = UIAlertController(title: "Конец списка", message: "Загрузить новую порцию новостей?", preferredStyle: .alert)
			let confirmAction = UIAlertAction(title: "Да", style: .default) { [weak self] action in
				guard let self = self else { return assertionFailure("self reference is nil") }
				self.presenter.loadData()
				self.feedView.reloadData()
			}

			let cancelAction = UIAlertAction(title: "Нет", style: .cancel)
			alert.addAction(confirmAction)
			alert.addAction(cancelAction)
			self.present(alert, animated: true)
		}
	}
}

// MARK: - IFeedViewController

extension FeedViewController: IFeedViewController {
	func fillData(with feed: [String], images: [String]) {
		self.feed = feed
		self.images = images
	}
}
