//
//  ViewController.swift
//  MutatingAnnotationsCrash
//
//  Created by Robert Ryan on 4/27/20.
//  Copyright © 2020 Robert Ryan. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!

    private var annotations: [CustomAnnotation] = []
    private let annotationChangeQueue = DispatchQueue(label: "...", target: .main)
    private weak var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()

        configureMapView()

        startTimerToUpdateAnnotationCoordinates()
    }
}

// MARK: - Private utility methods

private extension ViewController {
    func configureMapView() {
        mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.register(CustomClusterAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)

        // start at Apple

        mapView.camera = MKMapCamera(lookingAtCenter: CLLocationCoordinate2D(latitude: 37.332693, longitude: -122.03071), fromDistance: 1000, pitch: 0, heading: 0)
        addAnnotations()
    }

    func startTimerToUpdateAnnotationCoordinates() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.updateAnnotations()
        }
    }

    func addAnnotations() {
        let center = mapView.region.center
        let span = mapView.region.span
        let latitudeSpan = center.latitude - span.latitudeDelta / 2 ... center.latitude + span.latitudeDelta / 2
        let longitudeSpan = center.longitude - span.longitudeDelta / 2 ... center.longitude + span.longitudeDelta / 2

        for i in 0 ..< 100 {
            let coordinate = CLLocationCoordinate2D(latitude: .random(in: latitudeSpan), longitude: .random(in: longitudeSpan))
            let annotation = CustomAnnotation()
            annotation.coordinate = coordinate
            annotation.direction = .random(in: -180...180)
            annotation.title = "\(i)"
            annotations.append(annotation)
            mapView.addAnnotation(annotation)
        }
    }

    func updateAnnotations() {
        annotationChangeQueue.async {
            UIView.animate(withDuration: 0.5) {
                for annotation in self.annotations {
                    let coordinate = annotation.coordinate.adjusted(distance: 0.005, degrees: annotation.direction)
                    annotation.coordinate = coordinate
                }
            }
        }
    }
}

// MARK: - MKMapViewDelegate

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        if let timer = timer {
            timer.invalidate()
        } else {
            annotationChangeQueue.suspend()
        }
    }

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: false) { [weak self] _ in
            self?.annotationChangeQueue.resume()
        }
    }
}
