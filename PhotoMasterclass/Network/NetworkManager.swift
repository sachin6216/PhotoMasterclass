//
//  NetworkManager.swift
//  PhotoMasterclass
//
//  Created by Sachin on 26/03/23.
//

import Foundation
import Combine

class NetworkManager: ObservableObject {
    @Published var lessonsList = LessonsList(lessons: [])
	@Published var loading = false
	private let api_url_base = "https://iphonephotographyschool.com/test-api/lessons"
	init() {
		loading = true
        getListLessons()
	}
	/// Get list lessons from the server
	private func getListLessons() {
        guard let url = URL(string: "\(api_url_base)") else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.cachePolicy = .returnCacheDataElseLoad
        
        URLSession.shared.dataTask(with: urlRequest){ (data, response, error) in
            guard let data = data else { return }
            if error == nil {
                let lessonResponse = try! JSONDecoder().decode(LessonsList.self, from: data)
                DispatchQueue.main.async {
                    self.lessonsList = lessonResponse
                    self.loading = false
                }
            } else {
                self.loading = false
            }
            
        }.resume()
	}
}
// MARK: Download File With asynchronous
func downloadFileAsync(url: URL,item: LessonsItem, completionHanlder: @escaping (String, LessonsItem) -> Void) {
    let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let destinationUrl = documentsUrl.appendingPathComponent(url.lastPathComponent)
    if FileManager().fileExists(atPath: destinationUrl.path) {
        print("File already exists [\(destinationUrl.path)]")
        completionHanlder(destinationUrl.path, item)
    } else {
        let config = URLSessionConfiguration.background(withIdentifier: "id-background")
        let session = URLSession(configuration: config, delegate: nil, delegateQueue: nil)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            if error == nil {
                if let response = response as? HTTPURLResponse {
                    print("Saved!!!")
                    if response.statusCode == 200 {
                        if let data = data {
                            if let _ = try? data.write(to: destinationUrl, options: Data.WritingOptions.atomic) {
                                completionHanlder(destinationUrl.path, item)
                            } else {
                                completionHanlder(destinationUrl.path, item)
                            }
                        } else {
                            completionHanlder(destinationUrl.path, item)
                        }
                    }
                }
            }
        })
        task?.resume()
    }
}
