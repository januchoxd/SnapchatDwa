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

//dodajemy CLLOcation<enagerDelegate i MKMapViewDelegate
class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    //manager potrzebny
    var manager = CLLocationManager()
    //aby po 3 pobraniach pozycji, mapa sama się nie centrowała na lokalizacji
    var updateCount = 0
    
    //tablica do pokemonów
    var pokemons : [Pokemon] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //za pomocą funkcji z CoreDataHelp wypełniamy tablice pokemons pokemonami
        pokemons = getAllPokemon()
        
        manager.delegate = self
        
        //aby aplikacja nie pytała za każdym razem o autoryzacje sprawdzamy czy jest juz autoryzowany dostep do gps przy uzyciu
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            setup()
        } else {
        //autoryzacja tylko będzie gdy aplikacja bedzie w uzyciu ( nie jak np. google maps w tle)
        manager.requestWhenInUseAuthorization()

        }
    }
    
    //
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            setup()
            
        }
    }
    //dla wygody stworzyliśmy oddzielną funkcje setup
    func setup() {
        mapView.delegate = self
        
        
        //aby pokazała się kropka pokazująca aktualną pozycje na mapie
        mapView.showsUserLocation = true
        //
        manager.startUpdatingLocation()
        
        //odpalamy timer
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { (timer) in
            //tutaj jest ten kod który ma się wykonać w wyżej określonym interwale sekund ( ttutaj zrobimy spawn a pokemon) - pokemony będziemy pokazywać ako annotacje ( szpilki)
            if let coord = self.manager.location?.coordinate {
                
                
                //tutaj wybierzemy sobie losowo pokemona z tablicy
                let pokemon = self.pokemons[Int(arc4random_uniform(UInt32(self.pokemons.count)))]
                
                let anno = PokeAnnotation(coord: coord, pokemon: pokemon)
                //tworzymy losowe zmienne
                let randoLat = (Double(arc4random_uniform(200)) - 100.0) / 50000.0
                let randoLon = (Double(arc4random_uniform(200)) - 100.0) / 50000.0
                
                anno.coordinate.latitude += randoLat
                anno.coordinate.longitude += randoLon
                self.mapView.addAnnotation(anno)
            }
        })

        
    }
    
    //dzieki tej funkcji zamiast szpilek możemy wyświetlić obrazek, będzie ona wykonana za kazdym razem gdy będzie pojawiać się annotacja ( szpilka)
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        // jeśli annotacja to jest kropka użytkownika to zwracamy player jako nazwe obrazka dla pozycji użytkonika
        if annotation is MKUserLocation {
            
            let annoView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
            
            annoView.image = UIImage(named: "player")
            
            //ustalamy wielkość obrazku ktory pojawi się zamiast szpilki
            var frame = annoView.frame
            frame.size.height = 50
            frame.size.width = 50
            
            //i przypisujemy znowu ustalony frame do annoView
            annoView.frame = frame
            
            return annoView

        } else {
            // dla reszty szpilek wykona się to tutaj:
        let annoView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
            
        let pokemon = (annotation as! PokeAnnotation).pokemon
        
        annoView.image = UIImage(named: pokemon.imageName!)
        
        //ustalamy wielkość obrazku ktory pojawi się zamiast szpilki
        var frame = annoView.frame
        frame.size.height = 50
        frame.size.width = 50
        
        //i przypisujemy znowu ustalony frame do annoView
        annoView.frame = frame
        
        return annoView
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
    
    //funkcja która wykona się po naciśnięciu na annotacje  ( moja lokalizacja albo szpilki)
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        // dzięki temu możemy wielkrotnie klikac na annotacje i wykona się kod
        mapView.deselectAnnotation(view.annotation!, animated: true)
        
        //sprawdzamy, czy nie klikamy użytkownia jeśli naciśniemy na użytkownika, nic się nie wykona
        if view.annotation! is MKUserLocation {
            return
        }
        
        //środkujemy na przyciśniętym pokemonie mapę i przybliżamy
        let region = MKCoordinateRegionMakeWithDistance(view.annotation!.coordinate, 200, 200)
        mapView.setRegion(region, animated: true)
        
        // dodajemy timer by usunąć opcję zmieniania przez gracza zooma mapy, przez co dalekie pokemony można by było łapać
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
            if let coord = (self.manager.location?.coordinate) {
                //odwołujemy się do danego pokemona
                let pokemon = (view.annotation! as! PokeAnnotation).pokemon
                //tu sprawdzimy czy ikona użytkownika jest tez widoczna na mapie wybranego pokemona ( czy można go złapać czy jest zbyt daleko
                if MKMapRectContainsPoint(mapView.visibleMapRect, MKMapPointForCoordinate(coord)) {
                   
                    //i zmieniamy jego caugt na tre
                    pokemon.caught = true
                    //zapisujemy zmianę w core data
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    
                    //usuwamy pokemona z mapy ( jego annotacje)
                    mapView.removeAnnotation(view.annotation!)
                    
                    //tworzymy allert ( okienko które wyskoczy z informacją na ekranie telefonu)
                    let alertVC = UIAlertController(title: "Brawo", message: "złapałeś: \(pokemon.name!)", preferredStyle: .alert)
                    
                    let OKaction = UIAlertAction(title: "Spoko", style: .default, handler: nil)
                    let pokedexAction = UIAlertAction(title: "Pokedex", style: .default, handler: { (action) in
                        self.performSegue(withIdentifier: "pokedexSegue", sender: nil)
                    })

                    
                    alertVC.addAction(OKaction)
                    alertVC.addAction(pokedexAction)
                    
                    //prezentujemy stworzony alert
                    self.present(alertVC, animated: true, completion: nil)


                    
                } else {
                    //jeślni pokemon jest zbyt daleko to:
                    //tworzymy allert ( okienko które wyskoczy z informacją na ekranie telefonu)
                    let alertVC = UIAlertController(title: "Kłopoty", message: "Jesteś zbyt daleko \(pokemon.name!)", preferredStyle: .alert)
                
                    let OKaction = UIAlertAction(title: "Spoko", style: .default, handler: nil)
                    
                    alertVC.addAction(OKaction)
                    //prezentujemy stworzony alert
                    self.present(alertVC, animated: true, completion: nil)
                    
                }

        }
        
        
        
        
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
