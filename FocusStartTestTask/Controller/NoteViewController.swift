//
//  NoteViewController.swift
//  FocusStartTestTask
//
//  Created by Vitaly on 10.03.2024.
//

import UIKit

protocol NoteViewControllerDelegate {
    func saveEditedNote(_ note: Note)
}

class NoteViewController: UIViewController, UITextViewDelegate {
    
    var note: Note!
    var delegate: NoteViewControllerDelegate?
    
    var noteTextView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.navigationItem.title = note.name
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        setupTextView()
        
        noteTextView.text = note.text

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        note.text = noteTextView.text
        delegate?.saveEditedNote(note)
    }
    
    private func setupTextView() {
        noteTextView.delegate = self
        
        self.view.addSubview(noteTextView)
        
        noteTextView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            noteTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            noteTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            noteTextView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.95),
            noteTextView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
    
    deinit {
        print("\(note.name) view controller deinited")
    }

}
