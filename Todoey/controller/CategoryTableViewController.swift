//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Peter Larson on 3/30/18.
//  Copyright © 2018 Peter Larson. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class CategoryTableViewController: UITableViewController {
    let realm = try! Realm()
    
    // MARK - Global variables
    var categoryArray: Results<Category>?
  
    // MARK - View did load function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80
        
        loadCategories()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       //for swipeable interface
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! SwipeTableViewCell
        
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories added"
         //for swipeable interface
        cell.delegate = self
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK - prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
            
        }
    }
    
    
    
    // MARK - set up add button callback
    @IBAction func addButtonPressed(_ sender: Any) {
        //local variable to be used when updating list
        var textField = UITextField()
        
        //alert that shows up when an + is added
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        
        //makes alert have text field and saves entered value to textField variable
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category"
            textField = alertTextField
        }
        
        //action that is called when ok is pressed
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = textField.text!
            self.save(category: newCategory)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: setup save and load data
    func save(category: Category){
        do{
            try realm.write {
                realm.add(category)
            }
        } catch{
            print("Error trying to encode data", " \(error)")
        }
        tableView.reloadData()
        
    }
    func loadCategories(){
        categoryArray = realm.objects(Category.self)
        
        tableView.reloadData()
    }
}

//swipe cell delegate methods
extension CategoryTableViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            
            if let category = self.categoryArray?[indexPath.row] {
                do{
                    try self.realm.write {
                        self.realm.delete(category)
                    }
                }catch {
                    print("Error saving checked status: \(error)")
                }
                tableView.reloadData()
            }
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive
        return options
    }
    
}
