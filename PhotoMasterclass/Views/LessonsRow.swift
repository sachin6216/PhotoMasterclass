//
//  LessonsRow.swift
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
            if let url = URL(string:  "\(singleLesson.thumbnail)") {
                URLImage(url: url) { image in
                    image.resizable()
                        .frame(width: 100, height: 65)
                        .cornerRadius(10)
                }
            }
            Text(singleLesson.name)
                .lineLimit(3)
        }
	}
}
