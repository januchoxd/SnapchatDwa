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

