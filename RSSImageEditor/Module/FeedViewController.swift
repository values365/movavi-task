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

	private var presenter: IFeedPresenter
	private var feed: [String] = []
	private var images: [String] = []
	private var UIImages: [UIImage] = []
	private var isAllDownloaded = false

	// MARK: - Main View

	private let feedView = FeedView()

	// MARK: - Init

	init(presenter: IFeedPresenter) {
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
		self.presenter.viewDidLoad(with: self)
		self.tapButtonHandler = { [weak self] filterType in
			guard let self = self else { return assertionFailure("self is nil") }
			if self.isAllDownloaded {
				DispatchQueue.global(qos: .userInitiated).async { [weak self] in
					guard let self = self else { return assertionFailure("self reference is nil") }
					self.filterUIImageCollection(with: filterType)
					self.feedView.reloadData()
				}
			} else {
				let alert = UIAlertController(title: "Идет загрузка контента", message: "Пожалуйста, подождите пока все фотографии загрузятся, прежде чем применять к ним фильтры.", preferredStyle: .alert)
				let cancelAction = UIAlertAction(title: "OK", style: .cancel)
				alert.addAction(cancelAction)
				self.present(alert, animated: true)
			}
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

// MARK: - Internal Methods

private extension FeedViewController {
	func fetchUIImageCollection() {
		for (index, img) in images.enumerated() {
			guard let url = URL(string: img) else { return assertionFailure("couldn't cast 'String' into 'URL'") }
			guard let data = try? Data(contentsOf: url) else { return assertionFailure("couldn't fetch data from 'URL'") }
			guard let image = UIImage(data: data) else { return assertionFailure("couldn't build an 'UIImage' from 'Data'") }
			UIImages[index] = image
			self.feedView.reloadData()
		}
	}

	func filterUIImageCollection(with filter: FilterType) {
		for (index, image) in UIImages.enumerated() {
			UIImages[index] = image.addFilter(filter: filter)
		}
	}

	func fillCollection() {
		for _ in feed.enumerated() {
			UIImages.append(UIImage(named: "waiting")!)
		}
	}
}

// MARK: - Table View Data Source

extension FeedViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return feed.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: FeedCell.identifier, for: indexPath) as! FeedCell
		cell.setTitle(feed[indexPath.row])
		cell.setImage(UIImages[indexPath.row])
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
				self.isAllDownloaded = false
				self.presenter.loadData()
				self.feedView.moveToTop()
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
		fillCollection()
		DispatchQueue.global(qos: .userInteractive).async { [weak self] in
			guard let self = self else { return assertionFailure("self reference is nil") }
			self.fetchUIImageCollection()
			self.isAllDownloaded = true
		}
	}
}
