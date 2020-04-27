//
//  CustomAnnotationView.swift
//  MutatingAnnotationsCrash
//
//  Created by Robert Ryan on 4/27/20.
//  Copyright © 2020 Robert Ryan. All rights reserved.
//

import MapKit

class CustomAnnotationView: MKMarkerAnnotationView {
    static let clusteringIdentifier = "CustomAnnotationView"

    override var annotation: MKAnnotation? {
        didSet {
            clusteringIdentifier = CustomAnnotationView.clusteringIdentifier
            displayPriority = .required
        }
    }

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = CustomAnnotationView.clusteringIdentifier
        displayPriority = .required
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
