//
//  DetailTableViewController.swift
//  Accuweather
//
//  Created by Emre OLGUN on 22.02.2022.
//

import UIKit

class DetailTableViewController: UITableViewController {
    
    //MARK: get city id and name from previous controller
    public var cityId = ""
    public var cityName = ""
    var forecastsResult : [DailyForecast] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        self.title = cityName
        
        //MARK: Request Forecast API
        guard let theURL = URL(string: "https://dataservice.accuweather.com/forecasts/v1/daily/5day/\(cityId)?apikey=QvNJQNuuUWLppX38wtaGAS5gOWOIBIGA") else { print ("Error"); return }
        fetch(url: theURL)
        
        tableView.delegate = self
        tableView.dataSource = self

    }
    
    //MARK: GET API
    func fetch(url:URL) {
        URLSession.shared.request(
            url: url,
            expecting: Forecasts.self
        ) { [weak self] result in
            switch(result) {
            case .success(let forecasts):
                self!.forecastsResult = []
                self!.forecastsResult = forecasts.dailyForecasts
                DispatchQueue.main.async {
                    if self!.forecastsResult.count != 0 {
                        self?.tableView.reloadData()
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //MARK: Convert Fahrenheit to Celsius
    func fahrenheitToCelsius(value: Int) -> Int {
        let ftoc = ((value-32)*5)/9
        return ftoc
    }

    //MARK: TableView
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (forecastsResult.count != 0) {
            return forecastsResult.count
        } else {
            return 0
        }
    }
    
    //MARK: Papulate Data
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailcell" , for: indexPath as IndexPath) as! DetailTableViewCell
        let getDate : String = String(forecastsResult[indexPath.row].date.prefix(10))
        var minC : String = ""
        var maxC : String = ""
        cell.dateTxt.text = getDate
        cell.imgIcon.image = UIImage(named: "weathericon")
        if (forecastsResult[indexPath.row].temperature.minimum.unit != "C") {
            minC = String(describing: fahrenheitToCelsius(value: forecastsResult[indexPath.row].temperature.minimum.value))
        } else {
            minC = String(describing: forecastsResult[0].temperature.minimum.value)
        }
        if (forecastsResult[indexPath.row].temperature.maximum.unit != "C") {
            maxC = String(describing: fahrenheitToCelsius(value: forecastsResult[indexPath.row].temperature.maximum.value))
        } else {
            maxC = String(describing: forecastsResult[0].temperature.maximum.value)
        }
        cell.cTxt.text = "\(NSString(format:"\(minC)%@" as NSString, "\u{00B0}") as String) / \(NSString(format:"\(maxC)%@" as NSString, "\u{00B0}") as String)"
        
        return cell
    }
    
    //MARK: Navigation and Status Bar Color
    override func viewWillAppear(_ animated: Bool) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 1.0)
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationController?.navigationBar.standardAppearance = appearance;
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
    
        let statusBar = UIView()
        statusBar.frame = UIApplication.shared.statusBarFrame
        statusBar.backgroundColor = UIColor(red: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 1.0)
        
        UIApplication.shared.keyWindow?.addSubview(statusBar)
        self.tabBarController?.tabBar.isHidden = false
        super.viewWillAppear(animated)
    }

}
