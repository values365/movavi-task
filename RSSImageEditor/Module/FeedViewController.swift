//
//  FeedViewController.swift
//  RSSImageEditor
//
//  Created by Владислав Банков on 26.01.2021.
//

import UIKit

protocol IFeedViewController: AnyObject {
	var UIImages: [UIImage] { get set }
	var isAllDownloaded: Bool { get set }
	var tapButtonHandler: ((FilterType) -> Void)? { get set }
	func fillData(with collection: [UIImage])
	func filterUIImageCollection(with filter: FilterType)
	func notify()
	func reloadData()
}

final class FeedViewController: UIViewController {
	
	// MARK: - Properties
	
	var tapButtonHandler: ((FilterType) -> Void)?
	var UIImages: [UIImage] = []
	var isAllDownloaded = false
	private var presenter: IFeedPresenter
	
	// MARK: - Main View
	
	private let feedView = FeedView()
	
	// MARK: - Init
	
	init(presenter: IFeedPresenter) {
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
		self.presenter.viewDidLoad(with: self)
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
		return presenter.feed.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: FeedCell.identifier, for: indexPath) as! FeedCell
		cell.setTitle(presenter.feed[indexPath.row])
		cell.setImage(UIImages[indexPath.row])
		return cell
	}
}

// MARK: - Table View Delegate

extension FeedViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		if indexPath.row == presenter.feed.count - 1 {
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
	func filterUIImageCollection(with filter: FilterType) {
		DispatchQueue.global(qos: .userInitiated).async { [weak self] in
			guard let self = self else { return assertionFailure("self reference is nil") }
			for (index, image) in self.UIImages.enumerated() {
				self.UIImages[index] = image.addFilter(filter: filter)
				self.feedView.reloadData()
			}
		}
	}
	
	func fillData(with collection: [UIImage]) {
		self.isAllDownloaded = true
		self.UIImages = collection
	}
	
	func notify() {
		let alert = UIAlertController(title: "Идет загрузка контента", message: "Пожалуйста, подождите пока все фотографии загрузятся, прежде чем применять к ним фильтры.", preferredStyle: .alert)
		let cancelAction = UIAlertAction(title: "OK", style: .cancel)
		alert.addAction(cancelAction)
		self.present(alert, animated: true)
	}
	
	func reloadData() {
		feedView.reloadData()
	}
}
