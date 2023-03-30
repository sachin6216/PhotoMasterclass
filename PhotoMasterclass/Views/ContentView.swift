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
                        if #available(iOS 14.0, *) {
                            NavigationLink(destination: self.nextVc(itemLesson: lessons).navigationBarTitleDisplayMode(.inline)) {
                                
                                LessonsRow(singleLesson: lessons)
                            }
                        } else {
                            // Fallback on earlier versions
                        }
                    }
                    .listStyle(.plain)
				}
			}
			.navigationBarTitle(Text("Lessons"))
		}
	}
    func nextVc(itemLesson: LessonsItem) -> MyLessonDetailsViewController {
        MyLessonDetailsViewController(lessonsList: networkManager.lessonsList.lessons, currentLesson: itemLesson)
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
