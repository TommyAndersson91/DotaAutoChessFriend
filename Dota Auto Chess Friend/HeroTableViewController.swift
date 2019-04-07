//
//  TableViewController.swift
//  Dota Auto Chess Friend
//
//  Created by Tommy Andersson on 2019-03-24.
//  Copyright © 2019 Tommy Andersson. All rights reserved.
//

import UIKit
import Foundation
import SQLite

struct CellData {
    let heroName: String
    let heroClass: String
    let heroRace: String
    let image : UIImage
}




class TableViewController: UITableViewController, UISearchResultsUpdating{
    var database: Connection!
    let heroesTable = Table("heroes")
  static var arr : [(name : String, race: String, class: String)] = []
    var searchController = UISearchController()
    var resultsController = UITableViewController()
    var filteredArray: [(name : String, race: String, hClass: String)] = []
    override func viewDidLoad() {
        super.viewDidLoad()
       
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("heroes").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
            
        } catch {
            print(error)
        }
        
        searchController = UISearchController(searchResultsController: resultsController)
//        tableView.tableHeaderView = searchController.searchBar
        searchController.searchResultsUpdater = self
       resultsController.tableView.delegate = self
        resultsController.tableView.dataSource = self
        
    }
    //TODO: Implement filtering of heroes.
  func updateSearchResults(for searchController: UISearchController) {
//        filteredArray = arr.filter({ (arg0) -> Bool in
//
//            let (name, race, hclass) = arg0
//            if filteredArray.contains(where: { (arg0) -> Bool in
//                searchController.searchBar.text
//                let (name, race, hClass) = arg0
//                return true
//            })
//        }) as! [(name: String, race: String, hClass: String)]
   }
    
  
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfHeroes = 0
        do {
            let heroes = try self.database.prepare(self.heroesTable)
            for hero in heroes {
                numberOfHeroes = numberOfHeroes+1
                
            }
        } catch {
            print(error)
        }
        return numberOfHeroes
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:HeroesTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as! HeroesTableViewCell
         queryAllHeroesReadings()
        cell.heroName.text = TableViewController.arr[indexPath.row].name
        cell.heroClass.text! = TableViewController.arr[indexPath.row].class
        cell.heroRace.text! = TableViewController.arr[indexPath.row].race
        cell.heroThumb.image = UIImage (named:TableViewController.arr[indexPath.row].name)
     
                return cell
        
        
        
        
    }
    
    func setCells(cell :HeroesTableViewCell) {
        
        do {
            let heroes = try self.database.prepare(self.heroesTable)
            for hero in heroes {
                cell.heroName.text = hero[Hero.name]
                cell.heroClass.text! = hero[Hero.heroClass]
                cell.heroRace.text! = hero[Hero.race]
                cell.heroThumb.image = UIImage (named:hero[Hero.name])
                
            }
        } catch {
            print(error)
        }
     
    }
    
    func queryAllHeroesReadings() -> [(String, String, String)] {
        do {
             let sql = try database?.prepare("SELECT * FROM heroes")
            
            for row in sql! {
                TableViewController.arr += [(name: row[1] as! String, race: row[2] as! String, class: row[3] as! String)]
            }
            return TableViewController.arr;
        }
        catch {
            print(error)
        }
        return [("","","")]
    }
 
    

        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier ==  "segueToDetail" {
                if let cell = sender as? UITableViewCell,
                    let indexPath = tableView.indexPath(for: cell) {
                let vc = segue.destination as! HeroDetailView
                HeroDetailView.hName = TableViewController.arr[indexPath.row].name
                HeroDetailView.hRace = TableViewController.arr[indexPath.row].race
                HeroDetailView.hClass = TableViewController.arr[indexPath.row].class
                HeroDetailView.hIndex = indexPath.row

                  
                    

            }
        }

    
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if identifier == "segueToDetail" {
            return true
            
        }
        
        if  identifier == "admin" {
        let alertController = UIAlertController(title: "Admin Password", message: "Please input admin password", preferredStyle: .alert)
        
        let enable = UIAlertAction(title: "Enable", style: .default) { (_) in
            let field = alertController.textFields?[0].text
            if let x = UserDefaults.standard.string(forKey: "admin password"), x == field {
                
                self.performSegue(withIdentifier: "admin", sender: Any?.self)
                
                
            }
            else{
                
                let wrongPwd = UIAlertController(title: "Wrong Admin Password", message: nil, preferredStyle:UIAlertController.Style.alert)
                wrongPwd.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(wrongPwd, animated: true, completion: nil)
               
                
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Admin Password"
            textField.isSecureTextEntry = true
        }
        
        alertController.addAction(enable)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
         
    }
        return false
    }
   

}
