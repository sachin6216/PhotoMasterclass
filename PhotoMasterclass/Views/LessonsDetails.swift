//
//  MovieDetails.swift
//  PhotoMasterclass
//
//  Created by Sachin on 26/03/23.
//

import SwiftUI
import URLImage
struct LessonsDetails : View {
	var singleLesson: LessonsItem
	var body: some View {
		VStack {
            URLImage(url: URL(string:  "\(singleLesson.thumbnail)")!) { image in
                image.resizable()
                    .frame(width: UIScreen.main.bounds.height/8*3, height: UIScreen.main.bounds.height/2)
            }
			HStack {
				Text("Description").foregroundColor(.gray)
				Spacer()
			}
			Spacer()
		}.navigationBarTitle(Text("Name 111"), displayMode: .inline)
			.padding()
	}
}

