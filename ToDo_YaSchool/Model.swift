//
//  Model.swift
//  ToDo_YaSchool
//
//  Created by Roman Tverdokhleb on 03.08.2022.
//

import Foundation

var toDoItems: [[String: Any]] {
    set {
        UserDefaults.standard.set(newValue, forKey: "ToDoDateKey")
        UserDefaults.standard.synchronize()
    }
    get {
        if let array = UserDefaults.standard.array(forKey: "ToDoDateKey") as? [[String: Any]] {
            return array
        } else {
            return []
        }
}
}

func addItem(nameItem: String, isCompleted: Bool = false) {
    toDoItems.append(["Name": nameItem, "isCompleted": isCompleted])
}

func removeItem(at index: Int) {
    toDoItems.remove(at: index)
}

func moveItem(fromIndex: Int, toIndex: Int) {
    let from = toDoItems[fromIndex]
    toDoItems.remove(at: fromIndex)
    toDoItems.insert(from, at: toIndex)
}

func changeState(at item: Int) -> Bool {
    toDoItems[item]["isCompleted"] = !(toDoItems[item]["isCompleted"] as! Bool)
    return toDoItems[item]["isCompleted"] as! Bool
}
