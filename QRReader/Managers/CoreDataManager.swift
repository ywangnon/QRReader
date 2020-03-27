//
//  File.swift
//  QRReader
//
//  Created by Hansub Yoo on 2020/03/26.
//  Copyright © 2020 Hansub Yoo. All rights reserved.
//

//import UIKit
//import CoreData
//
//class CoreDataManager {
//    static let shared: CoreDataManager = CoreDataManager()
//
//    let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
//    lazy var context = appDelegate?.persistentContainer.viewContext
//
//    let modelName: String = "QRCodes"
//
//    func getCodes(ascending: Bool = false) -> [QRCodes] {
//        var models: [QRCodes] = [QRCodes]()
//
//        if let context = context {
//            let idSort: NSSortDescriptor = NSSortDescriptor(key: "id", ascending: ascending)
//            let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest<NSManagedObject>(entityName: modelName)
//            fetchRequest.sortDescriptors = [idSort]
//
//            do {
//                if let fetchResult: [QRCodes] = try context.fetch(fetchRequest) as? [QRCodes] {
//                    models = fetchResult
//                }
//            } catch let error as NSError {
//                print("Could not fetch😃: \(error), \(error.userInfo)")
//            }
//        }
//        return models
//    }
//
//    func saveCodes(id: Int64,
//                   content: String,
//                   date: Date = Date(),
//                   onSuccess: @escaping ((Bool) -> Void)) {
//        if let context = context,
//            let entity: NSEntityDescription = NSEntityDescription.entity(forEntityName: modelName, in: context) {
//            if let code: QRCodes = NSManagedObject(entity: entity, insertInto: context) as? QRCodes {
//                code.id = id
//                code.qrContent = content
//                code.date = date
//
//
//            }
//        }
//    }
//}
//
//extension CoreDataManager {
//    fileprivate func contextSave(onSuccess: ((Bool) -> Void)) {
//        do {
//            try context.save()
//        } catch <#pattern#> {
//            <#statements#>
//        }
//    }
//}
import UIKit
import CoreData

class CoreDataManager {
    static let shared: CoreDataManager = CoreDataManager()
    
    let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
    lazy var context = appDelegate?.persistentContainer.viewContext
    
    let modelName: String = "Users"
    
    func getUsers(ascending: Bool = false) -> [QRCodes] {
        var models: [QRCodes] = [QRCodes]()
        
        if let context = context {
            let idSort: NSSortDescriptor = NSSortDescriptor(key: "id", ascending: ascending)
            let fetchRequest: NSFetchRequest<NSManagedObject>
                = NSFetchRequest<NSManagedObject>(entityName: modelName)
            fetchRequest.sortDescriptors = [idSort]
            
            do {
                if let fetchResult: [QRCodes] = try context.fetch(fetchRequest) as? [QRCodes] {
                    models = fetchResult
                }
            } catch let error as NSError {
                print("Could not fetch🥺: \(error), \(error.userInfo)")
            }
        }
        return models
    }
    
    func saveUser(id: Int64,
                  content: String,
                  date: Date = Date(),
                  onSuccess: @escaping ((Bool) -> Void)) {
        if let context = context,
            let entity: NSEntityDescription
            = NSEntityDescription.entity(forEntityName: modelName, in: context) {
            
            if let code: QRCodes = NSManagedObject(entity: entity, insertInto: context) as? QRCodes {
                code.id = id
                code.qrContent = content
                code.date = date
                
                contextSave { success in
                    onSuccess(success)
                }
            }
        }
    }
    
    func deleteUser(id: Int64, onSuccess: @escaping ((Bool) -> Void)) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = filteredRequest(id: id)
        
        do {
            if let results: [QRCodes] = try context?.fetch(fetchRequest) as? [QRCodes] {
                if results.count != 0 {
                    context?.delete(results[0])
                }
            }
        } catch let error as NSError {
            print("Could not fatch🥺: \(error), \(error.userInfo)")
            onSuccess(false)
        }
        
        contextSave { success in
            onSuccess(success)
        }
    }
}

extension CoreDataManager {
    fileprivate func filteredRequest(id: Int64) -> NSFetchRequest<NSFetchRequestResult> {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult>
            = NSFetchRequest<NSFetchRequestResult>(entityName: modelName)
        fetchRequest.predicate = NSPredicate(format: "id = %@", NSNumber(value: id))
        return fetchRequest
    }
    
    fileprivate func contextSave(onSuccess: ((Bool) -> Void)) {
        do {
            try context?.save()
            onSuccess(true)
        } catch let error as NSError {
            print("Could not save🥶: \(error), \(error.userInfo)")
            onSuccess(false)
        }
    }
}
