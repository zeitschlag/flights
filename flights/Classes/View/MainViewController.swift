//
//  MainViewController.swift
//  flights
//
//  Created by Nathan Mattes on 11.03.17.
//  Copyright © 2017 Nathan Mattes. All rights reserved.
//

import UIKit
import MapKit

enum AnnotationIdentifier {
    static let Airport = "airportAnnotationIdentifier"
    static let FlightPosition = "flightPositionAnnotationIdentifier"
}

class MainViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var flightIdTextField: UITextField!
    
    override func viewDidLoad() {
        
    }
    
    @IBAction func searchButtonTapped(_ sender: Any) {
       
        guard let flightId = flightIdTextField.text, flightId != "" else {
            return
        }
        
        if flightIdTextField.isFirstResponder {
            flightIdTextField.resignFirstResponder()
        }

        mapView.removeAnnotations(mapView.annotations)
        
        FlightManager.shared.flightWith(iataCode: flightId.uppercased(), success: { [weak self] (flight) in
            
            guard let currentFlightPosition = flight.currentFlightPosition else {
                return
            }
            
            // Annotation for current Position of the flight
            let location = CLLocationCoordinate2D(latitude: Double(currentFlightPosition.latitude), longitude: Double(currentFlightPosition.longitude))
            
            let title = "Current position of \(flightId.uppercased())"
            let annotation = FlightPositionAnnotation(withIdentifier: AnnotationIdentifier.FlightPosition, at: location, withTitle: title)
            annotation.subtitle = flight.aircraft ?? nil
            
            self?.mapView.addAnnotation(annotation)
            
            if let destinationAirport = flight.destinationAirport, let destinationAirportLocation = destinationAirport.coordinate, let airportName = destinationAirport.name {
                let destionationAirportAnnotation = AirportAnnotation(withIdentifier: AnnotationIdentifier.Airport, at: destinationAirportLocation, withTitle: airportName)
                
                self?.mapView.addAnnotation(destionationAirportAnnotation)
            }
            
            OperationQueue.main.addOperation {
                //TODO: Center MapView
                self?.mapView.setCenter(location, animated: true)
            }

        }) { [weak self] (error) in
            let alert = UIAlertController(title: "Something went wrong 😟", message: error.localizedDescription, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(okAction)
            self?.present(alert, animated: true, completion: nil)
        }
    }
}

extension MainViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var annotationView = MKPinAnnotationView()
        
        if let annotation = annotation as? FlightPositionAnnotation {
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: AnnotationIdentifier.FlightPosition) as? MKPinAnnotationView {
                annotationView = dequeuedView
                annotationView.annotation = annotation
                annotationView.pinTintColor = .blue
                annotationView.canShowCallout = true
            } else {
                annotationView =  MKPinAnnotationView(annotation: annotation, reuseIdentifier: AnnotationIdentifier.FlightPosition)
                annotationView.pinTintColor = .blue
                annotationView.canShowCallout = true
            }
            
            return annotationView
            
        }
        
        if let annotation = annotation as? AirportAnnotation {
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: AnnotationIdentifier.Airport) as? MKPinAnnotationView {
                annotationView = dequeuedView
                annotationView.annotation = annotation
                annotationView.pinTintColor = UIColor.green
                annotationView.canShowCallout = true
            } else {
                annotationView =  MKPinAnnotationView(annotation: annotation, reuseIdentifier: AnnotationIdentifier.Airport)
                annotationView.pinTintColor = UIColor.green
                annotationView.canShowCallout = true
            }
            
            return annotationView
            
        }
        
        return nil
        
    }
}
