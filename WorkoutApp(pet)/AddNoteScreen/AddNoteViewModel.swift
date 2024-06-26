//
//  AddNoteViewModel.swift
//  WorkoutApp(pet)
//
//  Created by Danil Pestov on 09.04.2024.
//

import Foundation
import RealmSwift

protocol AddNoteViewModelDelegate: AnyObject {
    func reloadTableView()
}

class AddNoteViewModel {
    weak var delegate: AddNoteViewModelDelegate?
    var exercises: Results<Exercise>?
    let realm = try! Realm()
    
    func loadExercises() {
        exercises = realm.objects(Exercise.self)
        delegate?.reloadTableView()
    }
    
    func addExercise(_ exercise: [Exercise]) {
            let newNote = ExerciseNote()
            newNote.exercises.append(objectsIn: exercise)
            try! realm.write {
                realm.add(newNote)
            }
    }
    
    func deleteExercise(at index: Int) {
        if let exerciseToDelete = exercises?[index] {
            do {
                try realm.write {
                    realm.delete(exerciseToDelete)
                }
            } catch {
                print(error)
            }
        }
    }
    
}
