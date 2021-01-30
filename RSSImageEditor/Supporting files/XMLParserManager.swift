//
//  XMLParserManager.swift
//  RSSImageEditor
//
//  Created by Владислав Банков on 30.01.2021.
//

import Foundation

final class XMLParserManager: NSObject, XMLParserDelegate {

	// MARK: - Properties

	private var parser = XMLParser()
	private var feeds: [String] = []
	private var img: [String] = []
	private var element = ""
	private var title = ""

	init(with url: URL) {
		super.init()
		startParsing(url)
	}

	private func startParsing(_ url: URL) {
		feeds = []
		guard let parser = XMLParser(contentsOf: url) else {
			return assertionFailure("couldn't build 'XMLParser' from 'URL'")
		}
		parser.delegate = self
		parser.shouldProcessNamespaces = false
		parser.shouldReportNamespacePrefixes = false
		parser.shouldResolveExternalEntities = false
		parser.parse()
	}

	// MARK: - Public Methods

	func allFeeds() -> [String] { feeds }

	func allImages() -> [String] { img }

	// MARK: - XMLParserDelegate

	func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
		element = elementName
		if element.isEqual("item") {
			title = ""
		} else if element.isEqual("enclosure") {
			if let urlString = attributeDict["url"] {
				img.append(urlString)
			}
		}
	}

	func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
		if (elementName as NSString).isEqual(to: "item") {
			if title != "" {
				feeds.append(title)
			}
		}
	}

	func parser(_ parser: XMLParser, foundCharacters string: String) {
		if element.isEqual("title") {
			title.append(string)
		}
	}
}
