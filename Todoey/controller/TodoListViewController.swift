//
//  ViewController.swift
//  Todoey
//
//  Created by Peter Larson on 3/27/18.
//  Copyright © 2018 Peter Larson. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    //First way to persist data
    //let defaults = UserDefaults.standard
    
    //Second way to persist data (objects)
    let  dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let newItem = Item(name: "Find Mike")
        itemArray.append(newItem)
        let newItem2 = Item(name: "Buy Eggs")
        itemArray.append(newItem2)
        let newItem3 = Item(name: "Take over the world")
        itemArray.append(newItem3)
        
        for num in 1...20 {
            itemArray.append(Item(name: "Take over the world \(num)"))
        }
        
        //first method of persisting data
        //if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
        //    itemArray = items
        //}
        
        //second method of persisting data
        loadItems()
        print(dataFilePath!)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].updateState()
        
        //persist data method 2
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
            self.itemArray.append(Item(name: textField.text!))
            
            //first way to persist data
           // self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            //second way to persisrt data
            self.saveItems()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //Method 2: Persisting data save/load items
    func saveItems(){
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch{
            print("Error trying to encode data", " \(error)")
        }
        tableView.reloadData()
    }

    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
                try itemArray = decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding item array ","\(error)")
            }
        }
    }
}

