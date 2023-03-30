//
//  DatabaseHelper.swift
//  Student_CoreData
//
//  Created by Md Murad Hossain on 13/12/22.
//

import Foundation
import UIKit
import CoreData


class DatabaseHelper {
    
    
    static var shareInstance = DatabaseHelper()
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    func save(object: [String:String]){
        let lesson = NSEntityDescription.insertNewObject(forEntityName: "LessonsModal", into: context!) as! LessonsModal
        lesson.id = object["id"]
        lesson.name = object["name"]
        lesson.lessonsDescription = object["lessonsDescription"]
        lesson.thumbnail = object["thumbnail"]
        lesson.videoUrl = object["videoUrl"]
        do {
            try context?.save()
        }catch{
            print("Data is not save.")
        }
    }
    
    func getLessonData() -> [LessonsModal] {
        var lesson = [LessonsModal]()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "LessonsModal")
        do {
            lesson = try context?.fetch(fetchRequest) as! [LessonsModal]
        }catch{
            print("Can not get data")
        }
        return lesson
        
    }
    
    func deleteData(index: Int) -> [LessonsModal] {
        var lesson = getLessonData()
        context?.delete(lesson[index])
        lesson.remove(at: index)
        do {
            try context?.save()
            
        }catch{
            
            print("Can not data delete")
        }
        return lesson
    }
    
    func editData(object: [String:String], i: Int) {
        let lesson = getLessonData()
        lesson[i].id = object["id"]
        lesson[i].name = object["name"]
        lesson[i].lessonsDescription = object["lessonsDescription"]
        lesson[i].thumbnail = object["thumbnail"]
        lesson[i].videoUrl = object["videoUrl"]

        do {
            
            try context?.save()
            
        }catch{
            
            print("Data is not edit data.")
        }
    }
}
