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
    
    // MARK: Properties
    var note: Note!
    var delegate: NoteViewControllerDelegate?
    
    private var noteTextView = UITextView()
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupTextView()
        setObservers()
        
        noteTextView.text = note.text
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        note.text = noteTextView.text
        delegate?.saveEditedNote(note)
    }
    
    // Check for memory leak.
    deinit {
        print("\(note.name) view controller deinited")
    }
    
    // MARK: View Configuration
    
    private func setupView() {
        self.view.backgroundColor = .white
        self.navigationItem.title = note.name
        self.navigationItem.largeTitleDisplayMode = .never
    }
    
    private func setupTextView() {
        noteTextView.delegate = self
        noteTextView.font = UIFont.systemFont(ofSize: 20)
        noteTextView.allowsEditingTextAttributes = true
        
        self.view.addSubview(noteTextView)
        
        noteTextView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            noteTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            noteTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            noteTextView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.95),
            noteTextView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
    
    // MARK: @Objc Methods
    
    @objc private func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            noteTextView.contentInset = .zero
        } else {
            noteTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        noteTextView.scrollIndicatorInsets = noteTextView.contentInset
        
        let selectedRange = noteTextView.selectedRange
        noteTextView.scrollRangeToVisible(selectedRange)
    }
    
    private func setObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
 }
