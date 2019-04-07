//
//  Hero.swift
//  Dota Auto Chess Friend
//
//  Created by Tommy Andersson on 2019-03-24.
//  Copyright © 2019 Tommy Andersson. All rights reserved.
//

import UIKit
import SQLite

class Hero: NSObject {
    
   public static var id = Expression<Int>("id")
   public static var name = Expression<String>("name")
   public static var race = Expression<String>("race")
   public static var heroClass = Expression<String>("class")
   public static var heroImage = Expression<String>("image")
   public static var heroImages = [UIImage]()
   public static var heroRaces = ["Beast", "Demon", "Dragon", "Dwarf", "Element", "Elf",
                     "Goblin", "Human", "Naga", "Ogre", "Orc", "Satyr", "Troll", "Undead" ]
    
   public static var heroClasses = ["Assassin", "Demon Hunter", "Druid", "Hunter",
                       "Knight", "Mage", "Mech", "Shaman", "Warlock", "Warrior" ]
    
//    init (name: String, race: String, heroClass: String){
//
//        self.name = name
//        self.race = race
//        self.heroClass = heroClass
//        self.heroImage = UIImage (named: name)!
//
//    }
//

}
