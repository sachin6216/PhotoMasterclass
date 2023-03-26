//
//  ContentView.swift
//  PhotoMasterclass
//
//  Created by Sachin on 26/03/23.
//
import Foundation
import SwiftUI

struct ContentView : View {
	@ObservedObject var networkManager = NetworkManager()
	var body: some View {
		NavigationView {
			VStack {
				if networkManager.loading {
					Text("Loading ...")
				} else {
                    List(networkManager.lessonsList.lessons) { lessons in
                        NavigationLink(destination: MyLessonDetailsViewController(lessonsList: networkManager.lessonsList.lessons, currentLesson: lessons)) {
                            LessonsRow(singleLesson: lessons)
						}
                    }
                    .listStyle(.plain)
				}
			}
			.navigationBarTitle(Text("Lessons"))
		}
	}
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
#endif
struct MyLessonDetailsViewController: UIViewControllerRepresentable {
    var lessonsList = [LessonsItem]()
    var currentLesson: LessonsItem?

    func makeUIViewController(context: Context) -> LessonDetailsViewController {
        let nextVc = UIStoryboard(name: "Details", bundle: nil).instantiateViewController(identifier: "LessonDetailsViewController") as! LessonDetailsViewController
        nextVc.lessonsList = self.lessonsList
        nextVc.currentLesson = self.currentLesson
        return nextVc
    }
    
    func updateUIViewController(_ uiViewController: LessonDetailsViewController, context: Context) {
    }
    
    typealias UIViewControllerType = LessonDetailsViewController
}
