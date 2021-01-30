//
//  FilterType.swift
//  RSSImageEditor
//
//  Created by Владислав Банков on 30.01.2021.
//

import Foundation

enum FilterType: String {
	case Mono = "CIPhotoEffectMono"
	case Chrome = "CIPhotoEffectChrome"
	case Fade = "CIPhotoEffectFade"

	case MonoName = "Mono"
	case ChromeName = "Chrome"
	case FadeName = "Fade"

	case Default
}
