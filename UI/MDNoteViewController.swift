//
//  MDNoteViewController.swift
//  MDSimpleNote
//
//  Created by MDLE on 2019-04-07.
//  Copyright © 2019 dcre8tive. All rights reserved.
//

import Foundation
import UIKit

class MDNoteViewController: UIViewController, MDStoryboardable {
    
    var presenter: MDNotePresenter!
    var notes = [MDNote]()
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var searchbar: UISearchBar!
    
    private func setupNavigationBar() {
        
        //Add note button
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNoteTapped(_:)))
        self.navigationItem.rightBarButtonItem = addButton
        
        //Table header title
        self.title = "Notes"
        
        //Make the table nicer with empty space
        self.tableview.tableFooterView = UIView(frame: .zero)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        presenter.fetchNotes()
    }
    
    @IBAction func addNoteTapped(_ sender: AnyObject) {
        self.showNotePrompt()
    }
}

//Alerts
extension MDNoteViewController {
    //Show error
    func showError(with: String) {
        let ac = UIAlertController(title: presenter.errorAlertTitle, message: with, preferredStyle: .alert)
        let action = UIAlertAction(title: presenter.dismissButtonTitle, style: .default, handler: nil)
        ac.addAction(action)
        present(ac, animated: true)
    }
    //Show note prompt
    func showNotePrompt() {
        let ac = UIAlertController(title: presenter.promptAlertTitle, message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let actionCancel = UIAlertAction(title: presenter.cancelButtonTitle, style: .cancel, handler: nil)
        let actionAdd = UIAlertAction(title: presenter.addButtonTitle, style: .default) { [unowned ac] _ in
            self.presenter.addNote(text: ac.textFields![0].text)
        }
        
        ac.addAction(actionAdd)
        ac.addAction(actionCancel)
        
        present(ac, animated: true)
    }
}


extension MDNoteViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MDCustomTableCell
        cell.noteText.text = notes[indexPath.row].text
        cell.noteTimeDate.text = notes[indexPath.row].addDate
        return cell
    }
}

extension MDNoteViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if (searchBar.text?.count == 0) {
            presenter.fetchNotes()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchKey = searchbar.text, !searchKey.isEmpty else {
            print("Emptied keyword check")
            return
        }
        searchbar.resignFirstResponder()
        presenter.search(keyword: searchKey)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchbar.resignFirstResponder()
        presenter.fetchNotes()
    }
    
}
