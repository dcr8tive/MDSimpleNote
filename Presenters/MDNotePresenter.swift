//
//  MDNotePresenter.swift
//  MDSimpleNote
//
//  Created by MDLE on 2019-04-07.
//  Copyright © 2019 dcre8tive. All rights reserved.
//

import Foundation
import UIKit


class MDNotePresenter {
    
    let viewController: MDNoteViewController
    let service: MDDataService

    let errorAlertTitle = "Error"
    let promptAlertTitle = "Add Note"
    
    let dismissButtonTitle = "Dismiss"
    let cancelButtonTitle = "Cancel"
    let addButtonTitle = "Add"
    
    init(service: MDDataService, viewController: MDNoteViewController) {
        self.viewController = viewController
        self.service = service
    }
    

    func fetchNotes() {
        self.fetchData(predicate: nil) { (notes, error) in
            guard let notes = notes else {
                self.viewController.showError(with: "Can't load data from coredata with error")
                return
            }
            self.updateTableWith(data: notes)
        }
    }
    
    func addNote(text: String?) {
        guard let text = text, !text.isEmpty else {
            viewController.showError(with: "Missing note")
            return
        }
        self.saveData(with: text) { (note, error) in
            guard let note = note else {
                self.viewController.showError(with: "Can't save note with error")
                return
            }
            self.updateTableWith(data: [note])
        }
    }

    func search(keyword: String) {
        let predicate = NSPredicate(format: "text contains[c] %@", keyword)
        self.fetchData(predicate: predicate) { (notes, error) in
            guard let notes = notes else {
                self.viewController.showError(with: "Can't load data from coredata with error")
                return
            }
            self.updateTableWith(data: notes)
        }
    }
    
    private func updateTableWith(data: [MDNote]) {
        self.viewController.notes.removeAll()
        self.viewController.notes.append(contentsOf: data)
        self.viewController.tableview.reloadData()
    }

}

extension MDNotePresenter: APIDataService {
    
    func fetchData(predicate: NSPredicate?, completion: @escaping ([MDNote]?, NSError?) -> Void) {
        service.fetchData(predicate: predicate) { (notes, error) in
            completion(notes, error)
        }
    }
    
    func saveData(with: String, completion: @escaping (MDNote?, NSError?) -> Void) {
        service.saveData(with: with) { (note, error) in
            completion(note, error)
        }
    }
    
    func cleanup() {
        //
    }
}

