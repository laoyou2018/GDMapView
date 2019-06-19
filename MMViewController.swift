//
//  MMViewController.swift
//  CustomBusDemo
//
//  Created by zhonghangxun on 2019/4/9.
//  Copyright © 2019 wangxiangbo. All rights reserved.
//

import UIKit

class MMViewController: WLYBaseViewController, MAMapViewDelegate {

    var mapView: MAMapView!
    var locationAnnotationView: LocationAnnotationView!

    func mapView(_ mapView: MAMapView!, rendererFor overlay: MAOverlay!) -> MAOverlayRenderer! {
        if overlay.isEqual(mapView.userLocationAccuracyCircle) {
            let accuracyCircleRender: MACircleRenderer? = MACircleRenderer.init(circle: (overlay as? MACircle?)!)

            accuracyCircleRender?.lineWidth = 2.0
            accuracyCircleRender?.strokeColor = UIColor.lightGray
            accuracyCircleRender?.fillColor = UIColor.init(red: 1, green: 0, blue: 0, alpha: 0.3)

            return accuracyCircleRender
        }

        return nil
    }

    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        if annotation.isKind(of: MAUserLocation.self) {
            let userLocationStyleReuseIndetifier = "userLocationStyleReuseIndetifier"

            var annotationView: MAAnnotationView! = mapView.dequeueReusableAnnotationView(withIdentifier: userLocationStyleReuseIndetifier)

            if annotationView == nil {
                annotationView = LocationAnnotationView(annotation: annotation, reuseIdentifier: userLocationStyleReuseIndetifier)
                annotationView.canShowCallout = true
            }

            locationAnnotationView = annotationView as? LocationAnnotationView
            locationAnnotationView.updateImage(image: UIImage(named: "userPosition"))

            return annotationView
        }

        return nil
    }

    func mapView(_ mapView: MAMapView!, didUpdate userLocation: MAUserLocation!, updatingLocation: Bool) {
        if !updatingLocation && locationAnnotationView != nil {
            self.locationAnnotationView.rotateDegree = CGFloat(userLocation.heading.trueHeading) - mapView.rotationDegree
        }
    }

    func mapViewRequireLocationAuth(_ locationManager: CLLocationManager!) {
        locationManager.requestAlwaysAuthorization()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        AMapServices.shared().enableHTTPS = true

        mapView = MAMapView(frame: view.bounds)
        mapView.delegate = self
        mapView.customizeUserLocationAccuracyCircleRepresentation = true

        view.addSubview(mapView)

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mapView.userTrackingMode = .follow
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
