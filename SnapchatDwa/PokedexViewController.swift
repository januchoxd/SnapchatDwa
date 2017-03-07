//
//  PokedexViewController.swift
//  SnapchatDwa
//
//  Created by janusz jas on 07.03.2017.
//  Copyright © 2017 Janusz Pietkun. All rights reserved.
//

import UIKit

class PokedexViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    //w widoku mapy przycisk pokedex (pokeball) ustawilismy przeciągając go do tego viewa wybierajac present modaly, natomiast tutaj musimy kodem zrobić aby ten widok się schował ( dismiss)
    @IBAction func mapTapped(_ sender: Any) {
        //funkcja chowająca ten view
        dismiss(animated: true, completion: nil)
        
        
    }
 

}
