//
//  MainViewController.swift
//  flights
//
//  Created by Nathan Mattes on 11.03.17.
//  Copyright © 2017 Nathan Mattes. All rights reserved.
//

import UIKit
import MapKit

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
            
            let location = CLLocationCoordinate2D(latitude: Double(currentFlightPosition.latitude), longitude: Double(currentFlightPosition.longitude))
            let annotation = FlightPositionAnnotation(at: location, withTitle: flightId.uppercased())
            annotation.subtitle = flight.aircraft ?? nil
            
            self?.mapView.addAnnotation(annotation)
            
            OperationQueue.main.addOperation {
                //TODO: Center Map
                self?.mapView.setCenter(location, animated: true)
            }
        }) { [weak self] (error) in
            //TODO: Use error.localizedDescription
            let alert = UIAlertController(title: "Error", message: "An Error occured", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(okAction)
            self?.present(alert, animated: true, completion: nil)
        }
    }
}

extension MainViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let annotation = annotation as? FlightPositionAnnotation else {
            return nil
        }
        
        let identifier = "plane"
        var annotationView: MKPinAnnotationView
        
        if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
            annotationView.annotation = annotation
            return annotationView
        } else {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView.canShowCallout = true
            return annotationView
        }
    }
}

extension MainViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        mapView.becomeFirstResponder()
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        mapView.becomeFirstResponder()
    }
}
