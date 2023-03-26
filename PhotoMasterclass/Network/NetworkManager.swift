//
//  NetworkManager.swift
//  PhotoMasterclass
//
//  Created by Sachin on 26/03/23.
//

import Alamofire
import Foundation
import Combine

class NetworkManager: ObservableObject {
    @Published var lessonsList = LessonsList(lessons: [])
	@Published var loading = false
	private let api_url_base = "https://iphonephotographyschool.com/test-api/lessons"
	init() {
		loading = true
		loadDataByAlamofire()
	}
	
	private func loadDataNormal() {
		guard let url = URL(string: "\(api_url_base)") else { return }
		URLSession.shared.dataTask(with: url){ (data, _, _) in
			guard let data = data else { return }
			let lessonResponse = try! JSONDecoder().decode(LessonsList.self, from: data)
			DispatchQueue.main.async {
				self.lessonsList = lessonResponse
				self.loading = false
			}
		}.resume()
	}
	
	private func loadDataByAlamofire() {
		Alamofire.request("\(api_url_base)")
			.responseJSON{ response in
				guard let data = response.data else { return }
				let lessonResponse = try! JSONDecoder().decode(LessonsList.self, from: data)
				DispatchQueue.main.async {
					self.lessonsList = lessonResponse
					self.loading = false
				}
		}
	}
}
