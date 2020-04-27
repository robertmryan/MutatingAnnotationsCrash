//
//  CLLocationCoordinate+AdjustCoordinate.swift
//  MutatingAnnotationsCrash
//
//  Created by Robert Ryan on 4/27/20.
//  Copyright © 2020 Robert Ryan. All rights reserved.
//

import MapKit

extension CLLocationCoordinate2D {
    func adjusted(distance: Double, degrees: Double) -> CLLocationCoordinate2D {
        let distanceRadians = distance / 6371  // 6,371 == Earth's radius in km
        let bearingRadians = degrees.radians
        let fromLatRadians = latitude.radians
        let fromLonRadians = longitude.radians

        let toLatRadians = asin(sin(fromLatRadians) * cos(distanceRadians) + cos(fromLatRadians) * sin(distanceRadians) * cos(bearingRadians))

        var toLonRadians = fromLonRadians + atan2(sin(bearingRadians)
                                                     * sin(distanceRadians) * cos(fromLatRadians), cos(distanceRadians)
                                                     - sin(fromLatRadians) * sin(toLatRadians))

        // adjust toLonRadians to be in the range -180 to +180...
        toLonRadians = fmod((toLonRadians + 3 * .pi), (2 * .pi)) - .pi

        return CLLocationCoordinate2D(latitude: toLatRadians.degrees, longitude: toLonRadians.degrees)
    }
}

extension CLLocationDegrees {
    var radians: Double { self * .pi / 180 }
}

extension Double {
    var degrees: CLLocationDegrees { self * 180 / .pi }
}
