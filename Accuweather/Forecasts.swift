
import Foundation

struct Forecasts: Codable {
    let dailyForecasts: [DailyForecast]

    enum CodingKeys: String, CodingKey {
        case dailyForecasts = "DailyForecasts"
    }
}

// MARK: - DailyForecast
struct DailyForecast: Codable {
    let date: String
    let temperature: Temperature
    let day: Day
    let night: Night

    enum CodingKeys: String, CodingKey {
        case date = "Date"
        case temperature = "Temperature"
        case day = "Day"
        case night = "Night"
    }
}

// MARK: - Day
struct Day: Codable {
    let icon: Int
    let iconPhrase: String
    let hasPrecipitation: Bool

    enum CodingKeys: String, CodingKey {
        case icon = "Icon"
        case iconPhrase = "IconPhrase"
        case hasPrecipitation = "HasPrecipitation"
    }
}

// MARK: - Night
struct Night: Codable {
    let icon: Int
    let iconPhrase: String
    let hasPrecipitation: Bool
    let precipitationType, precipitationIntensity: String?

    enum CodingKeys: String, CodingKey {
        case icon = "Icon"
        case iconPhrase = "IconPhrase"
        case hasPrecipitation = "HasPrecipitation"
        case precipitationType = "PrecipitationType"
        case precipitationIntensity = "PrecipitationIntensity"
    }
}

// MARK: - Temperature
struct Temperature: Codable {
    let minimum, maximum: Imum

    enum CodingKeys: String, CodingKey {
        case minimum = "Minimum"
        case maximum = "Maximum"
    }
}

// MARK: - Imum
struct Imum: Codable {
    let value: Int
    let unit: String
    let unitType: Int

    enum CodingKeys: String, CodingKey {
        case value = "Value"
        case unit = "Unit"
        case unitType = "UnitType"
    }
}
