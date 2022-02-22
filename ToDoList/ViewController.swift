//
//  ViewController.swift
//  ToDoList
//
//  Created by Демьян on 21.02.2022.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet var tableView: UITableView!
    
    var tasks = [String]()
    
    func updateTasks() {
        
        tasks.removeAll()
        
        guard let count = UserDefaults().value(forKey:"count") as? Int else {
            return
        }
        
        for x in 0..<count {
            if let task = UserDefaults().value(forKey: "task_\(x+1)") as? String {
                tasks.append(task)
            }
        }
        
        tableView.reloadData() 
         
    }
    
    @IBAction func didTapAdd() {
        let vc =  storyboard?.instantiateViewController(withIdentifier: "entry") as! EntryViewController
        vc.title = "New Task"
        vc.update = {
            DispatchQueue.main.async {
                self.updateTasks()
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        let date = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd.MM.YYYY"
        
        self.title =  "Tasks for \(dateFormat.string(from: date))"
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        if !UserDefaults().bool(forKey: "setup") {
            UserDefaults().set(true, forKey: "setup")
            UserDefaults().set(0, forKey: "count")
            
        }
        
        updateTasks()
        
    }
    
    
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc =  storyboard?.instantiateViewController(withIdentifier: "task") as! TaskViewController
        vc.title = "New Task"
        vc.task =  tasks[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        
        content.text = tasks[indexPath.row]
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade )
            tableView.endUpdates()
        }
    }
   
}
    




