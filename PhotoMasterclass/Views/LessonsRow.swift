//
//  MovieRow.swift
//  PhotoMasterclass
//
//  Created by Sachin on 26/03/23.
//

import URLImage
import SwiftUI

struct LessonsRow : View {
	var singleLesson: LessonsItem
	
	var body: some View {
        HStack {
            URLImage(url: URL(string:  "\(singleLesson.thumbnail)")!) { image in
                image.resizable()
                    .frame(width: 100, height: 65)
                    .cornerRadius(10)
            }
            Text(singleLesson.name)
                .lineLimit(3)
        }
	}
}
