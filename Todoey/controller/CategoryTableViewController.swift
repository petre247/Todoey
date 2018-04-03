//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Peter Larson on 3/30/18.
//  Copyright © 2018 Peter Larson. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryTableViewController: SwipeTableViewController {
    let realm = try! Realm()
    
    // MARK - Global variables
    var categoryArray: Results<Category>?
    
    // MARK - View did load function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
        //Adding colors
        tableView.separatorStyle = .none //colors right up to the end
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories added"
        
        if let color = UIColor(hexString: categoryArray?[indexPath.row].color ?? "1D9BF6"){ //random colors
            cell.backgroundColor = color
            cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
      
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
            newCategory.color = UIColor.randomFlat.hexValue()
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
    
    
    //delete data from swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let category = self.categoryArray?[indexPath.row] {
            do{
                try self.realm.write {
                    self.realm.delete(category)
                }
            }catch {
                print("Error saving checked status: \(error)")
            }
        }
    }
}


