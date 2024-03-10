//
//  NotesListViewController.swift
//  FocusStartTestTask
//
//  Created by Vitaly on 10.03.2024.
//

import UIKit

class NotesListViewController: UITableViewController {
    
    // MARK: - Properties
    
    var notes: [Note]!
    
    var dataSource: UITableViewDiffableDataSource<Int, Note>!
    var notesSnapShot: NSDiffableDataSourceSnapshot<Int, Note> {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Note>()
        
        snapshot.appendSections([0])
        snapshot.appendItems(notes)
        
        return snapshot
    }
    
    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadSavedNotes()
        setupView()
        setupNavigationBar()
        configureTableView()
    }
    
    
    // MARK: @Objc Methods
    
    @objc private func newNote() {
        let newNote = Note(name: "New note", text: "New note text")
        notes.append(newNote)
        
        dataSource.apply(notesSnapShot)
    }
    
    // MARK: View Configuration
    
    private func setupView() {
        self.view.backgroundColor = .white
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Notes List"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newNote))
    }
    
    private func loadSavedNotes() {
        if let savedNotes = Note.loadNotes() {
            self.notes = savedNotes
        } else {
            self.notes = Note.sampleNotes()
        }
    }
}

extension NotesListViewController: NoteViewControllerDelegate {
    func saveEditedNote(_ note: Note) {
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            notes[selectedIndexPath.row] = note
            dataSource.apply(notesSnapShot)
        }
        
        saveNotes()
    }
    
    func saveNotes() {
        Note.saveNotes(notes)
    }
}


extension NotesListViewController {
    // MARK: Table View Diffable Data Source
    
    private func configureTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "NoteCell")
        configureTableViewDataSource(tableView)
    }
    
    private func configureTableViewDataSource(_ tableView: UITableView) {
        dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)
            
            var content = cell.defaultContentConfiguration()
            content.text = item.name
            content.secondaryText = item.text
            
            cell.contentConfiguration = content
            
            return cell
        })
        
        dataSource.apply(notesSnapShot)
    }
}

extension NotesListViewController {
    // MARK: Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedNote = notes[indexPath.row]
        
        let noteVC = NoteViewController()
        noteVC.note = selectedNote
        noteVC.delegate = self
        
        navigationController?.pushViewController(noteVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = self.deleteRowAction(atIndexPath: indexPath)
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    private func deleteRowAction(atIndexPath indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, _ in
            guard let self = self else { return }
            
            notes.remove(at: indexPath.row)
            dataSource.apply(notesSnapShot)
            
            saveNotes()
        }
        
        action.backgroundColor = .systemRed
        action.image = UIImage(systemName: "trash")
        
        return action
    }
}

