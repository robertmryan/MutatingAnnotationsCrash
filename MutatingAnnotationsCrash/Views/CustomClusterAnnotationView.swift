//
//  CustomClusterAnnotationView.swift
//  MutatingAnnotationsCrash
//
//  Created by Robert Ryan on 4/27/20.
//  Copyright © 2020 Robert Ryan. All rights reserved.
//

import MapKit

class CustomClusterAnnotationView: MKMarkerAnnotationView {
    static let clusteringIdentifier = "CustomClusterAnnotationView"

    override var annotation: MKAnnotation? {
        didSet {
            clusteringIdentifier = CustomClusterAnnotationView.clusteringIdentifier
            displayPriority = .required
        }
    }

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = CustomClusterAnnotationView.clusteringIdentifier
        displayPriority = .required
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
