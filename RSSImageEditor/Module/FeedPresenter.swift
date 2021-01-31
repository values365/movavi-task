//
//  FeedPresenter.swift
//  RSSImageEditor
//
//  Created by Владислав Банков on 26.01.2021.
//

import Foundation
import UIKit

protocol IFeedPresenter: AnyObject {
	var feed: [String] { get set }
	func loadData()
	func viewDidLoad(with viewController: IFeedViewController)
}

final class FeedPresenter {
	
	// MARK: - Properties
	
	var feed: [String] = []
	private weak var feedViewController: IFeedViewController?
	private var feedImages: [String] = []
	private var url: URL?
	
}

// MARK: - Internal Methods

private extension FeedPresenter {
	func fetchCollection() {
		fillCollection()
		DispatchQueue.global(qos: .userInteractive).async { [weak self] in
			guard let self = self else { return assertionFailure("self reference is nil") }
			for index in 0..<self.feedImages.count {
				guard let url = URL(string: self.feedImages[index]) else { return assertionFailure("couldn't cast 'String' into 'URL'") }
				guard let data = try? Data(contentsOf: url) else { return assertionFailure("couldn't fetch data from 'URL'") }
				guard let image = UIImage(data: data) else { return assertionFailure("couldn't build an 'UIImage' from 'Data'") }
				self.feedViewController?.UIImages[index] = image
				self.feedViewController?.reloadData()
			}
			self.feedViewController?.isAllDownloaded = true
		}
	}
	
	func fillCollection() {
		for _ in feed.enumerated() {
			feedViewController?.UIImages.append(UIImage(named: "waiting")!)
		}
	}
}

// MARK: - IFeedPresenter

extension FeedPresenter: IFeedPresenter {
	func viewDidLoad(with viewController: IFeedViewController) {
		feedViewController = viewController
		loadData()
		feedViewController?.tapButtonHandler = { [weak self] filterType in
			guard let self = self else { return assertionFailure("self is nil") }
			guard let feedViewController = self.feedViewController else { return assertionFailure("self is nil") }
			feedViewController.isAllDownloaded ?
				feedViewController.filterUIImageCollection(with: filterType) : feedViewController.notify()
		}
	}
	
	func loadData() {
		guard let url = URL(string: StringConstants.sourceURL.rawValue) else {
			return assertionFailure("couldn't get 'URL' from source 'String'")
		}
		let parser = XMLParserManager(with: url)
		feed = parser.allFeeds()
		feedImages = parser.allImages()
		fetchCollection()
	}
}
