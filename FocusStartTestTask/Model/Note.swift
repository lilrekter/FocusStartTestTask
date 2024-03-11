//
//  Note.swift
//  FocusStartTestTask
//
//  Created by Vitaly on 10.03.2024.
//

import Foundation

struct Note: Hashable, Codable {
    
    static private let keys: String = "savedNotes"
    
    private let id: String
    var name: String
    var text: String
    
    init(name: String, text: String) {
        self.id = UUID().uuidString
        self.name = name
        self.text = text
    }
    
    static func sampleNotes() -> [Note] {
        return [Note(name: "Your First Note", text: "First note text")]
    }
    
    static func saveNotes(_ notes: [Note]) {
        guard let data = try? JSONEncoder().encode(notes) else {
            print("Fail to encode notes")
            return
        }
        
        UserDefaults.standard.set(data, forKey: keys)
    }
    
    static func loadNotes() -> [Note]? {
        guard let data = UserDefaults.standard.object(forKey: keys) as? Data,
              let notes = try? JSONDecoder().decode([Note].self, from: data) else {
            print("Fail to load notes")
            return nil
        }
        
        return notes
    }
}
