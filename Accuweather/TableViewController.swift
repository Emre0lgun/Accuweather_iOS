

import UIKit
import CoreLocation

class TableViewController: UITableViewController, UISearchBarDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate {
    
    var weatherResult : [Weather] = []
    var locWeatherResult : [LocationsWeather] = []
    var locCityName : [String] = []
    var locCityId : [String] = []
    var historyArray : [String] = []
    var lat = "", long = ""
    @IBOutlet weak var searchBar: UISearchBar!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        self.title = "Accuweather"
        //MARK: when tableview scroll, keyboard dismiss
        tableView.keyboardDismissMode = .onDrag
        searchBar.delegate = self
        
        //MARK: Location Request and Enabled
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    //MARK: SearchBar Button Clicked in Keyboard Action
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    //MARK: Get Location Latitude and Longtitude
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        lat = String(format: "%.1f", locValue.latitude)
        long = String(format: "%.1f", locValue.longitude)
        
        guard let theURL = URL(string: "https://dataservice.accuweather.com/locations/v1/cities/geoposition/search?apikey=QvNJQNuuUWLppX38wtaGAS5gOWOIBIGA&q=\(String(format: "%.1f", locValue.latitude)),\(String(format: "%.1f", locValue.longitude))") else {print ("Error"); return }
        self.fetchFromLoc(url: theURL)
    }
    

    //MARK: TableView
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if (weatherResult.count != 0) {
            locCityName = []
            historyArray = []
            return weatherResult.count
        } else if locCityName.count != 0 {
            weatherResult = []
            historyArray = []
            return locCityName.count
        } else if historyArray.count != 0 {
            locCityName = []
            weatherResult = []
            if historyArray.count > 6 {
                return 5
            } else {
                return historyArray.count
            }
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        
        if weatherResult.count != 0 {
            cell.textLabel?.text = "\(weatherResult[indexPath.row].localizedName) - \(weatherResult[indexPath.row].country.localizedName)"
        } else if locCityName.count != 0 {
            cell.textLabel?.text = "Konumunuz: \(locCityName[indexPath.row])"
        } else if historyArray.count != 0 {
            if historyArray.count < 6 {
                cell.textLabel?.text = historyArray[indexPath.row]
            } else {
                if indexPath.row <= 4 {
                    var reversedNames : [String] = []
                    reversedNames = Array(historyArray.reversed())
                    cell.textLabel?.text = reversedNames[indexPath.row]
                }
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //MARK: Detail Screen Action
        if weatherResult.count != 0 {
            let defaults = UserDefaults.standard
            if let history = defaults.stringArray(forKey: "savedHistoryArray") {
                print("Favorites exists")

                if history.isEmpty {
                    if historyArray.count != 0 {
                        if historyArray[indexPath.row] != weatherResult[indexPath.row].localizedName {
                            historyArray.append(weatherResult[indexPath.row].localizedName)
                        }
                    } else {
                        historyArray.append(weatherResult[indexPath.row].localizedName)
                    }
                } else {
                    historyArray = defaults.stringArray(forKey: "savedHistoryArray") ?? [String]()
                    var checkString : String = weatherResult[indexPath.row].localizedName
                    if historyArray[indexPath.row] != weatherResult[indexPath.row].localizedName {
                        historyArray.append(weatherResult[indexPath.row].localizedName)
                    }
                }
            } else {
                print("Favorites is nil")
            }
            /*if historyArray.isEmpty {
                /*historyArray = defaults.stringArray(forKey: "savedHistoryArray") ?? [String]()
                var checkString : String = weatherResult[indexPath.row].localizedName
                if historyArray[indexPath.row] != weatherResult[indexPath.row].localizedName {
                    historyArray.append(weatherResult[indexPath.row].localizedName)
                }*/
            } else {
                /*if historyArray[indexPath.row] != weatherResult[indexPath.row].localizedName {
                    historyArray.append(weatherResult[indexPath.row].localizedName)
                }*/
                print("emre")
            }*/
            defaults.removeObject(forKey: "savedHistoryArray")
            defaults.set(historyArray, forKey: "savedHistoryArray")
            
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "detailpage") as? DetailTableViewController
            vc?.cityId = weatherResult[indexPath.row].key
            vc?.cityName = weatherResult[indexPath.row].localizedName
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        //MARK: Detail Page with Location
        else if locCityName.count != 0 {
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "detailpage") as? DetailTableViewController
            vc?.cityId = locCityId[indexPath.row]
            vc?.cityName = locCityName[indexPath.row]
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        //MARK: Searchbar History
        else if historyArray.count != 0 {
            if historyArray.count < 6 {
                searchBar.text = historyArray[indexPath.row]
                print(searchBar.text!.count)
                if searchBar.text!.count > 3 {
                    if searchBar.isFirstResponder {
                        self.weatherResult = []
                        self.locCityName = []
                        self.locCityId = []
                        self.historyArray = []
                        self.tableView.reloadData()
                        guard let theURL = URL(string: "https://dataservice.accuweather.com/locations/v1/cities/search?apikey=QvNJQNuuUWLppX38wtaGAS5gOWOIBIGA&q=\(historyArray[indexPath.row])") else { print ("Error"); return }
                        fetch(url: theURL)
                    }
                }
            } else {
                if indexPath.row <= 4 {
                    var reversedNames : [String] = []
                    reversedNames = Array(historyArray.reversed())
                    searchBar.text = reversedNames[indexPath.row]
                    if searchBar.text!.count > 3 {
                        if searchBar.isFirstResponder {
                            self.weatherResult = []
                            self.locCityName = []
                            self.locCityId = []
                            self.historyArray = []
                            self.tableView.reloadData()
                            guard let theURL = URL(string: "https://dataservice.accuweather.com/locations/v1/cities/search?apikey=QvNJQNuuUWLppX38wtaGAS5gOWOIBIGA&q=\(reversedNames[indexPath.row])") else { print ("Error"); return }
                            fetch(url: theURL)
                        }
                    }
                }
            }
        }
    
    }
    
    //MARK: Request Location API
    func fetchFromLoc(url:URL) {
        URLSession.shared.request(
            url: url,
            expecting: LocationsWeather.self
        ) { [weak self] result in
            switch(result) {
            case .success(let locWeather):
                self!.locCityName = []
                self!.locCityId = []
                self!.locCityName.append(locWeather.localizedName)
                self!.locCityId.append(locWeather.key)
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
    
    //MARK: Request SearchText API
    func fetch(url:URL) {
        URLSession.shared.request(
            url: url,
            expecting: [Weather].self
        ) { [weak self] result in
            switch(result) {
            case .success(let weather):
                self!.weatherResult = []
                self!.weatherResult = weather
                DispatchQueue.main.async {
                    if self!.weatherResult.count != 0 {
                        self?.tableView.reloadData()
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    
    //MARK: SearchBar Function
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //MARK: Request Location API
        if searchText.count == 0 {
            print("emre")
            weatherResult = []
            locCityName = []
            locCityId = []
            historyArray = []
            guard let theURL = URL(string: "https://dataservice.accuweather.com/locations/v1/cities/geoposition/search?apikey=QvNJQNuuUWLppX38wtaGAS5gOWOIBIGA&q=\(self.lat),\(self.long)") else {print ("Error"); return }
            self.fetchFromLoc(url: theURL)
            self.tableView.reloadData()
        } else if 1 <= searchText.count && searchText.count < 3 {
            //MARK: Show History on SearchBar
            weatherResult = []
            locCityName = []
            locCityId = []
            let defaults = UserDefaults.standard
            historyArray = defaults.stringArray(forKey: "savedHistoryArray") ?? [String]()
            self.tableView.reloadData()
        } else if(searchText.count > 3) {
            //MARK: Request Search API
            self.weatherResult = []
            self.locCityName = []
            self.locCityId = []
            self.historyArray = []
            self.tableView.reloadData()
            if (searchText.count != 0) {
                guard let theURL = URL(string: "https://dataservice.accuweather.com/locations/v1/cities/search?apikey=QvNJQNuuUWLppX38wtaGAS5gOWOIBIGA&q=\(searchText)") else { print ("Error"); return }
                fetch(url: theURL)
            }
        }
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
    
    //Back Button Action
    @IBAction func backFromSearch(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }


}

//MARK: Request API
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

//MARK: Keyboard Dismiss
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
