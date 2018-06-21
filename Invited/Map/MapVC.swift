//
//  MapVC.swift
//  Invited
//
//  Created by ShayanSolutions on 6/20/18.
//  Copyright © 2018 ShayanSolutions. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class MapVC: UIViewController,GMSAutocompleteViewControllerDelegate,GMSMapViewDelegate {
    
    
    @IBOutlet var mapView: GMSMapView!
    
    var selectedLocationCoordinate : CLLocationCoordinate2D!
    
    var destinationMarker : GMSMarker?
    
    var destinationLocation : CLLocationCoordinate2D?
    
    @IBOutlet var addressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        self.mapView.isMyLocationEnabled = true
        
        let camera = GMSCameraPosition.camera(withLatitude: (self.selectedLocationCoordinate.latitude), longitude: (self.selectedLocationCoordinate.longitude), zoom: 14.0)
        
        self.mapView?.animate(to: camera)
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton)
    {
        BasicFunctions.setPreferences(self.addressLabel.text, key: kSelectedAddress)
        BasicFunctions.setPreferences(self.destinationLocation?.latitude, key: kSelectedLat)
        BasicFunctions.setPreferences(self.destinationLocation?.longitude, key: kSelectedLong)
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func searchButtonTapped(_ sender: UIButton)
    {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        let northEast = CLLocationCoordinate2DMake(self.selectedLocationCoordinate.latitude + 0.5, self.selectedLocationCoordinate.longitude + 0.5)
        let southWest = CLLocationCoordinate2DMake(self.selectedLocationCoordinate.latitude - 0.5, self.selectedLocationCoordinate.longitude - 0.5)
        
        let predictBounds = GMSCoordinateBounds.init(coordinate: northEast, coordinate: southWest)
        
        autocompleteController.autocompleteBounds = predictBounds
        autocompleteController.autocompleteBoundsMode = GMSAutocompleteBoundsMode.restrict
        
        
        let filter = GMSAutocompleteFilter()
        filter.type = GMSPlacesAutocompleteTypeFilter.establishment
        
        autocompleteController.autocompleteFilter = filter
        
        self.present(autocompleteController, animated: true, completion: nil)

        
    }
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        
        self.dismiss(animated: true) {
            
            self.mapView.animate(toLocation: place.coordinate)
//            self.addressLabel.text = place.formattedAddress
            
            
            
            let marker = GMSMarker(position: place.coordinate)
            marker.title = place.name
            marker.map = self.mapView
            
        }
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        

        self.dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    // MapView Delegate methods.
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        
        //        var destinationLocation = CLLocation()
        let destLocation = CLLocation(latitude: position.target.latitude,  longitude: position.target.longitude)
        self.updateLocationoordinates(coordinates: destLocation.coordinate)
        
        //        if self.mapGesture == true
        //        {
        //        self.mapGesture = false
        //        self.getAddressFromLatLon(location: destinationLocation)
        //        }
    }
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition)
    {
        destinationLocation = CLLocationCoordinate2D.init(latitude: position.target.latitude, longitude: position.target.longitude)
        self.reverseGeocodeCoordinate(self.destinationLocation!)
        
        
    }
    // UpdteLocationCoordinate
    func updateLocationoordinates(coordinates:CLLocationCoordinate2D) {
        if self.destinationMarker == nil
        {
            self.destinationMarker = GMSMarker()
            self.destinationMarker?.position = coordinates
            self.destinationMarker?.icon = UIImage(named:"BlackDot")
            self.destinationMarker?.iconView?.layer.cornerRadius = (self.destinationMarker?.iconView?.frame.size.width)! / 2
            self.destinationMarker?.map = self.mapView
            destinationMarker?.appearAnimation = GMSMarkerAnimation.pop
        }
        else
        {
            CATransaction.begin()
            CATransaction.setAnimationDuration(0)
            self.destinationMarker?.position =  coordinates
            CATransaction.commit()
            
        }
    }
    
    // Reverse GeoCode.
    func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D) {
        
        // 1
        let geocoder = GMSGeocoder()
        
        // 2
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            guard let address = response?.firstResult(), let lines = address.lines else {
                return
            }
            
            // 3
            self.addressLabel.text = lines.joined(separator: "\n")
            

        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
