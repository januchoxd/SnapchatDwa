//
//  PokeAnnotation.swift
//  SnapchatDwa
//
//  Created by janusz jas on 07.03.2017.
//  Copyright © 2017 Janusz Pietkun. All rights reserved.
//

import UIKit
import MapKit

//subklasa
class  PokeAnnotation : NSObject, MKAnnotation {
    //optrzebujemy cordynaty
    var coordinate: CLLocationCoordinate2D
    
    var pokemon: Pokemon
    
    //potrzebujemy inicjalizera
    init(coord: CLLocationCoordinate2D, pokemon: Pokemon) {
        self.coordinate = coord
        self.pokemon = pokemon
        
    }
}
