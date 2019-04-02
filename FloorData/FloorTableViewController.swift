//
//  ViewController.swift
//  FloorData
//
//  Created by student1 on 4/1/19.
//  Copyright © 2019 clara. All rights reserved.
//
import CoreData
import UIKit

class FloorTableViewController: UITableViewController {

    var floors: [NSManagedObject] = []
    
    var managedContext: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        managedContext = appDelegate.persistentContainer.viewContext
        
        refreshTable()
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
        increasePriceSelectedFloor()
        refreshTable()
    }
    
    
    func refreshTable() {
        loadFloors()
        tableView.reloadData()
    }
    
    
    func loadFloors() {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Floor")
        
        do {
            floors = try managedContext!.fetch(fetchRequest)
        } catch {
            print("Error fetching data because \(error)")
        }
    }

    
    func addFloor() {
        
        let floorEntity = NSEntityDescription.entity(forEntityName: "Floor", in: managedContext!)!
        
        let floor = NSManagedObject(entity: floorEntity, insertInto: managedContext)
        
        // Random values for type and price
        // The Core Data side doesn't care where the data comes from.
        let price = (20...30).randomElement()
        let type = ["Carpet", "Wood", "Tile"].randomElement()
        
        floor.setValue(type, forKeyPath: "type")
        floor.setValue(price, forKeyPath: "price")
        
        do {
            try managedContext!.save()
        } catch {
            print("Error saving, \(error)")
        }
    }

    
    func increasePriceSelectedFloor() {
        
        guard let selectedPath = tableView.indexPathForSelectedRow  else { return }
        let row = selectedPath.row
        
        let floorEntity = floors[row]
        let price = floorEntity.value(forKeyPath: "price") as! Int
        let newPrice = price + 1
        floorEntity.setValue(newPrice, forKey: "price")
        
        do {
            try managedContext!.save()
        } catch {
            print("Error updating price because \(error)")
        }
    }
    
    
    func deleteSelectedFloor() {
        
        guard let selectedPath = tableView.indexPathForSelectedRow else { return }
        let row = selectedPath.row
        
        let floorEntity = floors[row]
        
        managedContext!.delete(floorEntity)
        
        do {
            try managedContext!.save()
        } catch {
            print("Error deleting \(error)")
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FloorCell")!
        
        let floorEntity = floors[indexPath.row]
        let type = floorEntity.value(forKey: "type") as! String
        let price = floorEntity.value(forKey: "price") as! Float
    
        cell.textLabel?.text = type
        cell.detailTextLabel?.text = "$\(price) per square foot"
    
        return cell
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return floors.count
    }
    
}

