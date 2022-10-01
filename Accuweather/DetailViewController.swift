//
//  DetailViewController.swift
//  Accuweather
//
//  Created by Emre OLGUN on 23.02.2022.
//

import UIKit

class DetailViewController: UITableViewController {
    
    public var cityKey = ""
    public var cityName = ""
    var forecastsResult : [DailyForecast] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        print(cityKey)
        
        self.title = cityName
        guard let theURL = URL(string: "https://dataservice.accuweather.com/forecasts/v1/daily/5day/\(cityKey)?apikey=sgKEFAV8p3fa6D12Q5pH1700KutVzwSA") else { print ("Error"); return }
        forecastAPI(url: theURL)
    }

    // MARK: - Table view data source
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var minValue = ""
        var maxValue = ""
        
        if let viewWithTag = self.view.viewWithTag(1) {
            viewWithTag.removeFromSuperview()
        }
        let label = UILabel(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.width / 2 - 10, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        label.numberOfLines = 0
        label.tag = 1
        label.contentMode = .bottom
        label.textAlignment = .center
        if (forecastsResult[indexPath.row].temperature.maximum.unit == "F") {
             maxValue = "\(NSString(format:"\(fahrenheitToCelsius(value: forecastsResult[indexPath.row].temperature.maximum.value)) %@" as NSString, "\u{00B0}") as String)"
        } else {
            maxValue = "\(NSString(format:"\(forecastsResult[indexPath.row].temperature.maximum.value) %@" as NSString, "\u{00B0}") as String)"
        }
        if (forecastsResult[indexPath.row].temperature.minimum.unit == "F") {
            minValue = "\(NSString(format:"\(fahrenheitToCelsius(value: forecastsResult[indexPath.row].temperature.minimum.value)) %@" as NSString, "\u{00B0}") as String)"
        } else {
            minValue = "\(NSString(format:"\(forecastsResult[indexPath.row].temperature.minimum.value) %@" as NSString, "\u{00B0}") as String)"
        }
        label.text = "\(cityName) \n \(forecastsResult[indexPath.row].date.prefix(10)) \(weekDayName(stringDate: String(forecastsResult[indexPath.row].date.prefix(10)))) \n Minimum Sıcaklık: \(minValue) \n Maksimum Sıcaklık: \(maxValue)"
        self.view.addSubview(label)
    }
        
    //MARK: Papulate Data
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailcell" , for: indexPath as IndexPath) as! DetailViewCell
        let getDate : String = String(forecastsResult[indexPath.row].date.prefix(10))
        cell.dateLabel.text = weekDayName(stringDate: String(forecastsResult[indexPath.row].date.prefix(10)))
        let url : URL
        if (forecastsResult[indexPath.row].day.icon > 9) {
            url = URL(string: "https://developer.accuweather.com/sites/default/files/\(forecastsResult[indexPath.row].day.icon)-s.png")!
        } else {
            url = URL(string: "https://developer.accuweather.com/sites/default/files/0\(forecastsResult[indexPath.row].day.icon)-s.png")!
        }
        if let data = try? Data(contentsOf: url) {
            cell.weatherIcon.image = UIImage(data: data)
        }
        if (forecastsResult[indexPath.row].temperature.maximum.unit == "F") {
            cell.degreeLabel.text = "\(NSString(format:"\(fahrenheitToCelsius(value: forecastsResult[indexPath.row].temperature.maximum.value)) %@" as NSString, "\u{00B0}") as String) / \(NSString(format:"\(fahrenheitToCelsius(value: forecastsResult[indexPath.row].temperature.minimum.value)) %@" as NSString, "\u{00B0}") as String)"
        } else {
            cell.degreeLabel.text = "\(forecastsResult[indexPath.row].temperature.maximum.value) / \(forecastsResult[indexPath.row].temperature.minimum.value)"
        }
            
        return cell
    }
    
    func fahrenheitToCelsius(value: Int) -> Int {
        let ftoc = ((value-32)*5)/9
        return ftoc
    }
    
    func weekDayName(stringDate : String) -> String {
        var weekDay: String = ""
        let stringDate = stringDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: stringDate)
        
        let dateFormatterDay = DateFormatter()
        dateFormatterDay.dateFormat = "EEEE"

        let currentDateString: String = dateFormatterDay.string(from: date!)
        
        switch currentDateString {
        case "Monday":
            weekDay = "Pazartesi"
        case "Tuesday":
            weekDay = "Salı"
        case "Wednesday":
            weekDay = "Çarşamba"
        case "Thursday":
            weekDay = "Perşembe"
        case "Friday":
            weekDay = "Cuma"
        case "Saturday":
            weekDay = "Cumartesi"
        case "Sunday":
            weekDay = "Pazar"
        default:
            weekDay = currentDateString
        }
        
        return weekDay
    }
    
    func forecastAPI(url:URL) {
        URLSession.shared.request(
            url: url,
            expecting: Forecasts.self
        ) { [weak self] result in
            switch(result) {
            case .success(let forecasts):
                self?.forecastsResult = []
                self!.forecastsResult = forecasts.dailyForecasts
                print(forecasts.dailyForecasts)
                DispatchQueue.main.async {
                    if self!.forecastsResult.count != 0 {
                        self!.tableView.reloadData()
                        
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }

}
