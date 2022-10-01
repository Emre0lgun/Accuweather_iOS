//
//  ViewController.swift
//  Accuweather
//
//  Created by Emre OLGUN on 23.02.2022.
//

import UIKit
import CoreLocation

class ViewController: UITableViewController, UISearchBarDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    var weatherArray : [Weather] = []
    var locCityName : [String] = []
    var locCityKey: [String] = []
    let locationManager = CLLocationManager()
    var lat = ""
    var long = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        
        self.title = "Weather"
        
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            lat = String(format: "%.1f", location.coordinate.latitude)
            long = String(format: "%.1f", location.coordinate.longitude)
            if lat.count != 0 && long.count != 0 {
                guard let theURL = URL(string: "https://dataservice.accuweather.com/locations/v1/cities/geoposition/search?apikey=sgKEFAV8p3fa6D12Q5pH1700KutVzwSA&q=\(lat),\(long)") else { print ("Error"); return }
                
                fetchFromLoc(url: theURL)
            }
            // Handle location update
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if weatherArray.count != 0 {
            return weatherArray.count
        } else if locCityName.count != 0 {
            return locCityName.count
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "detailscreen") as? DetailViewController
        if weatherArray.count != 0 {
            vc!.cityKey = weatherArray[indexPath.row].key!
            vc!.cityName = weatherArray[indexPath.row].localizedName
        } else if locCityName.count != 0 {
            vc!.cityKey = locCityKey[indexPath.row]
            vc!.cityName = locCityName[indexPath.row]
        }
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            //MARK: Request Location API
        if searchText.count < 3 {
            weatherArray = []
            locCityName = []
            locCityKey = []
            if(lat.count != 0 && long.count != 0) {
                guard let theURL = URL(string: "https://dataservice.accuweather.com/locations/v1/cities/geoposition/search?apikey=sgKEFAV8p3fa6D12Q5pH1700KutVzwSA&q=\(lat),\(long)") else { print ("Error"); return }
                
                fetchFromLoc(url: theURL)
            }
            self.tableView.reloadData()
        } else {
            weatherArray = []
            locCityName = []
            locCityKey = []
            guard let theURL = URL(string: "http://dataservice.accuweather.com/locations/v1/cities/search?apikey=sgKEFAV8p3fa6D12Q5pH1700KutVzwSA&q=\(searchText)") else { print ("Error"); return }
            fetchAPI(url: theURL)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        if weatherArray.count != 0 {
            cell.textLabel?.text = "\(weatherArray[indexPath.row].localizedName) - \(weatherArray[indexPath.row].country.localizedName)"
        } else if locCityName.count != 0 {
            cell.textLabel?.text = "\(locCityName[indexPath.row])"
        }
        return cell
    }
    
    func fetchAPI(url:URL) {
        URLSession.shared.request(
            url: url,
            expecting: [Weather].self
        ) { [weak self] result in
            switch(result) {
            case .success(let weather):
                self!.weatherArray = []
                self!.weatherArray = weather
                DispatchQueue.main.async {
                    if self!.weatherArray.count != 0 {
                        self!.tableView.reloadData()
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    func fetchFromLoc(url:URL) {
        URLSession.shared.request(
            url: url,
            expecting: LocWeather.self
        ) { [weak self] result in
            switch(result) {
            case .success(let locweatherdata):
                self!.locCityKey = []
                self!.locCityName = []
                self!.locCityName.append(locweatherdata.localizedName)
                self!.locCityKey.append(locweatherdata.key!)
                DispatchQueue.main.async {
                    if self!.locCityName.count != 0 {
                        self?.tableView.reloadData()
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }

}

extension URLSession {
    enum CustomError: Error {
        case invalidUrl
        case invalidData
    }
    
    func request<T: Codable>(
        url: URL?,
        expecting: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        guard let url = url else {
            completion(.failure(CustomError.invalidUrl))
            return
        }
        
        let task = dataTask(with: url) { data, _, error in
            guard let data = data else {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(CustomError.invalidData))
                }
                return
            }
            
            do {
                let cityId = try JSONDecoder().decode(expecting, from: data)
                completion(.success(cityId))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
        
    }
}
