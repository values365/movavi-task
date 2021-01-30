//
//  FeedPresenter.swift
//  RSSImageEditor
//
//  Created by Владислав Банков on 26.01.2021.
//

import Foundation

protocol IFeedPresenter: AnyObject {
	func loadData()
	func viewDidLoad(with viewController: IFeedViewController)
}

final class FeedPresenter {

	private weak var feedViewController: IFeedViewController?

	private var feed: [String] = []
	private var feedImages: [String] = []
	private var url: URL?

}

extension FeedPresenter: IFeedPresenter {
	func viewDidLoad(with viewController: IFeedViewController) {
		feedViewController = viewController
		loadData()
	}

	func loadData() {
		guard let url = URL(string: StringConstants.sourceURL.rawValue) else {
			return assertionFailure("couldn't get 'URL' from source 'String'")
		}
		let parser = XMLParserManager(with: url)
		feed = parser.allFeeds()
		feedImages = parser.allImages()
		feedViewController?.fillData(with: feed, images: feedImages)
	}
}
