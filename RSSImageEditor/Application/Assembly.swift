//
//  Assembly.swift
//  RSSImageEditor
//
//  Created by Владислав Банков on 26.01.2021.
//

import UIKit

enum Assembly {
	static func initModule() -> FeedViewController {
		FeedViewController(presenter: FeedPresenter())
	}
}
