//
//  ViewController.swift
//  SnapchatDwa
//
//  Created by janusz jas on 07.03.2017.
//  Copyright © 2017 Janusz Pietkun. All rights reserved.
//

import UIKit
//przy mapach potrzebujemy zaimportować mapkit
import MapKit

//dodajemy CLLOcation<enagerDelegate
class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    //manager potrzebny
    var manager = CLLocationManager()
    //aby po 3 pobraniach pozycji, mapa sama się nie centrowała na lokalizacji
    var updateCount = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.delegate = self
        
        //aby aplikacja nie pytała za każdym razem o autoryzacje sprawdzamy czy jest juz autoryzowany dostep do gps przy uzyciu
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            print("mamy juz zgode")
            //aby pokazała się kropka pokazująca aktualną pozycje na mapie
            mapView.showsUserLocation = true
            //
            manager.startUpdatingLocation()
            
            //odpalamy timer
            Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { (timer) in
                //tutaj jest ten kod który ma się wykonać w wyżej określonym interwale sekund ( ttutaj zrobimy spawn a pokemon) - pokemony będziemy pokazywać ako annotacje ( szpilki)
                if let coord = self.manager.location?.coordinate {
                let anno = MKPointAnnotation()
                anno.coordinate = coord
                //tworzymy losowe zmienne 
                let randoLat = (Double(arc4random_uniform(200)) - 100.0) / 50000.0
                let randoLon = (Double(arc4random_uniform(200)) - 100.0) / 50000.0
                    
                anno.coordinate.latitude += randoLat
                anno.coordinate.longitude += randoLon
                self.mapView.addAnnotation(anno)
                }
            })

        } else {
        //autoryzacja tylko będzie gdy aplikacja bedzie w uzyciu ( nie jak np. google maps w tle)
        manager.requestWhenInUseAuthorization()

        }
    }
        //ta funkcja będzie wykonywana gdy rozpoznany zostanie ruch
       func locationManager(_: CLLocationManager, didUpdateLocations: [CLLocation]){
        
        if updateCount < 3 {
            let region = MKCoordinateRegionMakeWithDistance(manager.location!.coordinate, 400, 400)
            mapView.setRegion(region, animated: false)
        updateCount += 1
        } else {
            //aby zaoszczędzić baterię i procesor wyłączamy update lokalizacji, ale mimo to dalej na mapie będzie widoczny ruch i gdzie się znajdujemy
            manager.stopUpdatingLocation()
            
            
        }
        
        }
        //przycisk kompasu, który ma centrować widok na kropce lokalizacji
    @IBAction func centerTapped(_ sender: Any) {
        
        if (manager.location?.coordinate) != nil {
        let region = MKCoordinateRegionMakeWithDistance(manager.location!.coordinate, 400, 400)
        mapView.setRegion(region, animated: true)
        }
    }
        
    

    


}

