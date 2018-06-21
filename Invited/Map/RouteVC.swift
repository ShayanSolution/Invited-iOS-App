//
//  RouteVC.swift
//  Invited
//
//  Created by ShayanSolutions on 6/21/18.
//  Copyright © 2018 ShayanSolutions. All rights reserved.
//

import UIKit
import GoogleMaps
import SwiftyJSON


class RouteVC: UIViewController,GMSMapViewDelegate {
    
    @IBOutlet var mapView: GMSMapView!
    
    var originLocationCoordinate : CLLocationCoordinate2D!
    var destinationLocationCoordinate : CLLocationCoordinate2D!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.mapView.isMyLocationEnabled = true
        
        let camera = GMSCameraPosition.camera(withLatitude: (self.originLocationCoordinate.latitude), longitude: (self.originLocationCoordinate.longitude), zoom: 10.0)
        
        self.mapView?.animate(to: camera)
        
        let marker = GMSMarker(position: self.destinationLocationCoordinate)
//        marker.title = place.name
        marker.map = self.mapView
        
        self.drawRoute()
    }
    
    @IBAction func doneButtonTapped(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func drawRoute()
    {
        
        var urlString = "\("https://maps.googleapis.com/maps/api/directions/json")?origin=\(self.originLocationCoordinate.latitude),\(self.originLocationCoordinate.longitude)&destination=\(self.destinationLocationCoordinate.latitude),\(self.destinationLocationCoordinate.longitude)&key=\("AIzaSyA_B8TqI8SsiDi_l5tV9rwrzjRvYSy1wsc")&sensor=true"
        
        urlString = urlString.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        
        let manager=AFHTTPRequestOperationManager()
        
        manager.responseSerializer = AFJSONResponseSerializer(readingOptions: JSONSerialization.ReadingOptions.allowFragments) as AFJSONResponseSerializer
        
        manager.requestSerializer = AFJSONRequestSerializer() as AFJSONRequestSerializer
        
        manager.responseSerializer.acceptableContentTypes = NSSet(objects:"application/json", "text/html", "text/plain", "text/json", "text/javascript", "audio/wav") as Set<NSObject>
        
        
        manager.post(urlString, parameters: nil, constructingBodyWith: { (formdata:AFMultipartFormData!) -> Void in
            
        }, success: {  operation, response -> Void in
            //{"responseString" : "Success","result" : {"userId" : "4"},"errorCode" : 1}
            //if(response != nil){
            let parsedData = JSON(response)
            print("parsedData : \(parsedData)")
            
            let status = parsedData["status"].string
            
            if status == "OK"
            {
            
            let path = GMSPath.init(fromEncodedPath: parsedData["routes"][0]["overview_polyline"]["points"].string!)
            //GMSPath.fromEncodedPath(parsedData["routes"][0]["overview_polyline"]["points"].string!)
            let singleLine = GMSPolyline.init(path: path)
            singleLine.strokeWidth = 7
            singleLine.strokeColor = UIColor.blue
            singleLine.map = self.mapView
            //let loginResponeObj=LoginRespone.init(fromJson: parsedData)
            }
            
            
            //  }
        }, failure: {  operation, error -> Void in
            
            print(error)
//            let errorDict = NSMutableDictionary()
//            errorDict.setObject(ErrorCodes.errorCodeFailed.rawValue, forKey: ServiceKeys.keyErrorCode.rawValue as NSCopying)
//            errorDict.setObject(ErrorMessages.errorTryAgain.rawValue, forKey: ServiceKeys.keyErrorMessage.rawValue as NSCopying)
//
        })
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
