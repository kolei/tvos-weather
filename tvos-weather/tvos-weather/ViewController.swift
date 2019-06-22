//
//  ViewController.swift
//  tvos-weather
//
//  Created by WSR on 6/21/19.
//  Copyright © 2019 WSR. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {

    @IBOutlet weak var lblCityName: UILabel!
    @IBOutlet weak var lblTemperature: UILabel!
    @IBOutlet weak var imgWeatherIco: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        loadWeatherInfo()
    }

    override func viewWillAppear(_ animated: Bool) {
        loadWeatherInfo()
    }
    
    var cityName = "Москва"
    
    func loadWeatherInfo(){
        if let str = UserDefaults.standard.string(forKey: "cityName") {
            cityName = str
        }
        
        let token = "6da8e8bdb22e1d408ffb437eab399b45"
        var url = "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&apiKey=\(token)&units=metric"
            
        url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        Alamofire.request(url, method: .get).validate().responseJSON {
            response in
            
            switch response.result {
                case .success(let value):
                    let json = JSON(value)
                
                    self.lblTemperature.text = json["main"]["temp"].stringValue+" °C"
                    self.lblCityName.text = self.cityName
                    
                    let icoName = json["weather"][0]["icon"].stringValue
                    
                    if let icoURL = URL(string: "https://openweathermap.org/img/w/\(icoName).png") {
                        if let data = try? Data(contentsOf: icoURL){
                            self.imgWeatherIco.image = UIImage(data: data)
                        }
                }
                case .failure(let error):
                    print(error)
            }
        }
        
    }
}

