//
//  ActionsListManager.swift
//  
//
//  Created by Łukasz Stachnik on 26/07/2022.
//

import Foundation

protocol ActionsListManager {
    var actions: [Action] { get set }
}

final class LocalActionsListManager: ActionsListManager {
    var actions: [Action]
    let localActionsRepository: LocalActionsRepository
    
    init(localActionsRepository: LocalActionsRepository) throws {
        self.localActionsRepository = localActionsRepository
        self.actions = try localActionsRepository.readActions()
    }
    
    func showActions() {
        print("====================================================================")
        actions
            .sorted { !$0.completed  && $1.completed }
            .forEach { action in
                action.completed ? print("✅: \(action.name)") : print("❗️: \(action.id) \(action.name)")
            }
        print("====================================================================")
    }
    
    func addAction(with name: String) throws {
        actions
            .append(Action(id: UUID().uuidString,
                           name: name,
                           completed: false))
        try localActionsRepository.saveActions(actions: actions)
        showActions()
    }
    
    func completeAction(with id: String) throws {
        let index = actions.firstIndex { $0.id == id }
        
        guard let index = index else {
            return
        }

        actions[index].completed = true
        try localActionsRepository.saveActions(actions: actions)
        showActions()
    }
    
    func deleteAction(with id: String) throws {
        let index = actions.firstIndex { $0.id == id }
        
        guard let index = index else {
            return
        }

        actions.remove(at: index)
        try localActionsRepository.saveActions(actions: actions)
        showActions()
    }
}
