//
//  ViewController.swift
//  Todoey
//
//  Created by Peter Larson on 3/27/18.
//  Copyright © 2018 Peter Larson. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController{

    var itemArray = [Item]()
    
    //First way to persist data
    //let defaults = UserDefaults.standard
    
    //Second way to persist data (objects)
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
        
        loadItems()
        
        
        //print(dataFilePath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].checked = !itemArray[indexPath.row].checked
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /**
        returns number of rows in table
    */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //reusable cell seems to mess up check boxes
        //we need to associate a property with the item, not the cell -> model
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoItemCell", for: indexPath)
        let curItem = itemArray[indexPath.row]
        
        cell.textLabel?.text = curItem.itemName
        
        //using model to determine checkbox
        cell.accessoryType = curItem.checked ? .checkmark : .none
        
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
            
            let newItem = Item(context: self.context)
            newItem.itemName = textField.text!
            newItem.checked = false
            self.itemArray.append(newItem)
            
            
            self.saveItems()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK - saveItems function
    func saveItems(){
        do{
           try context.save()
        } catch{
            print("Error trying to encode data", " \(error)")
        }
        tableView.reloadData()
    }

    //MARK - loadItems function
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest()){
        
        do{
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
}

//MARK - Search bar methods
extension TodoListViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
       
        request.predicate = NSPredicate(format: "itemName CONTAINS[cd] %@",searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "itemName", ascending: true)]
        
       loadItems(with: request)
        
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

