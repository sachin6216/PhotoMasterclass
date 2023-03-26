//
//  Movie.swift
//  PhotoMasterclass
//
//  Created by Sachin on 26/03/23.
//

import Foundation

struct LessonsItem: Decodable, Identifiable {
	var id: Int
    var name: String
    var description: String
    var thumbnail: String
    var video_url: String
}
