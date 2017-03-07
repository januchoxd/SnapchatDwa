//
//  PokedexViewController.swift
//  SnapchatDwa
//
//  Created by janusz jas on 07.03.2017.
//  Copyright © 2017 Janusz Pietkun. All rights reserved.
//

import UIKit

//dodajemy delgate i datasource potrzebne do tabeli
class PokedexViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var caughtPokemons : [Pokemon] = []
    var uncaughtPokemons : [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        caughtPokemons = getAllCaughtPokemons()
        uncaughtPokemons = ungetAllUnCaughtPokemons()
        
        //potrzebny do tablicy
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }
    //funkcja która zwraca ile sekcji będzie miała tabela ( u nas 2 - złapane i niezłapane pokemony)
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    //funkcja która do konkretnego nr sekcji doda tytuł
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Zlapane"
        } else {
            return "Niezlapane"
        }
    }
    
    //ile kolumn w zalezności która do sekcja
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return caughtPokemons.count
        } else {
            return uncaughtPokemons.count
        }
    }
    
    //dla wszystkich taka sama
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //niech pokemon będzie typu Pokemon
        let pokemon : Pokemon
        //tak tutaj można sprawdzić sekcje
        if indexPath.section == 0 {
            pokemon = caughtPokemons[indexPath.row]
        } else {
            pokemon = uncaughtPokemons[indexPath.row]
        }
        
        let cell = UITableViewCell()
        cell.textLabel?.text = pokemon.name
        cell.imageView?.image = UIImage(named: pokemon.imageName!)
        return cell
    }
    
    
    // ktora została kolumna wybrana
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
   
    
    //w widoku mapy przycisk pokedex (pokeball) ustawilismy przeciągając go do tego viewa wybierajac present modaly, natomiast tutaj musimy kodem zrobić aby ten widok się schował ( dismiss)
    @IBAction func mapTapped(_ sender: Any) {
        //funkcja chowająca ten view
        dismiss(animated: true, completion: nil)
        
    }
 

}
