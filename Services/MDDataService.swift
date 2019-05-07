//
//  MDDataService.swift
//  MDSimpleNote
//
//  Created by MDLE on 2019-04-07.
//  Copyright © 2019 dcre8tive. All rights reserved.
//

import Foundation
import CoreData

enum MDDataServiceStatus {
    case completed
    case error(NSError)
}

protocol APIDataService {
    func fetchData(predicate: NSPredicate?, completion: @escaping((_ notes: [MDNote]?, _ error: NSError?)-> Void))
    func saveData(with: String, completion: @escaping(_ note: MDNote?, _ error: NSError?) -> Void)
    func cleanup()
}

class MDDataService: APIDataService {
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MDSimpleNote")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    static let shared = MDDataService()
    
    private init() {}
    
    //Get all notes from coredata
    func fetchData(predicate: NSPredicate? = nil, completion: @escaping((_ notes: [MDNote]?, _ error: NSError?)-> Void)) {
        let fetchRequest: NSFetchRequest<MDNote> = MDNote.fetchRequest()
        if (predicate != nil) {
            fetchRequest.predicate = predicate
        }
        do {
            let results = try context.fetch(fetchRequest)
            completion(results, nil)
        } catch let error as NSError{
            completion(nil, error)
        }
    }
    
    //Add new note into coredata
    func saveData(with: String, completion: @escaping(_ note: MDNote?, _ error: NSError?) -> Void) {
        let newNote = MDNote(context: context)
        newNote.text = with
        //Store date as String since CoreData store NSDate() that a bit complicated to convert
        let dateformatter =  DateFormatter()
        dateformatter.dateFormat = "MM/dd/yyyy h:mm"
        newNote.addDate = dateformatter.string(from: Date())
        
        saveContext { (status) in
            switch status {
            case .completed:
                completion(newNote, nil)
            case .error(let error):
                completion(nil, error)
            }
        }
    }
    
    func saveContext(completion: @escaping (_ status: MDDataServiceStatus) -> Void) {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                completion(MDDataServiceStatus.completed)
            } catch {
                let nserror = error as NSError
                completion(MDDataServiceStatus.error(nserror))
            }
        }
    }
    
    func cleanup() {
        //
    }
}
