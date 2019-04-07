//
//  HeroDetailView.swift
//  Dota Auto Chess Friend
//
//  Created by Tommy Andersson on 2019-03-27.
//  Copyright © 2019 Tommy Andersson. All rights reserved.
//

import UIKit
import SQLite

class HeroDetailView: UIViewController {
    @IBOutlet weak var heroImage: UIImageView!
    @IBOutlet weak var heroName: UILabel!
    @IBOutlet weak var heroRace: UILabel!
    @IBOutlet weak var heroClass: UILabel!
    @IBOutlet weak var lineupInfo: UIBarButtonItem!
    

    
   static var hName: String = ""
   static var hRace: String = ""
   static var hClass: String = ""
static var hIndex: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     setup()
        lineupInfo.title = "\(Lineups.lineup.count)/10"
    }
    
    func setup() {
        heroName.text =  "Name: \(HeroDetailView.hName)"
        heroRace.text = "Race \(HeroDetailView.hRace)"
        heroClass.text = "Class \(HeroDetailView.hClass)"
        heroImage.image = UIImage (named:HeroDetailView.hName)
    }
    
    @IBAction func addToLineup(_ sender: Any) {
        print("test")
        if Lineups.lineup.count <= 9 {
        Lineups.lineup.append(TableViewController.arr[HeroDetailView.hIndex])
          lineupInfo.title = "\(Lineups.lineup.count)/10"
        } else {
            let alert = UIAlertController(title: "Maximum size", message: "A lineup can't contain more than 10 heroes", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            
        }
    }
}
