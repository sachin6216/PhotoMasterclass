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
    
    /// Save entry into database
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
    /// Get all data from database
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
    
    /// Delete data from database
    func deleteData(itemID: Int) {
        var lesson = getLessonData()
        context?.delete(lesson[itemID])
        lesson.remove(at: itemID)
        do {
            try context?.save()
            
        }catch{
            print("Can not data delete")
        }
    }
}
