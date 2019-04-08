//
//  ViewController.swift
//  FloorData
//
//  Created by student1 on 4/1/19.
//  Copyright © 2019 clara. All rights reserved.
//

import UIKit
import CoreData

class FloorTableViewController: UITableViewController {

    var floors: [Floor] = []
    
    var managedContext: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedContext = appDelegate!.persistentContainer.viewContext
    
        loadFloors()
    }
    
    @IBAction func addFloor(_ sender: Any) {
        addFloor()
        refreshTable()
    }
    
    @IBAction func deleteFloor(_ sender: Any) {
        deleteSelectedFloor()
        refreshTable()
    }
    
    @IBAction func increasePrice(_ sender: Any) {
        increasePriceForSelectedFloor()
        refreshTable()
    }
    
    func refreshTable() {
        loadFloors()
        tableView.reloadData()
    }
    
    func loadFloors() {
        let fetchRequest = NSFetchRequest<Floor>(entityName: "Floor")
        
        do {
            floors = try managedContext!.fetch(fetchRequest)
        } catch {
            print("Error fetching data because \(error)")
        }
    }
    
    func addFloor() {
        let floor = Floor(context: managedContext!)
        
        // Random values for type and price
        let price = Float((20...30).randomElement()!)
        let type = ["Carpet", "Wood", "Tile"].randomElement()
        
        floor.type = type
        floor.price = price
        
        do {
            try managedContext!.save()
        } catch {
            print("Error saving, \(error)")
        }
    }
    
    func deleteSelectedFloor() {
        guard let selectedPath = tableView.indexPathForSelectedRow else { return }
        let row = selectedPath.row
        
        let floor = floors[row]
        
        managedContext!.delete(floor)
        
        do {
            try managedContext!.save()
        } catch {
            print("Error deleting \(error)")
        }
    }
    
    
    func increasePriceForSelectedFloor() {
        guard let selectedPath = tableView.indexPathForSelectedRow  else { return }
        let row = selectedPath.row
        
        let floor = floors[row]
        floor.price += 1
        
        do {
            try managedContext!.save()
        } catch {
            print("Error updating price because \(error)")
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FloorCell")!
        let floor = floors[indexPath.row]
        cell.textLabel?.text = floor.type
        cell.detailTextLabel?.text = "$\(floor.price) per square foot"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return floors.count
    }
}

