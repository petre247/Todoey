//
//  ViewController.swift
//  Todoey
//
//  Created by Peter Larson on 3/27/18.
//  Copyright © 2018 Peter Larson. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController{
    
    let realm = try! Realm()
    var todoItems: Results<Item>?
    var selectedCategory : Category? {
        didSet{
            loadItems()//load items when set
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do{
                try realm.write {
                    if(item.checked){
                        realm.delete(item)
                    }
                    else{
                        item.checked = !item.checked
                    }
                }
            }catch {
                print("Error saving checked status: \(error)")
            }
            tableView.reloadData()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /**
     returns number of rows in table
     */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //reusable cell seems to mess up check boxes
        //we need to associate a property with the item, not the cell -> model
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoItemCell", for: indexPath)
        if let curItem = todoItems?[indexPath.row]{
            
            cell.textLabel?.text = curItem.itemName
            //using model to determine checkbox
            cell.accessoryType = curItem.checked ? .checkmark : .none
        }
        else{
            cell.textLabel?.text = "No Items added"
        }
        return cell
    }
    
    //MARK - addButtonPressed function implementation
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        //local variable to be used when updating list
        var textField = UITextField()
        
        //alert that shows up when an item is added
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
        
        //makes alert have text field and saves entered value to textField variable
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        //action that is called when ok is pressed
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once user hits add button on ui alert
            
            
            if let currentCategory = self.selectedCategory {
                do{
                    try self.realm.write {
                        let newItem = Item()
                        newItem.itemName = textField.text!
                        currentCategory.items.append(newItem)
                    }
                } catch{
                    print("Error trying to encode data", " \(error)")
                }
                
            }
            
            
            self.tableView.reloadData()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK - loadItems function
    func loadItems(){
        todoItems = selectedCategory?.items.sorted(byKeyPath: "itemName", ascending: true)
        tableView.reloadData()
    }
}

//MARK - Search bar methods
extension TodoListViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("itemName CONTAINS[cd] %@",searchBar.text!).sorted(byKeyPath: "itemName", ascending: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {//determines thread
                searchBar.resignFirstResponder()
            }
            
        }
    }
}

