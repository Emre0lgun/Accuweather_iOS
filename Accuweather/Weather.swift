
import Foundation

struct Weather: Codable {
    let version: Int?
    let key, type: String?
    let rank: Int
    let localizedName, englishName, primaryPostalCode: String
    let region, country: Country
    let administrativeArea: AdministrativeArea
    let geoPosition: GeoPosition
    let isAlias: Bool
    let supplementalAdminAreas: [SupplementalAdminArea]
    let dataSets: [String]

    enum CodingKeys: String, CodingKey {
        case version = "Version"
        case key = "Key"
        case type = "Type"
        case rank = "Rank"
        case localizedName = "LocalizedName"
        case englishName = "EnglishName"
        case primaryPostalCode = "PrimaryPostalCode"
        case region = "Region"
        case country = "Country"
        case administrativeArea = "AdministrativeArea"
        case geoPosition = "GeoPosition"
        case isAlias = "IsAlias"
        case supplementalAdminAreas = "SupplementalAdminAreas"
        case dataSets = "DataSets"
    }
}

// MARK: - AdministrativeArea
struct AdministrativeArea: Codable {
    let id, localizedName, englishName: String
    let level: Int
    let localizedType, englishType, countryID: String

    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case localizedName = "LocalizedName"
        case englishName = "EnglishName"
        case level = "Level"
        case localizedType = "LocalizedType"
        case englishType = "EnglishType"
        case countryID = "CountryID"
    }
}

// MARK: - Country
struct Country: Codable {
    let id, localizedName, englishName: String

    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case localizedName = "LocalizedName"
        case englishName = "EnglishName"
    }
}

// MARK: - GeoPosition
struct GeoPosition: Codable {
    let latitude, longitude: Double
    let elevation: Elevation

    enum CodingKeys: String, CodingKey {
        case latitude = "Latitude"
        case longitude = "Longitude"
        case elevation = "Elevation"
    }
}

// MARK: - Elevation
struct Elevation: Codable {
    let metric, imperial: Imperial

    enum CodingKeys: String, CodingKey {
        case metric = "Metric"
        case imperial = "Imperial"
    }
}

// MARK: - Imperial
struct Imperial: Codable {
    let value: Int
    let unit: String
    let unitType: Int

    enum CodingKeys: String, CodingKey {
        case value = "Value"
        case unit = "Unit"
        case unitType = "UnitType"
    }
}

// MARK: - SupplementalAdminArea
struct SupplementalAdminArea: Codable {
    let level: Int
    let localizedName, englishName: String

    enum CodingKeys: String, CodingKey {
        case level = "Level"
        case localizedName = "LocalizedName"
        case englishName = "EnglishName"
    }
}
