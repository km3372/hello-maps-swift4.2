//
//  ViewController.swift
//  hello-maps-swift4.2
//
//  Created by kenneth moody on 3/5/19.
//  Copyright © 2019 Kenneth Moody Sr. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapTypeSegmentedControl: UISegmentedControl!
    private let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        
        self.mapView.showsUserLocation = true
        self.mapTypeSegmentedControl.addTarget(self, action: #selector(mapTypeChanged), for: .valueChanged)
    }
    
    @objc func mapTypeChanged(segmentControl: UISegmentedControl) {
        
        switch (segmentControl.selectedSegmentIndex) {
        case 0:
            self.mapView.mapType = .standard
        case 1:
            self.mapView.mapType = .satellite
        case 2:
            self.mapView.mapType = .hybrid
        default:
             self.mapView.mapType = .standard
        }
    }
    
    @IBAction func addAnnotationButtonPressed() {
        
        let annotation = CoffeeAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: 37.331820, longitude: -122.031180)
        annotation.title = "Coffee Shop"
        annotation.subtitle = "Get your delicious coffee!"
        annotation.imageURL = "coffee-pin.png"
        
        self.mapView.addAnnotation(annotation)
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        
        var coffeeAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "CoffeeAnnotationView") as? MKMarkerAnnotationView
        
        if coffeeAnnotationView == nil {
            
            coffeeAnnotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "CoffeeAnnotationView")
            
            coffeeAnnotationView?.glyphText = "☕️"
            
            coffeeAnnotationView?.markerTintColor = UIColor.purple
            
            coffeeAnnotationView?.glyphTintColor = UIColor.white
            
            coffeeAnnotationView?.canShowCallout = true
        } else {
            coffeeAnnotationView?.annotation = annotation
        }
        /*
        if let coffeeAnnotation = annotation as? CoffeeAnnotation {
            coffeeAnnotationView?.image = UIImage(named: coffeeAnnotation.imageURL)
        }*/
        
        configureView(coffeeAnnotationView)
        return coffeeAnnotationView
        
    }
    
    private func configureView(_ annotationView: MKAnnotationView?) {
        
        let snapShotSize = CGSize(width: 200, height: 200)
        
        let snapShotView = UIView(frame :CGRect.zero)
        snapShotView.translatesAutoresizingMaskIntoConstraints = false
        snapShotView.widthAnchor.constraint(equalToConstant: snapShotSize.width).isActive = true
        snapShotView.heightAnchor.constraint(equalToConstant: snapShotSize.height).isActive = true
        
        let options = MKMapSnapshotter.Options()
        options.size = snapShotSize
        options.mapType = .satelliteFlyover
        options.camera = MKMapCamera(lookingAtCenter: (annotationView?.annotation?.coordinate)!, fromDistance: 10, pitch: 65, heading: 0)
        
        let snapshotter = MKMapSnapshotter(options: options)
        snapshotter.start { (snapshot, error) in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let snapshot = snapshot {
                
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: snapShotSize.width, height: snapShotSize.height))
                imageView.image = snapshot.image
                snapShotView.addSubview(imageView)
                
            }
            
        }
        
        
        annotationView?.leftCalloutAccessoryView = snapShotView
        
    }
    
    
    
    
    /*
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        let region = MKCoordinateRegion(center: mapView.userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.008, longitudeDelta: 0.008))
        
        mapView.setRegion(region, animated: true)
    } */
    
}

