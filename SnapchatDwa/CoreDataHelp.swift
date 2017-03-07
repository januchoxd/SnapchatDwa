//
//  CoreDataHelp.swift
//  SnapchatDwa
//
//  Created by janusz jas on 07.03.2017.
//  Copyright © 2017 Janusz Pietkun. All rights reserved.
//

import UIKit
import CoreData

func addAllPokemon() {
   
    createPokemon(name: "Mew", imageName: "mew")
    createPokemon(name: "Rattata", imageName: "rattata")
    createPokemon(name: "Snorlax", imageName: "snorlax")
    createPokemon(name: "Pidgey", imageName: "pidgey")
    createPokemon(name: "Pikachu", imageName: "pikachu")
    createPokemon(name: "Pidgey", imageName: "pidgey")
    createPokemon(name: "Psyduck", imageName: "psyduck")
    createPokemon(name: "Abra", imageName: "abra")
    createPokemon(name: "Squirtle", imageName: "squirtle")
    createPokemon(name: "Star", imageName: "star")
    

    //zapisanie w core data
    (UIApplication.shared.delegate as! AppDelegate).saveContext()
}
//funckja tworząca pokemony po nazwie i nazwie pliku obrazka ( cought jest domyslnie ustawiony jako NO - false boolean)
func createPokemon(name: String, imageName: String){
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let pokemon = Pokemon(context: context)
    pokemon.name = name
    pokemon.imageName = imageName
}
