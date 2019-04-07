//
//  ViewController.swift
//  Dota Auto Chess Friend
//
//  Created by Tommy Andersson on 2019-03-24.
//  Copyright © 2019 Tommy Andersson. All rights reserved.
//

import UIKit
import SQLite

class ViewController: UIViewController {
    var race: String = ""
    var hClass: String = ""
    var name: String = ""
    var database: Connection!
    static var heroList = [Hero]()
    static var heroLister = [(heroId: Int, heroName: String, heroClass: String, heroRace: String)]()
    let heroesTable = Table("heroes")
    let defaults = UserDefaults.standard
    @IBOutlet weak var heroNameText: UITextField!
    
    @IBOutlet weak var heroRacesPicker: UIPickerView!
    @IBOutlet weak var heroClassesPicker: UIPickerView!
    
    @IBOutlet weak var heroImage: UIImageView!
    
    var imagePicker = UIImagePickerController()
   
    
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
       
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        
        heroRacesPicker.dataSource = self
        heroRacesPicker.delegate = self
        
        heroClassesPicker.dataSource = self
        heroClassesPicker.delegate = self
        
        
        defaults.set(heroesTable, forKey: "savedHeroes")
    }
    
    @IBAction func listHeroes(_ sender: Any) {
        
        print("Listing heroes")
        
        do {
            let heroes = try self.database.prepare(self.heroesTable)
            for hero in heroes {
                print ("heroID: \(hero[Hero.id]), Name: \(hero[Hero.name]), Race: \(hero[Hero.race]),  heroClass: \(hero[Hero.heroClass])")
                
            }
        } catch {
            print(error)
        }
        
    }
    
    
    
    @IBAction func updateHero(_ sender: Any) {
        let alert = UIAlertController(title: "Update hero", message: nil, preferredStyle: .alert)
        alert.addTextField { (UITextField) in
            UITextField.placeholder = "Hero ID" }
        alert.addTextField { (UITextField) in
            UITextField.placeholder = "Hero name" }
       
        let action = UIAlertAction(title: "send", style: .default) { (_) in
            guard let heroIdString = alert.textFields?.first?.text,
            let heroId = Int(heroIdString),
            let name = alert.textFields?.last?.text
            else { return }
            
            let hero = self.heroesTable.filter(Hero.id == heroId)
            let updateHero = hero.update(Hero.name <- name)
            do {
               try self.database.run(updateHero)
                let updated = UIAlertController(title: "The hero have been updated", message: nil, preferredStyle:UIAlertController.Style.alert)
                updated.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(updated, animated: true, completion: nil)
            } catch {
                print(error)
            }
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        }
    


    
    @IBAction func deleteHero(_ sender: Any) {
        let alert = UIAlertController(title: "Delete Hero", message: nil, preferredStyle: .alert)
        alert.addTextField { (UITextField) in
            UITextField.placeholder = "Hero id" }
        let action = UIAlertAction(title: "Send", style: .default) { (UIAlertAction) in
            guard let heroIdString = alert.textFields?.first?.text,
            let heroId = Int(heroIdString)
            else { return }
            let hero = self.heroesTable.filter(Hero.id == heroId)
            let deleteHero = hero.delete()
            do {
               try self.database.run(deleteHero)
              print("Hero deleted")
            } catch {
                print(error)
            }
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func createTable(_ sender: Any) {
            print ("Creating table")
            let createTable = self.heroesTable.create { (table) in
                table.column(Hero.id, primaryKey: true)
                table.column(Hero.name, unique: true)
                table.column(Hero.race)
                table.column(Hero.heroClass)
                table.column(Hero.heroImage)
            }
            do {
                try self.database.run(createTable)
                print("Created the table")
            } catch {
                print(error)
            }
    }
    
    
    
    
    @IBAction func saveHeroButton(_ sender: Any) {
        
        
        name = heroNameText.text!
        print("test")
      

        if((heroNameText.text?.isEmpty)!){
            heroNameText.layer.borderColor = UIColor.red.cgColor
            return
        }
      
        let insertHero = self.heroesTable.insert(Hero.name <- name, Hero.heroClass <- hClass, Hero.race <- race, Hero.heroImage <- name)
        do {
            try self.database.run(insertHero)
            Hero.heroImages.append(heroImage.image!)
//            Hero.heroImages.last?.accessibilityIdentifier = name
            print("\(name) saved")
        } catch {
            print(error)
        }
        heroNameText.text=""
        
    }
    @IBAction func importPicture(_ sender: Any) {
         present(imagePicker, animated: true, completion: nil)
    }
    
   
    
   
}



extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    func numberOfComponents(in heroRacesPicker: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView == heroRacesPicker) {
        return Hero.heroRaces.count
        }
        else {
            return Hero.heroClasses.count
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView == heroRacesPicker) {
            race = Hero.heroRaces[row]
        } else {
            hClass = Hero.heroClasses[row]
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView == heroRacesPicker) {
        return Hero.heroRaces[row]
        } else {
            return Hero.heroClasses[row]
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
          heroImage.image = image
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}


