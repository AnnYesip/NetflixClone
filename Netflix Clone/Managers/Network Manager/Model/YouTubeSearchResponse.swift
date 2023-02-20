//
//  YouTubeSearchResponse.swift
//  Netflix Clone
//
//  Created by Ann Yesip on 02.10.2022.
//

import Foundation

struct YouTubeSearchResponse: Codable {
    let items: [VideoElement]
}

struct VideoElement: Codable {
    let id: IdVideoElement
}

struct IdVideoElement: Codable {
    let kind: String
    let videoId: String
}
