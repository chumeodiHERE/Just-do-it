//
//  ViewController.swift
//  Just do it
//
//  Created by Gia Huy on 27/08/2022.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var models = [ToDoListItem]()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "JUST DO IT🫵"
        view.addSubview(tableView)
        getAllItem()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewItem))
    }
    
    @objc func addNewItem() {
        let alert = UIAlertController(title: "New Item", message: "Enter new item and save", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Save", style: .cancel, handler: { [weak self] _ in
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else {
                return
            }
            
            self?.createItem(content: text)
        }))
        present(alert, animated: true)
    }
    
    //TABLE VIEW
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm E, d MMM y"
        var Itemcontent = cell.defaultContentConfiguration()
        Itemcontent.text = model.content
        Itemcontent.secondaryText = formatter.string(from: model.history!)
        cell.contentConfiguration = Itemcontent
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = models[indexPath.row]
        
        let actionSheet = UIAlertController(title: "Edit Item", message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: { _ in
            let alert = UIAlertController(title: "Edit Item", message: nil, preferredStyle: .alert)
            alert.addTextField(configurationHandler: nil)
            alert.textFields?.first?.text = item.content
            alert.addAction(UIAlertAction(title: "Save", style: .cancel, handler: { [weak self] _ in
                guard let field = alert.textFields?.first, let newText = field.text, !newText.isEmpty else {
                    return
                }
                
                self?.updateItem(item: item, newContent: newText)
            }))
            self.present(alert, animated: true)
        }))
        actionSheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            self?.deleteItem(item: item)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true)
    }
    
    
    //CORE DATA
    func getAllItem() {
        do {
            models = try context.fetch(ToDoListItem.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            fatalError("FAIL")
        }
    }
    
    func createItem(content: String) {
        let newItem = ToDoListItem(context: context)
        newItem.content = content
        newItem.history = Date.now
        
        do {
            try context.save()
            getAllItem()
        } catch {
            fatalError("FAIL")
        }
    }
    
    func deleteItem(item: ToDoListItem) {
        context.delete(item)
        
        do {
            try context.save()
            getAllItem()
        } catch {
            fatalError("FAIL")
        }
    }
    
    func updateItem(item: ToDoListItem, newContent: String) {
        item.content = newContent
        item.history = Date.now
        
        do {
            try context.save()
            getAllItem()
        } catch {
            fatalError("FAIL")
        }
    }
}

