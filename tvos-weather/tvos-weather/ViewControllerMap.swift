//
//  ViewControllerMap.swift
//  tvos-weather
//
//  Created by WSR on 6/22/19.
//  Copyright © 2019 WSR. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import SwiftyJSON

class ViewControllerMap: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var tfCityName: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var viewBG: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        viewBG.isHidden = true
        tfCityName.updateFocusIfNeeded()
        
        tfCityName.delegate = self
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func showCityOnMap(lon: Double, lat: Double){
        let regionRadius: CLLocationDistance = 10000
        let coordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: lon), latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func searchCity(city: String){
        let apiKey = "6da8e8bdb22e1d408ffb437eab399b45"

        var url = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&apiKey=\(apiKey)&units=metric"
        
        url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        Alamofire.request(url).validate().responseJSON { response in
            
            switch response.result {
            case .success(let value):
                UserDefaults.standard.set(city, forKey: "cityName")
                
                let json = JSON(value)
                
                let lon = json["coord"]["lon"].doubleValue
                let lat = json["coord"]["lat"].doubleValue
                
                self.showCityOnMap(lon: lon, lat: lat)
                
                self.viewBG.isHidden = false
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchCity(city: tfCityName.text!)
        return true
    }
}
